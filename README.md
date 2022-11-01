# ZFS_Get and ZFS_Set
ZFS Get and Set retrieve (zfs_get) or verify, create and apply dataset properties (zfs_set) so that replicated ZFS pools are recursively configured identically. This is very useful for maintaining a consistent DR environment. It is also useful for creating *"As Built"* documentation, so that in the event of a worst case scenatio, a zpool can be reconstructed identically to how it was built prior to the Event.

## Get
You can use the get_zfs.sh to recursively store zpool and filesystem dataset properties. This stored configuration can then be used to build a target system identically configured as source. The configuration should be recreated periodically (cron(8)) so that changes to the zpool are kept up to date with the configuration. Ideally, you would also back up this file as part of your system recovery procedures.

## Usage
    get_zfs.sh zpool
    
    E.X.
    SRC$ ./get_zfs.sh tank > tank.cnf
    tank:128K:latency:all:none:on:none
    tank/bk:128K:latency:all:none:off:/oh
    tank/bk/ac:128K:latency:all:none:off:/oh/ac
    tank/bk/jnyilas:128K:latency:all:none:off:/oh/jnyilas
    tank/bk/laptop:128K:latency:all:none:off:/oh/laptop
    tank/bk/work:128K:latency:all:none:off:/oh/work
    tank/media:128K:latency:all:none:on:none
    tank/media/Videos:128K:latency:all:none:on:/media/Videos
    tank/vm:128K:latency:all:none:off:/vm

## Set
You can use the set_zfs.sh to apply these saved properties on your replication target to ensure Source and Destination zpools remain in sync.

## Usage
    set_zfs.sh conf_file
    
    E.X.
    DEST$ ./set_zfs.sh tank.cnf
    tank
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=on OK
     mountpoint=none OK
    tank/bk
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=off OK
     mountpoint=/oh OK
    tank/bk/ac
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=off OK
     mountpoint=/oh/ac OK
    tank/bk/jnyilas
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=off OK
     mountpoint=/oh/jnyilas OK
    tank/bk/laptop
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=off OK
     mountpoint=/oh/laptop OK
    tank/bk/work
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=off OK
     mountpoint=/oh/work OK
    tank/media
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=on OK
     mountpoint=none OK
    tank/media/Videos
     recordsize=128K OK
     logbias=latency OK
     primarycache=all OK
     quota=none OK
     atime=on OK
     mountpoint=/media/Videos OK
    tank/vm
     tank/vm created
     applied zfs set recordsize=128K tank/vm
     applied zfs set logbias=latency tank/vm
     applied zfs set primarycache=all tank/vm
     applied zfs set quota=none tank/vm
     applied zfs set atime=off tank/vm
     applied zfs set mountpoint=/vm tank/vm
     
