umask 022

LOGDIR=/data/local/bootlog
#LOGDIR=/data/local/log
LOGFILE=$LOGDIR"/bootlog.txt"
XBL_UEFI_LOG="/dev/logfs/UefiLog0.txt"
#DEST_DIR=/data/tombstones/
WAIT_TIME_S=90

time=$(getprop persist.offlinelog.bootlog.secs)
if [ -z "$time" ]; then
        echo "default time for bootlog"
else
        WAIT_TIME_S=$time
fi

echo "bootlog: time=$WAIT_TIME_S, tmp_file=$LOGFILE, result=$DEST_DIR"

date > $LOGFILE
# append bootloader log
finish=$(getprop service.offlinelog.bootloader)
if [ -z "$finish" ] || [ "$finish" -eq "false" ]; then
        nl $XBL_UEFI_LOG >> $LOGFILE
        setprop service.offlinelog.bootloader true
fi

/system/bin/timeout $WAIT_TIME_S /system/bin/logcat -b all -v threadtime -f $LOGFILE
#mv $LOGFILE $DEST_DIR