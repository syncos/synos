#ifndef K_RAMDISK_H
#define K_RAMDISK_H

struct INITRD // Initial ramdisk layout
{
    unsigned char ACPI[];
    unsigned int ACPI_len;

    unsigned char DEV[];
    unsigned int DEV_len;

    unsigned char VFS[];
    unsigned int VFS_len;

    unsigned char RFS[];
    unsigned int RFS_len;

    unsigned char KEY[];
    unsigned int KEY_len;
};

#endif