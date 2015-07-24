#!/bin/bash
toolchain_dir=$(pwd)/toolchain
build_dir=$(pwd)/kernel-src
toolchain_version="arm-eabi-4.6"
arm__build_toolchain_url="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/${toolchain_version}"
initrd_path=$(pwd)/initrd

output_dir=$(pwd)/out
out_zimage=$output_dir/zImage
out_initrd=$output_dir/initramfs.cpio.gz
out_boot_image=$output_dir/boot.img
out_odin_pda=$output_dir/boot.tar

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

rm -rf $output_dir/*

#Move zIamge
mkdir -p $output_dir
echo "Copying zIamge to ${out_zimage}"
cp -f $build_dir/arch/arm/boot/zImage $out_zimage

#Building initrd
echo "Creating initrd at ${out_initrd}"
cd $initrd_path
find . | cpio -o -H newc | gzip > $out_initrd

cd $output_dir

echo "Creating boot image ${out_boot_image}"
mkbootimg --kernel $(basename $out_zimage) --ramdisk $(basename $out_initrd) -o $out_boot_image

echo "Creating odin PDA file"
tar -H ustar -c $(basename $out_boot_image) > $(basename $out_odin_pda)

md5sum $(basename $out_odin_pda) >> $(basename $out_odin_pda)
mv $out_odin_pda $out_odin_pda.md5