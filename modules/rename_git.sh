#!/bin/sh

# # 获取当前用户名
# current_user=$(whoami)

# TODO: 可替换的 dotfile 路径
dotfile_dir="$HOME/dotfiles"
flag_file="$dotfile_dir/modules/rename_git.lock"
# 设定要修改的配置文件
# home_nix="$dotfile_dir/home.nix"
# flake_nix="$dotfile_dir/outputs/default.nix"
git_nix="$dotfile_dir/modules/git.nix"

# # home.nix
# # 使用 sed 命令替换 username 和 homeDirectory 的值
# sed -i "s/username = .*/username = \"$current_user\"\;/" "$home_nix"
# sed -i "s/homeDirectory = .*/homeDirectory = \"\/home\/$current_user\"\;/" "$home_nix"
#
# # flake.nix
# # 使用 sed 命令替换 username@hostname 的值
# sed -i "s/\"[^\"]*\" = home-manager.lib.homeManagerConfiguration {/\"$current_user\" = home-manager.lib.homeManagerConfiguration {/" "$flake_nix"

# modules/git.nix
if [ ! -f "$flag_file" ]; then
    echo "请输入新的用户名 Enter your userName（git）："
    read new_userName
    echo "请输入新的用户邮箱 Enter your userEmail（git）："
    read new_userEmail
    
    # 使用 sed 命令替换 userName 和 userEmail 的值
    # sed -i '' "s/^\s*userName\s*=\s*\".*\"/    userName = \"$new_userName\"/" "$git_nix"
    # sed -i '' "s/^\s*userEmail\s*=\s*\".*\"/    userEmail = \"$new_userEmail\"/" "$git_nix"
    sed -i "s/userName = .*/userName = \"$new_userName\"\;/" "$git_nix"
    sed -i "s/userEmail = .*/userEmail = \"$new_userEmail\"\;/" "$git_nix"

    # 创建标志文件，更新一次git信息后上锁
    echo "该文件阻止rename_user.sh重复要求输入git用户信息，可删除" > "$flag_file" 
fi

echo "git用户名配置已更新 git user configuration is updated"
