#!/bin/bash
## Joe Nyilas, crafted this.
## Oracle Advanced Consulting
## An unpublished work.
## Prototyped and conceputalized 17-Jul-2014

#
# $Id: get_zfs.sh,v 1.2 2022/10/31 23:24:09 jnyilas Exp $
#

## Preserve ZFS parameters for recovery purposes or data migration.
## recordsize, logbias, primarycache, quota, atime, mountpoint

if [[ $# -ne 1 ]]; then
	echo "zpool name is required argv"
	exit 1
fi

for i in $(zfs list -t filesystem -r -Ho name "$1"); do
	rc=$(zfs get  -Ho value recordsize "$i")
	lb=$(zfs get  -Ho value logbias "$i")
	pc=$(zfs get  -Ho value primarycache "$i")
	qt=$(zfs get  -Ho value quota "$i")
	at=$(zfs get  -Ho value atime "$i")
	mp=$(zfs get  -Ho value mountpoint "$i")

	echo "${i}:${rc}:${lb}:${pc}:${qt}:${at}:${mp}"
done
exit 0
