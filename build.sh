#!/bin/bash

toolchain_dir=$(pwd)/toolchain
build_dir=$(pwd)/kernel-src
toolchain_version="arm-eabi-4.6"
arm__build_toolchain_url="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/${toolchain_version}"

#Toolchain setup
path=$(which arm-eabi-gcc)
if [[ -n "$path" ]]; then
  echo ""
  echo "Found arm-eabi toolchain in your path, no need to download"
else
  if [[ -n "${toolchain_dir}/${toolchain_version}/bin/arm-eabi-gcc" ]]; then
    echo "Toolchain was already downloaded"
  else
    mkdir -p $toolchain_dir
    cd $toolchain_dir

    echo "Cloning ARM build toolchain from ${arm__build_toolchain_url}"
    git clone $arm__build_toolchain_url
    echo "Cloning finished!"
  fi

fi

cross_compile="${toolchain_dir}/${toolchain_version}/bin/arm-eabi-"
echo "Setting CROSS_COMPILE to ${cross_compile}"
export CROSS_COMPILE=$cross_compile

echo "Setting ARCH=arm"
export ARCH=arm

#Building
cd $build_dir
make n1awifi_00_defconfig
make -j5