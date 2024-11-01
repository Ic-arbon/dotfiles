# Dotfiles for home-manager

## Target

多机器多系统同步一套配置，快速移植开发环境。

不要让命令式部署环境，化作项目伙伴构建失败的泪水。

不要让处理更新和依赖，化作天天写Dockerfile的汗水。

It works on my machine :)

## Installation

### 安装nix包管理器

[zero-to-nix](https://zero-to-nix.com/)相比官方安装脚本修复了多用户模式安装守护进程nix-daemon不启动的问题，也默认启用flakes

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 
```
修改/etc/nix/nix.conf，在文件末尾追加`trusted-users = root replace_your_username`
### 克隆仓库到本地

```shell
git clone --recursive https://github.com/Ic-arbon/dotfiles ~/dotfiles
```
##### 修改git用户信息
```shell
~/dotfiles/modules/rename_git.sh
```
##### 在users目录下创建你自己的用户，并加入outputs
```
# outputs/default.nix
users = [ "your_username" ];
```
> TODO: Simplize
### 设置代理(暂时弃用)
```shell
sudo mkdir /etc/systemd/system/nix-daemon.service.d/
sudo cat << EOF >/etc/systemd/system/nix-daemon.service.d/override.conf
[Service]
Environment="ALL_PROXY=socks5://代理服务器地址:端口"
EOF
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon

```

### 用[standalone方式](https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes)安装home-manager

```shell
nix run home-manager/release-24.05 \
--         \
switch     \
-b backup  \
--impure   \
--flake    \
~/dotfiles \
#your_username
```

## Usage & Example
我用别名`update`替换了 `home-manager switch --flake`，每次修改后应该手动更新

````shell
update
````

> 如果添加了alias，你可能需要手动source ~/.zshrc文件
