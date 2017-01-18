lpc_usb_flasher
===============

Small script to automatically flash the latest bin file in the download folder onto a bare metal LPC11U24 controller using the built-in USB boot loader.

Tested on OS X, should work with minor modifications on Linux too.

Additional versions:
 * lpc_rdb_flasher.pl  : loads to a software bootloader that presents itself as 'RDB1768' drive
 * nrf_flash_latest.pl    : programming an nRF5x controller via the Segger J-Link programmer
