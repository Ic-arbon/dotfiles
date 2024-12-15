{ pkgs, ... }:
let
  # 读取规则文件
  probersRules = builtins.readFile ./rules/69-probe-rs.rules;
  openocdRules = builtins.readFile ./rules/70-openocd.rules;
  platformioRules = builtins.readFile ./rules/99-platformio-udev.rules;
in
pkgs.writeShellApplication {
  name = "udev-setup";
  runtimeInputs = with pkgs; [
    udev
    coreutils
    gnused
    gawk
  ];
  text = ''
    #!${pkgs.bash}/bin/bash
    
    # 设置严格模式
    set -euo pipefail
    
    # 使用 printf 替代 echo -e 和颜色变量
    print_error() {
        printf '\033[0;31m%s\033[0m\n' "$1"
    }
    
    print_warning() {
        printf '\033[1;33m%s\033[0m\n' "$1"
    }
    
    print_success() {
        printf '\033[0;32m%s\033[0m\n' "$1"
    }
    
    # 检查是否以 root 权限运行
    check_root() {
        if [ "$(id -u)" -ne 0 ]; then
            print_error "请使用 sudo 运行此脚本"
            exit 1
        fi
    }
    
    # 创建规则文件
    install_rules() {
        local rule_name="$1"
        local rules_content="$2"
        local rules_file="/etc/udev/rules.d/''${rule_name}"
        
        print_warning "创建 udev 规则文件: $rules_file"
        echo "$rules_content" > "$rules_file"
        chmod 644 "$rules_file"
    }
    
    # 重新加载 udev 规则
    reload_udev_rules() {
        print_warning "重新加载 udev 规则"
        udevadm control --reload-rules
        udevadm trigger
        print_success "udev 规则已重新加载"
    }
    
    # 验证安装
    verify_installation() {
        print_warning "验证安装"
        local status=0
        
        # 检查所有规则文件
        for rule_file in "$@"; do
            if [ -f "/etc/udev/rules.d/$(basename "$rule_file")" ]; then
                print_success "✓ $(basename "$rule_file") 已创建"
            else
                print_error "✗ $(basename "$rule_file") 创建失败"
                status=1
            fi
        done
        
        return $status
    }
    
    # 创建临时规则文件
    PROBERS_RULES=$(cat << 'EOL'
    ${probersRules}
    EOL
    )

    OPENOCD_RULES=$(cat << 'EOL'
    ${openocdRules}
    EOL
    )
    
    PLATFORMIO_RULES=$(cat << 'EOL'
    ${platformioRules}
    EOL
    )
    
    # 主函数
    main() {
        print_warning "开始设置 udev 规则..."
        
        # 检查 root 权限
        check_root
        
        # 安装规则
        install_rules "69-probe-rs.rules" "$PROBERS_RULES"
        install_rules "70-openocd.rules" "$OPENOCD_RULES"
        install_rules "99-platformio-udev.rules" "$PLATFORMIO_RULES"
        
        # 重新加载规则
        reload_udev_rules
        
        # 验证安装
        if verify_installation "69-probe-rs.rules" "70-openocd.rules" "99-platformio-udev.rules"; then
            print_success "设置完成！"
            print_warning "注意：请断开并重新连接设备"
            print_success "现在所有登录的用户都可以访问开发板和调试器，无需额外的组权限"
        else
            print_error "设置过程中出现错误，请检查上述输出"
            exit 1
        fi
    }
    
    # 运行主函数
    main
  '';
}
