#!bin/sh

#file=$(find d/ -name headset_status)
file="d/mbhc/headset_status"
headset_status=($(cat $file))
standard_media_order=0
standard_up_order=0
standard_down_order=0

function key_order_detect() {
    key_order=${headset_status[5]}
    local key=${key_order:0-1:1}
    if [ $key -eq 0 ]; then
        standard_up_order=2
        standard_down_order=3
        standard_media_order=1
    fi
    if [ $key -eq 1 ]; then
        standard_up_order=3
        standard_down_order=1
        standard_media_order=2
    fi
    if [ $key -eq 2 ]; then
        standard_up_order=1
        standard_down_order=2
        standard_media_order=3
    fi
}

function plug_in_detect() {
    plug_in=${headset_status[0]}
    local in=${plug_in:0-2:1}
    if [ $in -gt 0 ]; then
        plug_in_status=1
    else
        plug_in_status=0
    fi
}

function pull_out_detect() {
    pull_out=${headset_status[4]}
    local out=${pull_out:0-2:1}
    if [ $out -gt 0 ]; then
        pull_out_status=1
    else
        pull_out_status=0
    fi
}

function key_media_detect() {
    key_media=${headset_status[3]}
    local down=${key_media:0-1:1}
    local up=${key_media:0-2:1}
    local order_media=${key_media:0-3:1}
    if [ $down -gt 0 -a $down -eq $up -a $order_media -eq $standard_media_order ]; then
        key_media_status=1
    else
        key_media_status=0
    fi
}

function key_up_detect() {
    key_up=${headset_status[1]}
    local down=${key_up:0-1:1}
    local up=${key_up:0-2:1}
    local order_up=${key_up:0-3:1}
    if [ $down -gt 0 -a $down -eq $up -a $order_up -eq $standard_up_order ]; then
        key_up_status=1
    else
        key_up_status=0
    fi
}

function key_down_detect() {
    key_down=${headset_status[2]}
    local down=${key_down:0-1:1}
    local up=${key_down:0-2:1}
    local order_down=${key_down:0-3:1}
    if [ $down -gt 0 -a $down -eq $up -a $order_down -eq $standard_down_order ]; then
        key_down_status=1
    else
        key_down_status=0
    fi
}

function check_key_value() {
    plug_in_status=0
    key_up_status=0
    key_down_status=0
    key_media_status=0
    pull_out_status=0
    if [ "$1" = up ]; then
        key_up=${headset_status[1]}
        local down=${key_up:0-1:1}
        local up=${key_up:0-2:1}
        if [ $down -gt 0 -a $down -eq $up ]; then
            key_up_status=1
        else
            key_up_status=0
        fi
        res=($plug_in_status $key_up_status $key_down_status $key_media_status $pull_out_status)
        echo "${res[*]}"

    elif [ "$1" = down ]; then
        key_down=${headset_status[2]}
        local down=${key_down:0-1:1}
        local up=${key_down:0-2:1}
        if [ $down -gt 0 -a $down -eq $up ]; then
            key_down_status=1
        else
            key_down_status=0
        fi
        res=($plug_in_status $key_up_status $key_down_status $key_media_status $pull_out_status)
        echo "${res[*]}"

    elif [ "$1" = media ]; then
        key_media=${headset_status[3]}
        local down=${key_media:0-1:1}
        local up=${key_media:0-2:1}
        if [ $down -gt 0 -a $down -eq $up ]; then
            key_media_status=1
        else
            key_media_status=0
        fi
        res=($plug_in_status $key_up_status $key_down_status $key_media_status $pull_out_status)
        echo "${res[*]}"
    fi
}

if [ "$1" = -c ]; then
    echo 0 > $file
    echo "clear done"
elif [ "$1" = up -o "$1" = down -o "$1" = media ]; then
    check_key_value $1
else
    #detect headset status
    plug_in_detect
    key_order_detect
    key_up_detect
    key_down_detect
    key_media_detect
    pull_out_detect
    #show result
    res=($plug_in_status $key_up_status $key_down_status $key_media_status $pull_out_status)
    echo "${res[*]}"
    echo "${headset_status[*]}"
fi
