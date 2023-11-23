umask 022
LOGDIR=/data/local/log
LOGFILE=$LOGDIR"/mtdoops.md"

/system/bin/strings -n 3 /dev/mtd0 > $LOGFILE
