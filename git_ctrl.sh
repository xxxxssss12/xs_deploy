#!/usr/local/opt/bash/bin/bash

# 入参：1根目录；2git仓库url；3git所属分支(默认master)
# ./git_ctrl.sh /root/gitrepo/ git@github.com:xxxxssss12/account.git master

code_root_dir="$1"
git_url="$2"
git_branch="$3"
git_proj_dir=${git_url#*\/}
git_proj_dir=${git_proj_dir%.*}

if [ ! -n $git_branch ]
then
  git_branch="master"
fi

echo $git_proj_dir