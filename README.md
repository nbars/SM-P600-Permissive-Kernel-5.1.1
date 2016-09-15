# SM-P600-Permissive-Kernel

**!!! Some security features of the kernel are disabled, use it on you're own risk !!!**

This is a permissive kernel for the SM-P600. This kernel is needed, if you
for example like to use Linux Deploy on Android. 

This version is currently based on P600XXUDOJ3_P600DBTDOK1 (Stock Samsung firmware - Android 5.1.1).


## Directory structure
- /backup - Backup of the SM-P600 boot partition
- /bin - A ready to use permissive boot image
- /initrd - The stock ramdisk of P600XXUDOJ3_P600DBTDOK1
- /kernel-src - The kernel source of P600XXUDOJ3_P600DBTDOK1
- /toolchains - The ARM cross compiler toolchain for building the kernel

## Building
Run the build.sh script. The resulting boot image will be saved in the directory named **out**.
For succesfully building the script needs following packages: **mkbootimg**,**cpio**.

## Flashing

##### Using ODIN
Select boot.tar.md5 as PDA file

##### Using heimdall
	heimdall flash --BOOT heimdall_boot.img
	
	
#### Known bugs/issues
- With CONFIG_SECURITY_SELINUX=n the kernel wont boot
- Compiling with ccache leads to an unusable kernel
- After flashing this kernel, all you're WIFI passwords are lost after restarting you're device. (see [#1](https://github.com/nbars/SM-P600-Permissive-Kernel/issues/1))
- After flashing this kernel you're root access is gone, install e.g. Super-SU
again to patch the boot image again.
