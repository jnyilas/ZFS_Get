#!/bin/bash
## Joe Nyilas, crafted this.
## Oracle Advanced Consulting
## An unpublished work.
## Prototyped and conceputalized 17-Jul-2014

#
# $Id: set_zfs.sh,v 1.3 2022/10/31 23:25:16 jnyilas Exp $ 
#

## Restore ZFS parameters for recovery purposes or data migration.
## recordsize, logbias, primarycache, quota, atime, mountpoint


# take zfs get output from the zfs_get script
FILE=$1

if [[ -z "${FILE}" ]]; then
	echo "Please provide the output file from get_zfs."
	exit 1
fi

if [[ ! -f ${FILE} ]]; then
	echo "$FILE not found."
	exit 1
fi

#error check the zpool exists
my_zpool=$(awk -F: 'NR==1 {print $1}' "$FILE")
if [[ -z "${my_zpool}" ]]; then
	#somethings wrong with the input file
	echo "Can't parse input file"
	exit 1
fi

zpool_chk=$(zpool list -Ho name "${my_zpool}" 2> /dev/null)
if [[ -z "${zpool_chk}" ]]; then
	echo "The specified zpool in the input file -- ${my_zpool} -- does not exist."
	exit 1
fi

while read -r i; do
	fs=$(echo "$i" | awk -F: '{print $1}')
	rc=$(echo "$i" | awk -F: '{print $2}')
	lb=$(echo "$i" | awk -F: '{print $3}')
	pc=$(echo "$i" | awk -F: '{print $4}')
	qt=$(echo "$i" | awk -F: '{print $5}')
	at=$(echo "$i" | awk -F: '{print $6}')
	mp=$(echo "$i" | awk -F: '{print $7}')

	echo "${fs}"

	#existence check for ZFS dataset
	fs_ck=$(zfs list -Ho name "$fs" 2> /dev/null)
	if [[ -z "${fs_ck}" ]]; then
		#need to create the dataset
		zfs create "${fs}"
		if [[ $? -eq 0 ]]; then
			echo " ${fs} created"
		else
			exit 1
		fi
	fi

	my_rc=$(zfs get -Ho value recordsize "$fs")
	if [[ "${my_rc}" != "${rc}" ]]; then
		zfs set recordsize="$rc" "$fs"
		echo " zfs set recordsize=$rc $fs"
	else
		echo " recordsize=$rc OK"
	fi

	my_lb=$(zfs get -Ho value logbias "$fs")
	if [[ "${my_lb}" != "${lb}" ]]; then
		zfs set logbias="$lb" "$fs"
		echo " zfs set logbias=$lb $fs"
	else
		echo " logbias=$lb OK"
	fi

	my_pc=$(zfs get -Ho value primarycache "$fs")
	if [[ "${my_pc}" != "${pc}" ]]; then
		zfs set primarycache="$pc" "$fs"
		echo " zfs set primarycache=$pc $fs"
	else
		echo " primarycache=${pc} OK"
	fi

	my_qt=$(zfs get -Ho value quota "$fs")
	if [[ "${my_qt}" != "${qt}" ]]; then
		zfs set quota="$qt" "$fs"
		echo " zfs set quota=$qt $fs"
	else
		echo " quota=${qt} OK"
	fi

	my_at=$(zfs get -Ho value atime "$fs")
	if [[ "${my_at}" != "${at}" ]]; then
		zfs set atime="$at" "$fs"
		echo " zfs set atime=$at $fs"
	else
		echo " atime=${at} OK"
	fi

	my_mp=$(zfs get -Ho value mountpoint "$fs")
	if [[ "${my_mp}" != "${mp}" ]]; then
		if [[ "${mp}" == "legacy" ]]; then
			# if we are transition to legacy, umount first if mounted
			chk=$(mount | grep "$fs")
			if [[ -n "${chk}" ]]; then
				zfs unmount -f "$fs"
			fi
		fi
		zfs set mountpoint="$mp" "$fs"
		if [[ $? -ne 0 ]]; then
			echo "unexpected failure"
			exit 1
		fi
		echo " zfs set mountpoint=$mp $fs"
	else
		echo " mountpoint=${mp} OK"
	fi

	echo ""
done<"${FILE}"

exit 0
