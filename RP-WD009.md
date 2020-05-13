# RP-WD009

## Description

The latest release of the RAVPower FileHub as of 10.03.2020

Comes with AC750 WiFi, USB Type-C for power



## Hardware

| Name | Value |
|-----|---------|
| CPU | MediaTek MT7628 |
| RAM | 64MB |
| Storage | 16MB Flash |


## Partition layout

| Path | Address | Size | Role | Notes |
|---|---|---|---|---|
| mtd0 | 0x00000000 | 16MB |  |

| mtd1 | 0x00000000 | 0x00030000 (192Kb) | Bootloader |
| mtd2 | 0x00030000 | 0x00010000 (64Kb) | Config |
| mtd3 | 0x00040000 | 0x00010000 (64Kb) | Factory |
| mtd4 | 0x00050000 | 0x00180000 (1536Kb) | Kernel |
| mtd5 | 0x001D0000 | 0x00010000 (64Kb) | params |
| mtd6 | 0x001E0000 | 0x00010000 (64Kb) | Config Backup |
| mtd7 | 0x001F0000 | 0x00010000 (64Kb) | Config | Erased on FW update
| mtd8 | 0x00200000 | 0x00E00000 (14MB ) | RootFS | 

 
## Firmware image structure

- Shell script that will execute installation
- TAR.GZ
  - EXT2 image of updater root
    - /etc/firmware contains images:
      - bootloader
      - kernel
      - rootfs (SquashFS image)


## Access

 ** As of firmware 2.000.018, default Telnet access is disabled! **

### Factory defaults

The default WiFi AP created by the FileHub is `RAV-FileHub-2G-XXXX` with the password `1.1.1.1`


### Telnet

The only shell access on the stock firmware is via Telnet.

Default login for telnet: username `root`, password `20080826`

### Web interface

The default IP address is `10.10.10.254`

Default login for the web interface: username `admin`, empty password

