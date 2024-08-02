# home-manager standalone

非NixOS环境下，使用nix包管理器和home-manager管理applications和dotfiles，实现一键布署可复现的环境，It works on my machine :)

> 文档较为混乱和晦涩，有困难多点点文内超链接
>
> 有些[blog](https://tonyfinn.com/categories/nix/)写的比官方好一些？可供参考

### Installation

##### 安装nix包管理器

[zero-to-nix](https://zero-to-nix.com/)相比官方安装脚本修复了多用户模式安装守护进程nix-daemon不启动的问题，也默认启用flakes

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 
```
##### 克隆仓库到$XDG_CONFIG_HOME(即~/.config)

```shell
git clone https://github.com/Ic-arbon/home-manager ~/.config
```

##### nix flake安装home-manager并自动初始化

```shell
nix run home-manager/master -- init --switch # 默认unstable nixpkgs

# or
nix run home-manager/release-24.05 \ # 可以替换$branch
-- init \
--switch \
$XDG_CONFIG_HOME/home-manager # 可以替换dotfiles路径，默认是～/.config/home-manager
```

### 用法

home-manager目录结构如下，`home.nix`是主要配置文件。

`apps`下是从`home.nix`中拆分出来的模块，以便于管理某些dotfile和dependency较为复杂的应用。

```
.
├── apps
│   ├── astronvim.nix
│   ├── firefox.nix
│   ├── ranger.nix
│   ├── shells.nix
│   └── ...
├── flake.lock
├── flake.nix
├── home.nix
└── README.md
```

nixlang较为晦涩，我不会讲其中的细节，但使用者应该了解`home.nix`大致的逻辑

集中管理[软件包](https://search.nixos.org/packages)，而不是按传统包管理器的方式一行一行敲命令

```nix
{ config, pkgs, ...}:  # 整体结构为 {函数的输入}:{函数的表达式} 比如“pkgs”就是函数的一个输入参数

{ 
	...
	home.packages = with pkgs; [<pkg1> <pkg2> <pkg3>];
	# 语法糖，等价于
	# home.packages = [pkgs.<pkg1> pkgs.<pkg2> pkgs.<pkg3>];
	...
}
```

同样的，比起在各种`etc`目录下找配置文件了，nix-way更倾向于集中管理dotfiles，逐渐转向[home-manager](https://home-manager-options.extranix.com/?query=&release=master)

```nix
{ pkgs, ... }: 

{
xdg.configFile = {
    "nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "Ic-arbon";
        repo = "AstroNvim";
        rev = "";
        sha256 = "sha256-P6AC1L5wWybju3+Pkuca3KB4YwKEdG7GVNvAR8w+X1I=";
      }; # 为fetcher提供4个参数，用非shell脚本的方式，自动把配置文件从github配置文件拉到本地
      executable = true;
      recursive = true;
    };

  };
}
```

我用别名`update`替换了 `home-manager switch`，每次修改home.nix后应该手动更新

````shell
update
````

