#!/bin/bash

before_days=30      # 间隔天数，删除指定天数之前存的log
LOG_DIR=/home/XXXX/runtimes/logs/       # 目录是示意，替换成目标log存放目录即可

# 遍历删除 LOG_DIR 下的log
# 原理是找到 LOG_DIR/{A,B,C, ...} 的各个目录，根据目录下的文件 {date}_info.log 或者 {date}_error.log 中的 date 与当前日期天数之差是否大于指定天数，满足则删除 date_{info,error}.log 文件
echo "Now will clean folder $LOG_DIR ..."
for((i = 5; i > 0; i--)); do
    echo $i
    sleep 1
done

dir_log_dir=`ls $LOG_DIR`
for i in $dir_log_dir; do
    SUB_DIR=$LOG_DIR$i
    # echo $SUB_DIR
    content=$(date +%Y-%m-%d --date "$before_days days ago")

    cd $SUB_DIR
    # 删除 {data_error}.log 文件
    DIR_NUM=$(find -name "$content"_error.log|wc -l)
    if [ "$DIR_NUM" -gt 0 ];then    # 如果文件存在
        rm -f $SUB_DIR/$content""_error.log
        echo "log file deleted: [$SUB_DIR/$content""_error.log]"
        echo `date "+%Y-%m-%d %H:%M:%S"`" -- deleted file: "$SUB_DIR/$content""_error.log >> $LOG_DIR/auto_clean.log
    fi

    # 删除 {data_info}.log 文件
    DIR_NUM=$(find -name "$content"_info.log|wc -l)
    if [ "$DIR_NUM" -gt 0 ];then
        rm -f $SUB_DIR/$content""_info.log
        echo "log file deleted: [$SUB_DIR/$content""_info.log]"
        echo `date "+%Y-%m-%d %H:%M:%S"`" -- deleted file: "$SUB_DIR/$content""_info.log >> $LOG_DIR/auto_clean.log
    fi
done
echo -e "Completed! folder $LOG_DIR cleaned\n"