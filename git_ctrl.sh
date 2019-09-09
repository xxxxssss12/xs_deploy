#!/bin/bash
set -e

# 入参：1根目录；2git仓库url；3git所属分支(默认master)
# ./git_ctrl.sh /root/gitrepo/ git@github.com:xxxxssss12/account.git master
echo "-----------git分支检出开始-----------"
workdir=$(cd $(dirname $0); pwd)
code_root_dir="$1"
git_url="$2"
git_proj_dir="$3"
git_branch="$4"

if [ ! -d "$code_root_dir" ]
then
    echo "git仓库根目录不存在，请检查: $code_root_dir"
    exit -1
fi

if [ ! -n $git_branch ]
then
    git_branch="master"
fi

echo "git仓库根目录: $code_root_dir"
echo "git仓库url: $git_url"
echo "git分支: $git_branch"
echo "git项目所在目录: $git_proj_dir"

echo "-----------git目录检查-----------"
is_git_dir_exists="false"
if [ -d "$code_root_dir/$git_proj_dir" ]
then
    echo "git所在目录存在，检查git相关数据是否存在"
    if [ -d "$code_root_dir/$git_proj_dir""/.git" ]
    then 
        echo "git相关信息存在"
        is_git_dir_exists="true"
    else
        echo "git相关信息不存在，清空目录重新检出"
        cd "$code_root_dir"
        rm -rf "$git_proj_dir"
        cd $workdir
    fi
else
    echo "git所在目录不存在，需要检出"
fi

echo "-----------git目录检出-----------"
if [ $is_git_dir_exists == "false" ]
then
    echo "git所在目录不存在，执行检出操作"
    cd $code_root_dir
    /usr/bin/git clone $git_url &
    wait
    cd $workdir
    echo "检出完毕"
else
    echo "git所在目录存在，不检出"
fi

echo "-----------git分支检出-----------"
cd "$code_root_dir"/"$git_proj_dir"
/usr/bin/git fetch &
wait
/usr/bin/git pull &
wait
/usr/bin/git checkout -b $git_branch &
wait
head_code=$(cat "$code_root_dir/$git_proj_dir/.git/logs/HEAD"|awk '{print $2}')
echo $head_code
cd $workdir
echo "-----------git分支检出完毕，目录: $code_root_dir/$git_proj_dir; 分支code=$head_code"
