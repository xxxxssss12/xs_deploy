#!/bin/bash
set -e
echo "==========打包开始==========="
workdir=$(cd $(dirname $0); pwd)
pack_type=$1
pack_root_dir=$2
pack_child_dir=$3
pack_filename=$4
backup_dir=$5
echo "打包类型: $pack_type"
echo "打包根目录: $pack_root_dir"
echo "打包子目录: $pack_child_dir"
echo "包名: $pack_filename"
echo "备份目录: $backup_dir"

if [ $pack_type == "maven" ]
then
    echo "==========maven打包开始==========="
    mvn_cmd=$(whereis mvn|awk '{print $2}')
    echo $mvn_cmd
    if [ ! -e "$mvn_cmd" ]
    then
        mvn_cmd="/usr/local/bin/mvn"
    fi
    cd $pack_root_dir
    $mvn_cmd clean package -pl $pack_child_dir -am -Dmaven.test.skip=true &
    wait
    if [ ! -f "$pack_root_dir/$pack_child_dir/target/$pack_filename" ]
    then
        echo "maven打包失败！文件未找到！$pack_root_dir/$pack_child_dir/target/$pack_filename"
        exit -1
    else
        echo "打包成功，移动到备份目录..."
        mv $pack_root_dir/$pack_child_dir/target/$pack_filename $backup_dir
    fi
    cd $workdir
    echo "==========maven打包结束==========="
else
    echo "打包方式暂不支持"
fi
