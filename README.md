# SM-P600-Permissive-Kernel

This is a permissive kernel for the SM-P600. This kernel is needed, if you
for example like to use linux deploy on android.

This version is currently based on P600XXUDOJ3_P600DBTDOK1 (Stock Samsung firmware - Android 5.1.1).

## Directory structure
- /backup - Backup of the SM-P600 boot partition
- /bin - A ready to use permissive boot image
- /initrd - The stock ramdisk of P600XXUDOJ3_P600DBTDOK1
- /kernel-src - The kernel source of P600XXUDOJ3_P600DBTDOK1
- /toolchains - The ARM cross compiler toolchain for building the kernel

## Building
Run the build.sh script. The resulting boot image will
be saved in the directory named **out**. 

## Flashing

##### Using ODIN
Select boot.tar.md5 as PDA file

##### Using heimdall
	heimdall flash --BOOT heimdall_boot.img