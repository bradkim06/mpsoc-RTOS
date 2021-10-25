#ifndef		__ARM_CORTEXA9_H__
#define 	__ARM_CORTEXA9_H__


#define S5PV310_POWER_BASE  0x10020000



/*
 * POWER
 *
 */
#define OMR_OFFSET          0x0



#define BOOT_ONENAND        0x1
#define BOOT_NAND       0x40000
#define BOOT_MMCSD      0x3
#define BOOT_NOR        0x4
#define BOOT_SEC_DEV        0x5
#define BOOT_EMMC       0x6
#define BOOT_EMMC_4_4       0x7


#define WTCON                   0x10060000



#define INF_REG_BASE            0x10020800

#define INF_REG0_OFFSET         0x00
#define INF_REG1_OFFSET         0x04
#define INF_REG2_OFFSET         0x08
#define INF_REG3_OFFSET         0x0c
#define INF_REG4_OFFSET         0x10
#define INF_REG5_OFFSET         0x14
#define INF_REG6_OFFSET         0x18
#define INF_REG7_OFFSET         0x1c



/* Define Mode */
#define S5P_CHECK_SLEEP         0x00000BAD
#define S5P_CHECK_DIDLE         0xBAD00000
#define S5P_CHECK_LPA           0xABAD0000


#endif
