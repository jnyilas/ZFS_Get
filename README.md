# ZFS_Get
Get and Set ZFS retrieve and apply dataset properties so that replicated ZFS datasets are recursilvely configured identically.
## Usage
    get_zfs.sh zpool
    
    e.x.
    ./get_zfs.sh tank
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
You can use the set_zfs.sh to applied these saved properties on your replication target to ensure Source and Destination copies remain in sync.

## Usage
    set_zfs.sh conf_file
