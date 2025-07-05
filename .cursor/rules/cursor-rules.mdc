---
description: 当需要创建规则、更新规则或从用户那里学习应该保留为新规则时使用
globs: 
alwaysApply: false
---
# Cursor Rule 规则格式规范

## 规则文件模板结构

\`\`\`mdc
---
description: `根据规则内容，生成包含关键场景、动作、触发条件、结果、格式的内容，限制在 150 字以内`
globs: 空白或模式 (例如: *.js, *.ts, *.py, .vscode/*.json, .cursor/**/*.mdc)
alwaysApply: {true 或 false}
---

# 规则标题

## 使用场景
- 何时应用此规则
- 前提条件或要求

## 关键规则
- 简洁的、列表形式的行动规则，模型必须遵循
- 始终执行 X
- 绝不执行 Y

## 示例
<example>
好的简洁示例及其说明
</example>

<example type="invalid">
错误的简洁示例及其说明
</example>
\`\`\`

## 文件组织

### 规则文件位置
- 路径：`.cursor/rules/*.mdc`
- 扩展名：`.mdc`

### 规则命名规范
- 文件名使用 kebab-case 格式
- 始终使用 .mdc 扩展
- 让命名可以直观描述规则的目的
- 私有规则：以下划线 _ 开头，该规则将位于 gitignore 中，例：`_rule-name.mdc`
- 规则文件命名需要根据规则类型添加后缀，例：`rule-name-{auto|agent|manual|always}.mdc`
  - auto: 自动规则
  - agent: 代理规则
  - manual: 手动规则
  - always: 全局规则

### Glob 示例
不同规则类型的常见 glob 模式：
- 核心规则：.cursor/rules/*.mdc
- 语言规则：*.js, *.ts, *.py, *.cpp, *.hpp
- 测试规则：*.test.js, *.test.ts, *.test.py, *.test.cpp, *.test.hpp
- 文档规则：docs/**/*.md, *.md
- 配置规则：*.config.{js,json}, *.json, *.yaml, *.yml
- 构建产物规则：dist/**/*
- 多扩展名规则：src/**/*.{js,jsx,ts,tsx}
- React 组件规则：*.tsx, *.jsx
- Vue 组件规则：*.vue

## 必需字段
### 前置信息
- description: `根据规则内容，生成包含关键场景、动作、触发条件、结果、格式的内容，限制在 150 字以内`
- globs: 空白或模式 (例如: *.js, *.ts, *.py, .vscode/*.json, .cursor/**/*.mdc)
- alwaysApply: {true 或 false}

### 正文
- 使用场景
- 关键规则：最关键规则的简短总结
- 示例：有效和无效示例

## 格式指南
- mdc 规则文件中使用简洁的 Markdown 语法
- 仅限使用以下 XML 标签：
  - <example>
- XML 标签内容或嵌套标签必须缩进 2 个空格
- 如果能更好地帮助 AI 理解规则，可以使用表情符号和 Mermaid 图表（但不要冗余）

## 关键规则
- 规则文件将始终位于和命名为：`.cursor/rules/rule-name-{auto|agent|manual|always}.mdc`
- 规则将永远不会在 .cursor/rules/** 之外创建
- 你应该总是会检查是否在所有 .cursor/rules 子文件夹下存在要更新的现有规则
- 规则正文中，除了使用场景、关键规则、示例，你也可以根据需求扩展更详细的规则内容，但请注意内容简洁有效
- 规则类型前言部分必须始终在文件开头，并包含所有 3 个字段，即使字段值为空 - 类型如下：：
  - 手动规则：如果请求手动规则 - description 和 glob 必须为空，alwaysApply: false 且文件名以 -manual.mdc 结尾
  - 自动规则：如果请求的规则应始终应用于某些 glob 模式（例如所有 typescript 文件或所有 markdown 文件） - 描述必须为空，alwaysApply: false 且文件名以 -auto.mdc 结尾
  - 全局规则：全局规则 description 和 glob 为空，alwaysApply: true 且文件名以 -always.mdc 结尾
  - Agent 选择规则: 此规则不需要加载到每个聊天线程中，它服务于特定目的。description 必须提供全面的上下文，包括代码更改、架构决策、错误修复或新文件创建的场景。glob 为空，alwaysApply:false 且文件名以 -agent.mdc 结尾
- 对于规则内容 - 专注于明确的行动指令，无需不必要的解释
- 当规则只会在某些情况下使用时（alwaysApply: false），描述必须提供足够的上下文，以便 AI 可以自信地确定何时加载和应用规则
- 使用适合 Agent 上下文窗口的简洁 Markdown
- 在 XML 示例部分中始终使用2个空格缩进内容
- 虽然没有严格的行限制，但要注意内容长度，因为它会影响性能，需要专注于帮助 Agent 做出决策的关键信息
- 规则示例中总是包括一个有效的和无效的示例
- 永远不要在 glob 模式周围使用引号，永远不要将 glob 扩展与 `{}` 一起分组
- 如果请求规则或未来行为更改包括错误上下文，这将是在规则示例中使用的绝佳信息
- 在规则创建或更新后，响应以下内容：
  - 自动规则生成成功: {规则文件相对路径及文件名}
  - 规则类型: {auto|agent|manual|always}
  - 规则描述: {描述字段的确切内容}
    
    
    
    
    
     
    
    
    
    
    