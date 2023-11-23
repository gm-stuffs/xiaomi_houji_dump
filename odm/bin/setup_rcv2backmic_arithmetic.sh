# tinyplay file.wav [-D card] [-d device] [-p period_size] [-n n_periods]
# sample usage: playback.sh 2000.wav  1
set -x

sleep 1

echo "enabling back mic"
audio-factory-test -f enable_back-mic
# start recording
agmcap /data/data/rcv2back_mic_arithmetic.wav -r 48000 -b 16 -c 2 -T 5 -p 1024 -n 4 -D 100 -d 101 -i CODEC_DMA-LPAIF_RXTX-TX-3 && echo "capture done" &


sleep 1
echo "enabling receiver"
audio-factory-test -f enable_receiver
agmplay /odm/etc/audio/rcv_seal_arithmetic.wav -D 100 -d 100 -i TDM-LPAIF-RX-SECONDARY -skv 0xA100000E -dkv 0xA2000001 -ikv 1 -dppkv 0xAC000001

sleep 1


echo "disabling back mic"
audio-factory-test -f disable_back-mic

echo "disabling receiver"
audio-factory-test -f disable_receiver
