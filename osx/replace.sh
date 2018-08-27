#!/bin/bash

# homebrew command check
if !(type brew --prefix > /dev/null 2>&1); then
  echo "homebrew not found" >&2
fi

homebrewdir=`brew --prefix`

# add fomulae ripository
brew tap leico/avr
brew tap PX4/homebrew-px4

# install requires
brew update
brew install avr-gcc@8_1
brew install dfu-programmer
brew install dfu-util
brew install gcc-arm-none-eabi
brew install avrdude
brew install teensy_loader_cli

# force copy requires on direcotry
  # binaries
cp -f $homebrewdir/bin/avrdude ./avrdude
cp -f $homebrewdir/bin/dfu-util ./dfu-util
cp -f $homebrewdir/bin/teensy_loader_cli ./teensy_loader_cli
cp -f $homebrewdir/bin/dfu-programmer ./dfu-programmer

  # libraries
cp -f $homebrewdir/lib/libusb-0.1.4.dylib ./libusb-0.1.4.dylib
cp -f $homebrewdir/lib/libusb-1.0.0.dylib ./libusb-1.0.0.dylib
cp -f $homebrewdir/lib/libftdi.1.dylib   ./libftdi.1.dylib

chmod 755 libusb-0.1.4.dylib libusb-1.0.0.dylib libftdi.1.dylib

# change link directory

  # get library directory
ftdidir=`otool -D libftdi.1.dylib | sed -n 2p`
usb_1dir=`otool -D libusb-1.0.0.dylib | sed -n 2p`
usb_0dir=`otool -D libusb-0.1.4.dylib | sed -n 2p`

  # avrdude
install_name_tool -change $ftdidir @executable_path/../Frameworks/libftdi.1.dylib avrdude 
install_name_tool -change $usb_1dir @executable_path/../Frameworks/libusb-1.0.0.dylib avrdude 
install_name_tool -change $usb_0dir @executable_path/../Frameworks/libusb-0.1.4.dylib avrdude 
  # dfu-util
install_name_tool -change $usb_1dir @executable_path/../Frameworks/libusb-1.0.0.dylib dfu-util
  # libusb0.1.4
install_name_tool -change $usb_1dir @executable_path/../Frameworks/libusb-1.0.0.dylib libusb-0.1.4.dylib
  # libftdi.1
install_name_tool -change $usb_0dir @executable_path/../Frameworks/libusb-0.1.4.dylib libftdi.1.dylib

  # dfu-programmer
install_name_tool -change $usb_0dir @executable_path/../Frameworks/libusb-0.1.4.dylib dfu-programmer

