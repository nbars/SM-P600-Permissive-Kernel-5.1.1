#!/bin/bash
toolchain_dir=$(pwd)/toolchain
build_dir=$(pwd)/kernel-src
toolchain_version="arm-eabi-4.6"
arm__build_toolchain_url="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/${toolchain_version}"

output_dir=$(pwd)/out

if [[ -e "${toolchain_dir}/${toolchain_version}/bin/arm-eabi-gcc" ]]; then
  echo "Toolchain was already downloaded"
else
  mkdir -p $toolchain_dir
  cd $toolchain_dir

  echo "Cloning ARM build toolchain from ${arm__build_toolchain_url}"
  git clone $arm__build_toolchain_url
  echo "Cloning finished!"
fi

cross_compile="${toolchain_dir}/${toolchain_version}/bin/arm-eabi-"
echo "Setting CROSS_COMPILE to ${cross_compile}"
export CROSS_COMPILE=$cross_compile

echo "Setting ARCH=arm"
export ARCH=arm

#Building
cd $build_dir
#make clean
make n1awifi_00_defconfig
make -j5

#Move zIamge
mkdir -p $output_dir
echo "Copying zIamge to ${output_dir}"
cp $build_dir/arch/arm/boot/zImage $output_dir/

#Building initrd