#!/system/bin/sh

function dump() {
    source_traces_path='/data/misc/perfetto-traces/records'
    dest_traces_path='/data/local/traces'
    board=$(getprop ro.product.board)
    id=$(getprop ro.build.id)
    file_type="perfetto-trace"
    max_file_num=3

    mkdir -p ${source_traces_path}
    rm -rf ${source_traces_path}/*
    rm -rf ${dest_traces_path}/*
    cd ${source_traces_path}

    while true
        do
            datetime=$(date +"%Y%m%d-%H%M%S")
            dest_file="trace-$board-$id-$datetime.perfetto-trace"
            cat /system_ext/bin/traceconfig.pbtx | perfetto --txt -c - -o ${source_traces_path}/${dest_file}

            #异步压缩文件
            {
                tar -jcf ${dest_file}.tar.bz2 ${dest_file} && rm ${dest_file} && \
                mv -f ${dest_file}.tar.bz2 ${dest_traces_path}/${dest_file}
                chmod 666 ${dest_traces_path}/${dest_file}
                chcon u:object_r:trace_data_file:s0 ${dest_traces_path}/${dest_file}

                file_num=$(ls -ltr "${dest_traces_path}/" | grep -v "total" | grep "-" | grep ${file_type} | wc -l)

                # 保留dest_traces_path目录下时间最近的max_file_num数量的perfetto-trace文件
                if [ ${file_num} -gt ${max_file_num} ];then
                    let num_del=${file_num}-${max_file_num}
                    find "${dest_traces_path}/" -type f -name "*.${file_type}" | xargs ls -ltr | awk '{print $8}' | head -n ${num_del} | xargs rm -rf
                fi
            } & disown
        done
}

dump
