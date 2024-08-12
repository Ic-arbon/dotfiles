# Dotfiles for home-manager

### Target

多机器多系统同步一套配置，快速移植开发环境。

不要让命令式部署环境，化作你项目伙伴构建失败的泪水。

不要让处理更新和依赖，化作你天天写Dockerfile的汗水。

It works on my machine :)

### Installation

##### 安装nix包管理器

[zero-to-nix](https://zero-to-nix.com/)相比官方安装脚本修复了多用户模式安装守护进程nix-daemon不启动的问题，也默认启用flakes

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 
```
##### 克隆仓库到本地

```shell
git clone https://github.com/Ic-arbon/dotfiles ~/dotfiles
```

```shell
# or you can customize target dir, 
# remember to replace `dotfileDir` in `home.nix`
git clone https://github.com/Ic-arbon/dotfiles /path/to/dotfiles
```

##### 用[standalone方式](https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes)安装home-manager并自动初始化

```shell
nix run home-manager \
-- \
switch \
--flake \
-b backup\
~/dotfiles # or /path/to/dotfiles
```

### Usage & Example

> 在一台机器上能工作的环境，在任何机器上都应该工作

home-manager目录结构如下，`home.nix`是主要配置文件。

`modules`下是从`home.nix`中拆分出来的模块，以便于管理某些dotfile和dependency较为复杂的应用。

```
.
├── flake.lock
├── flake.nix
├── home.nix
├── modules
│   ├── default.nix
│   ├── git.nix
│   └── ...
├── overlays
│   └── default.nix
└── pkgs
└── default.nix
```

nixlang较为晦涩，但使用者应该了解`home.nix`大致的逻辑：

集中管理[软件包](https://search.nixos.org/packages)来搭建开发环境，而不是按传统包管理器的方式一行一行敲命令

```nix
{ config, pkgs, ...}:  # 整体结构为 {函数的输入}:{函数的表达式} 比如“pkgs”就是函数的一个输入参数

{ 
...
home.packages = with pkgs; [<pkg1> <pkg2> <pkg3>];
...
}
```

同样的，比起在各种`etc`目录下找配置文件了，nix-way更倾向于[home-manager](https://home-manager-options.extranix.com/?query=&release=master)集中管理dotfiles。

[详细的模块配置方法](./modules/README.md)

```nix
{ pkgs, ... }: 

{
xdg.configFile = {
"nvim" = {
  source = pkgs.fetchFromGitHub {
    # 为fetcher提供4个参数，用非shell脚本的方式，自动把配置文件从github配置文件拉到本地
    owner = "Ic-arbon";
    repo = "AstroNvim";
    # commit hash or tag
    rev = "";
    # nix flake prefetch github:Ic-arbon/AstroNvim
    sha256 = "sha256-P6AC1L5wWybju3+Pkuca3KB4YwKEdG7GVNvAR8w+X1I=";
  };
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

> 如果添加了alias，你可能需要手动source ~/.zshrc文件

到这里如果你的环境已经能工作了，恭喜你，在别的机器上这个环境大概率能直接工作。

你只需要让别人clone你的配置，并用3行命令安装。

> !!!不要忘记有关用户名的TODO
>
> home.nix
>
> flake.nix
>
> modules/git.nix
