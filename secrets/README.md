# secrets/ 目录约定（v2）

本目录只允许存在：

```text
secrets/
├── README.md
├── common/
│   └── secrets.yaml              # 所有机器共享的 SOPS 密文
└── hosts/
    └── <username>@<hostname>/
        └── secrets.yaml          # 机器专属 SOPS 密文
```

其他任何文件（包括 `deepseek_api_key`、`glm_api_key` 等明文）都会：
1. 被 `.gitignore` 忽略；
2. 被 pre-commit 的 `no-plaintext-secrets` 钩子拒绝提交。

## 明文密钥位置

明文只放在仓库外：

```text
Linux/macOS: ~/.config/dotfiles/secrets/
```

目录权限 `700`，文件权限 `600`。从旧位置迁移：

```bash
~/dotfiles/scripts/migrate-secrets.sh
```

## 解密身份（不新建 age key）

- NixOS / macOS 系统级 sops：`/etc/ssh/ssh_host_ed25519_key`
- home-manager 用户级 sops（所有平台）：`~/.ssh/id_ed25519`
- `setup-sops.sh` 会在 NixOS/macOS 上同时登记 host key 与 user key；standalone 只登记 user key
- 若用户 SSH key 有 passphrase，可在 `machines/<identity>.nix` 设置 `home.sopsAgeKeyFile` 作为无 passphrase fallback

## 初始化 / 添加新机器

1. 新机器运行 `~/dotfiles/scripts/setup-sops.sh`：
   - 读取现有 SSH 公钥，用 `ssh-to-age` 转成 age recipient；
   - 自动写入 `.sops.yaml` 的 `&hosts`；
   - 生成 `common/secrets.yaml`（若不存在）和本机 `hosts/<identity>/secrets.yaml`。
2. 在任一已授权机器上给 common 密文补发新机器的解密权：
   ```bash
   sops updatekeys ~/dotfiles/secrets/common/secrets.yaml
   ```
3. 提交 `.sops.yaml` 和更新的密文。

## 恢复密钥（建议）

离线生成一个 age 密钥（`age-keygen -o recovery.txt`），把其**公钥**加入 `.sops.yaml` 的 `&hosts`，私钥离线保存。这样即使所有主机丢失，密文仍可恢复。

## 历史清理记录

- 2026-08-20：删除 `origin/headless` 远程分支（该分支历史中包含 SOPS 加密的旧 `secrets/secrets.yaml`）。
- 2026-08-20：DeepSeek、GLM API key 以及旧文件中的 forgejo 等凭据的轮换**暂缓执行**；在轮换前不要认为这些凭据是干净的。
- 结论：公开仓库历史清理无法保证已扩散副本被回收，轮换仍是最终保障。

## 检查命令

```bash
~/dotfiles/scripts/check-no-plaintext-secrets.sh ~/dotfiles/secrets
gitleaks detect --no-git
nix flake check
```
