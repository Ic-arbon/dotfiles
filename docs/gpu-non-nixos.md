# 非 NixOS GPU 配置（`targets.genericLinux.gpu`）

本仓库的 standalone（非 NixOS Linux）机器统一使用 Home Manager 的
`targets.genericLinux.gpu` 模块，而不是旧的 nixGL 逐包 wrap 方案。

启用位置：

- `profiles/platform/standalone-linux.nix` 会自动设置
  `targets.genericLinux.enable = true` 和
  `targets.genericLinux.gpu.enable = true`。
- 因此所有 standalone 机器（如 `deck@steam-deck`、`tyd@OB714`）都会启用。

## 原理

`targets.genericLinux.gpu` 会构建一份 Nix 里的 GPU userspace 库
（Mesa / Vulkan / 可选 NVIDIA），并通过一个 systemd service 链接到
`/run/opengl-driver`。之后从 Nix 安装的普通包（Firefox、OBS、Hyprland 等）
不需要再用 `config.lib.nixGL.wrap` 包裹，直接使用 `pkgs.xxx` 即可。

NixOS 不需要这个模块，因为 NixOS 系统本身已经管理 GPU 驱动；
在这些机器上 `targets.genericLinux.gpu` 不会启用。

## 无 NVIDIA 的 standalone 机器（推荐流程）

例如当前的 `deck@steam-deck`、`tyd@OB714`。

1. 确保宿主机已经有 Mesa / 显卡驱动（大多数发行版默认自带）。
2. 部署：

   ```bash
   home-manager switch -b backup --flake ~/dotfiles#<identity>
   ```

   例如：

   ```bash
   home-manager switch -b backup --flake ~/dotfiles#deck@steam-deck
   home-manager switch -b backup --flake ~/dotfiles#tyd@OB714
   ```

3. 首次 switch 时 Home Manager 会提示类似：

   ```text
   This non-NixOS system is not yet set up to use the GPU
   with Nix packages. To set up GPU drivers, run
     sudo /nix/store/...-non-nixos-gpu/bin/non-nixos-gpu-setup
   ```

   按提示执行一次：

   ```bash
   sudo /nix/store/...-non-nixos-gpu/bin/non-nixos-gpu-setup
   ```

   这个命令会安装 `non-nixos-gpu.service`，并让 `/run/opengl-driver`
   指向 Nix 构建的 GPU 库。

4. 之后正常使用即可。如果以后 Nix 侧 GPU 库更新，Home Manager 会再次提示
   重新运行 setup。

## 有 NVIDIA 的 standalone 机器

如果未来加入带 NVIDIA 的 standalone 机器，需要额外步骤。

### 1. 宿主机先装好 NVIDIA 内核驱动

`targets.genericLinux.gpu` 只提供 userspace 库，不装内核模块。
请先用发行版方式安装 NVIDIA 驱动，例如 Fedora 的 `akmod-nvidia`。

### 2. 确认宿主机驱动版本

```bash
nvidia-smi
# 或
modinfo nvidia | grep '^version'
```

假设得到版本 `550.163.01`。

### 3. 计算 NVIDIA `.run` 文件 hash

```bash
nix store prefetch-file \
  https://download.nvidia.com/XFree86/Linux-x86_64/550.163.01/NVIDIA-Linux-x86_64-550.163.01.run
```

如果是 ARM，把 `Linux-x86_64` 换成 `Linux-aarch64`。

### 4. 在对应机器的 Home Manager 配置中声明

```nix
targets.genericLinux.gpu = {
  enable = true;
  nvidia = {
    enable = true;
    version = "550.163.01";
    sha256 = "sha256-...";
  };
};
```

### 5. 部署并执行 sudo setup

```bash
home-manager switch -b backup --flake ~/dotfiles#<identity>
sudo /nix/store/...-non-nixos-gpu/bin/non-nixos-gpu-setup
```

### 6. 宿主机升级 NVIDIA 驱动后

必须同步更新上面的 `version` 和 `sha256`，然后重新：

```bash
home-manager switch -b backup --flake ~/dotfiles#<identity>
sudo /nix/store/...-non-nixos-gpu/bin/non-nixos-gpu-setup
```

版本不匹配会导致 GL/Vulkan 启动失败。

## 卸载

如果不再需要这套 GPU 链接：

```bash
sudo rm /run/opengl-driver
sudo systemctl disable --now non-nixos-gpu.service
sudo rm /etc/systemd/system/non-nixos-gpu.service
```

同时移除 Home Manager 中的 `targets.genericLinux.gpu.enable = true`
（或整个 standalone GPU 配置）。
