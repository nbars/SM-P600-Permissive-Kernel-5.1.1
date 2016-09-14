#!/bin/bash
toolchain_dir=$(pwd)/toolchains
toolchain_version="4.8"
build_dir=$(pwd)/kernel-src
initrd_path=$(pwd)/initrd

output_dir=$(pwd)/out
out_zimage=$output_dir/zImage
out_initrd=$output_dir/initramfs.cpio.gz
out_boot_image=$output_dir/boot.img
out_odin_pda=$output_dir/boot.tar
out_heimdall_boot=$output_dir/heimdall_boot.img

if [[ ! -f /usr/bin/cpio ]]; then
  echo "Missing cpio!"
  pkgfile /usr/bin/cpio
  exit 1
fi

if [[ ! -f /usr/bin/mkbootimg ]]; then
  echo "Missing mkbootimg!"
  pkgfile /usr/bin/mkbootimg
  exit 1
fi

cross_compile="${toolchain_dir}/arm-eabi-${toolchain_version}/bin/arm-eabi-"

if [[ -f /usr/bin/ccache ]]; then
  cross_compile="ccache ${cross_compile}"
fi

echo "Setting CROSS_COMPILE to ${cross_compile}"
export CROSS_COMPILE=$cross_compile

echo "Setting ARCH=arm"
export ARCH=arm

#Building
cd $build_dir
make clean
make mrproper
make n1awifi_00_defconfig
make -j5

#Clean output dir
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

#Create boot image
echo "Creating boot image ${out_boot_image}"
mkbootimg --kernel $(basename $out_zimage) --ramdisk $(basename $out_initrd) -o $out_boot_image

echo "Creating odin PDA file"
tar -H ustar -c $(basename $out_boot_image) > $(basename $out_odin_pda)

md5sum $(basename $out_odin_pda) >> $(basename $out_odin_pda)
mv $out_odin_pda $out_odin_pda.md5

echo "Creating heimdall boot.img file"
cp $out_boot_image $out_heimdall_boot

echo "Usage:"
echo "ODIN: Select ${out_odin_pda} as PDA file"
echo "Heimdall: heimdall flash --BOOT ${out_heimdall_boot}"