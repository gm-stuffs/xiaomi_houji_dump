umask 022
LOGDIR=/data/local/log
LOGFILE=$LOGDIR"/logcatlog.txt"
KWFILE=$LOGDIR"/keyword_logcat.cfg"

NUM_MAX=128
NUM_MIN=64

size=$(getprop persist.offlinelog.logcat.size)
if [ -z "$size" ]; then
	num=$NUM_MIN
else
	num=$(($size/10))
fi

if [ "$num" -gt "$NUM_MAX" ] || [ "$num" -lt "NUM_MIN" ]; then
        num=$NUM_MIN
fi

# logcat filterspecs
LINE="DUMMY_LINE"
i=0
TAG_PRI=('V' 'D' 'I' 'W' 'E' 'F' 'S')
if [ -e "$KWFILE" ]; then
	# Parse cfg file
	# valid line is <item_1>:<item_2>
	# For example
	# NfcService:D
	while [ -n "$LINE" ]
	do
		i=$((i+1))
		LINE=$(cat "$KWFILE" | sed -n "$i"p)
		# skip blank line
		test -z "$LINE" && continue
		# skip note line
		IF_NOTE=$(echo ${LINE%%#*})
		test -z "$IF_NOTE" && continue
		# skip not valid line
		item_1=$(echo $LINE | cut -d ':' -f 1)
		test -z "$item_1" && continue
		item_2=$(echo $LINE | cut -d ':' -f 2)
		test -z "$item_2" && continue
		for pri in ${TAG_PRI[@]};do
			test "$pri" = "$item_2" && valid=1
		done
		test -z "$valid" && continue

		TAG=$TAG" "$LINE
	done
	test -n "$TAG" && TAG=$TAG" *:S"
fi

/system/bin/logcat -b main,system,crash,events -r 10240 -n $num -v threadtime -v uid -f $LOGFILE $TAG
