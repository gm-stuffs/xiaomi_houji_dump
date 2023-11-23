umask 022

LOGDIR=/dev/rescue/poweroff_charger_log
LOGFILE=$LOGDIR"/poweroff_charger.txt"
XBL_UEFI_LOG="/dev/logfs/UefiLog0.txt"


NUM_MAX=128
NUM_MIN=16

size=$(getprop persist.offlinelog.kernel.size)
if [ -z "$size" ]; then
        num=$NUM_MIN
else
        num=$(($size/10))
fi

if [ "$num" -gt "$NUM_MAX" ] || [ "$num" -lt "NUM_MIN" ]; then
        num=$NUM_MIN
fi

date >> $LOGFILE

# append bootloader/dmesg log when poweroff_charger
        nl $XBL_UEFI_LOG >> $LOGFILE
        dmesg >> $LOGFILE

logcat -b kernel -c
/system/bin/logcat -b kernel -r 10240 -n $num -v threadtime -f $LOGFILE
