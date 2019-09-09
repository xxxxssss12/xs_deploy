#!/bin/bash
set -e

echo ".........部署开始.........."
# 工作目录
workdir=$(cd $(dirname $0); pwd)
# git相关配置
code_root_dir="/root/deploy/.git_repo"
git_url="git@github.com:xxxxssss12/account.git"
git_branch="master"
# 代码根目录
git_proj_dir=${git_url#*\/}
git_proj_dir=${git_proj_dir%.*}
# 打包相关配置
pack_type="maven"
pack_root_dir="$code_root_dir/$git_proj_dir"
pack_child_dir="account-web"
pack_filename="account-web.jar"
backup_dir="/root/springboot-account-8889/backup"
# 发布相关配置
deploy_file_dir="/root/springboot-account-8889/jar"
deploy_restart_sh="/root/springboot-account-8889/restart.sh"

echo "..........git拉取最新代码"
/bin/bash $workdir/git_ctrl.sh $code_root_dir $git_url $git_proj_dir $git_branch &
wait

echo "..........package打包代码"
/bin/bash $workdir/package.sh $pack_type $pack_root_dir $pack_child_dir $pack_filename $backup_dir &
wait

echo "..........部署"
if [ ! -d $deploy_file_dir ]
then
    echo "部署失败！目录不存在"
    exit -1
else
    if [ -f $deploy_file_dir/$pack_filename ]
    then
        echo "备份原文件"
        time=$(date "+%Y%m%d%H%M%S")
        mv $deploy_file_dir/$pack_filename $backup_dir/$pack_filename"."$time
    fi
    echo "移动当前文件到运行目录"
    mv $backup_dir/$pack_filename $deploy_file_dir/$pack_filename
    echo "执行重启命令"
    /bin/bash $deploy_restart_sh
fi
echo "..........部署成功！"
