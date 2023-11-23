umask 022

LOGDIR=/data/local/log
LOGFILE=$LOGDIR"/logcatkernel.txt"
XBL_UEFI_LOG="/dev/logfs/UefiLog0.txt"
DEST_DIR=/data/local/log
SRC_DIR=/mnt/rescue/poweroff_charger_log

NUM_MAX=128
NUM_MIN=16


#Add a new folder: /data/local/log/poweroff_charger_log succeed
if [ ! -d ${DEST_DIR} ] && [ ! -e ${DEST_DIR} ]; then
        mkdir -p ${DEST_DIR}
        echo "make  /data/local/log/poweroff_charger_log  suceess"
fi
#Copy the file from the original folder to the new folder successfully
if [ -d ${SRC_DIR} ] && [ -e ${SRC_DIR} ]; then
        cp -R ${SRC_DIR}/. ${DEST_DIR}/
        echo "Copy the file from the original folder to the new folder successfully"
fi


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
# append bootloader/dmesg log when first time bootimg up
finish=$(getprop service.offlinelog.bootloader)
if [ -z "$finish" ] || [ "$finish" == "false" ]; then
        nl $XBL_UEFI_LOG >> $LOGFILE
        dmesg >> $LOGFILE
        setprop service.offlinelog.bootloader true
fi

logcat -b kernel -c
/system/bin/logcat -b kernel -r 10240 -n $num -v threadtime -f $LOGFILE
