---
name: ios-rn-playbook
description: 大型 OTA App iOS 混合架构（OC 基建 + 定制 RN）专项排查与优化 playbook，覆盖白屏、OOM/FOOM、发热耗电、崩溃归因、启动/页面/列表性能、RN 升级、系统兼容、架构重构与发布前检查。由 ios-rn-architect 按任务类型读取对应 references 文件。不用于纯外部资料调研（交 ios-researcher）。
---

# 使用方式

- 本 skill 是 architect 的按需知识库，不是常驻 prompt。
- 先按任务类型选择 1-2 个 reference，再 Read；不要遍历目录、不要一次读多个。
- 每个 reference 头部有「何时读我 / 不适用 / 必须先有 / 产出」。
- reference 正文不进入返回结果；最终输出仍按 architect 的输出契约。
- 不要用 `skills:` 预加载本 skill（会全量注入，失去渐进披露优势）。
- reference 根目录：本 skill 目录下 `references/`；architect 用 `$HOME/.claude/skills/ios-rn-playbook/references/` 的绝对路径读取。

# 路由表

| 任务 | reference |
| --- | --- |
| 白屏 | white-screen.md |
| OOM / FOOM / 内存 | oom-memory.md |
| 发热 / 耗电 | power-battery.md |
| 崩溃归因 / 混合栈 | crash-apm.md |
| 启动异常 / 启动性能 | startup-performance.md |
| 页面 / 列表 / 包体积性能 | page-list-performance.md |
| iOS 系统兼容 | ios-compat.md |
| RN 版本升级 / 新架构迁移 | rn-upgrade.md + architecture-refactor.md |
| 架构重构 / 桥接层改造 / 新业务落地 | architecture-refactor.md |
| 发布 / 灰度 | release.md |

# 纪律

- 单任务最多读 2 个 reference；现象收敛后再读，避免被日志挤到上下文中段。
- reference 之间只允许一行指针互引，不复制正文。
- 不在 reference 放可执行脚本；脚本放 `scripts/`，只给路径不读内容。
- 事实更新（版本号、弃用状态）以 Apple / RN 官方来源为准。

# 评测

- 回归用例与评分口径：`evals/golden-set.md`。
- 改 agent / skill 后先跑 baseline，再一次只改一个变量复测；劣化 >10% 回滚。
