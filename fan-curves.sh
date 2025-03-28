#! /bin/bash
#
# set custom fan curves for MSI Katana A17 B8VF laptop
#

export PATH=/usr/local/sbin:$PATH:

# read current curves
echo "FAN 1:"
echo "curr temp = "`acpi-ec-rw 0x68`
echo "curr fan  = "`acpi-ec-rw 0x71`
N=0
while [ $N -lt 8 ]; do
	treg=$[105+$N]
	freg=$[114+$N]
	t=`acpi-ec-rw $treg`
	f=`acpi-ec-rw $freg`
	echo "$t => $f"
	N=$[$N+1]
done

echo

echo "FAN 2:"
echo "curr temp = "`acpi-ec-rw 128`
echo "curr fan  = "`acpi-ec-rw 137`
N=0
while [ $N -lt 8 ]; do
	treg=$[129+$N]
	freg=$[138+$N]
	t=`acpi-ec-rw $treg`
	f=`acpi-ec-rw $freg`
	echo "$t => $f"
	N=$[$N+1]
done

# comment out to write
exit


# LAPTOP DEFAULTS for reference

# FAN 1:
#curr temp = 0x68: 0x37 ( 55)
#curr fan  = 0x71: 0x00 ( 0)
# 0x69: 0x00 (  0) => 0x72: 0x00 (  0)
#0x6a: 0x3c ( 60) => 0x73: 0x2d ( 45)
#0x6b: 0x41 ( 65) => 0x74: 0x36 ( 54)
#0x6c: 0x46 ( 70) => 0x75: 0x41 ( 65)
#0x6d: 0x4e ( 78) => 0x76: 0x46 ( 70)
#0x6e: 0x55 ( 85) => 0x77: 0x4b ( 75)
#0x6f: 0x5a ( 90) => 0x78: 0x50 ( 80)
# 0x70: 0x64 (100) => 0x79: 0x64 (100)

# FAN 2:
#curr temp = 0x80: 0x34 ( 52)
#curr fan  = 0x89: 0x00 ( 0)
# 0x81: 0x00 (  0) => 0x8a: 0x00 (  0)
#0x82: 0x3c ( 60) => 0x8b: 0x2d ( 45)
#0x83: 0x41 ( 65) => 0x8c: 0x36 ( 54)
#0x84: 0x46 ( 70) => 0x8d: 0x41 ( 65)
#0x85: 0x4b ( 75) => 0x8e: 0x46 ( 70)
#0x86: 0x50 ( 80) => 0x8f: 0x4b ( 75)
#0x87: 0x55 ( 85) => 0x90: 0x50 ( 80)
# 0x88: 0x64 (100) => 0x91: 0x64 (100)

echo "== Setting up curves..."

# FAN1 temp and speed
#acpi-ec-rw 0x69 0 && acpi-ec-rw 0x72 10
acpi-ec-rw 0x6a 55 && acpi-ec-rw 0x73 20
acpi-ec-rw 0x6b 65 && acpi-ec-rw 0x74 50
acpi-ec-rw 0x6c 70 && acpi-ec-rw 0x75 65
acpi-ec-rw 0x6d 80 && acpi-ec-rw 0x76 75
acpi-ec-rw 0x6e 85 && acpi-ec-rw 0x77 85
acpi-ec-rw 0x6f 90 && acpi-ec-rw 0x78 90
#acpi-ec-rw 0x70 100 && acpi-ec-rw 0x79 100

# FAN2 temp and speed
# acpi-ec-rw 0x81 0 && acpi-ec-rw 0x8a 0
acpi-ec-rw 0x82 55 && acpi-ec-rw 0x8b 20
acpi-ec-rw 0x83 60 && acpi-ec-rw 0x8c 35
acpi-ec-rw 0x84 65 && acpi-ec-rw 0x8d 55
acpi-ec-rw 0x85 70 && acpi-ec-rw 0x8e 65
acpi-ec-rw 0x86 80 && acpi-ec-rw 0x8f 75
acpi-ec-rw 0x87 85 && acpi-ec-rw 0x90 85
# acpi-ec-rw 0x88 100 && acpi-ec-rw 0x91 100

