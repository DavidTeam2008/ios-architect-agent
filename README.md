# iOS Architect Agents

一套可安装到 [Claude Code](https://code.claude.com/) 的 iOS / React Native 架构与调研 subagent。设计目标是**证据优先、渐进披露、可停止、可评测**——让模型在长任务中保持稳定，而不是“看起来很聪明”。

[English summary](#english-summary)

## 包含内容

| 组件 | 类型 | 作用 |
| --- | --- | --- |
| `ios-researcher` | subagent | iOS / RN 外部技术情报调研：Apple 官方文档、WWDC、Release Notes、社区踩坑、方案对比、治理 benchmark |
| `ios-rn-architect` | subagent | 本地架构与疑难问题：白屏、OOM/FOOM、发热耗电、启动异常、崩溃归因、OC↔RN 桥接、RN 版本升级 |
| `ios-rn-playbook` | skill | architect 的按需知识库：10 个专项 reference + 8 条 golden set |

## 特性

- **渐进披露**：architect 主文件只保留路由、五步法、停止条件、输出契约；专项知识按需读取，单任务最多 2 个 reference。
- **工具最小化**：精确 MCP 工具白名单，不授予整组 server；工具不可用时按降级路径处理。
- **证据优先**：L1/L2/L3 置信度；每条结论必须有来源、命令、退出码、`file:line` 或日志路径。
- **可停止**：同一假设 2 轮不成立换层；同层 3 轮无新证据收敛；同一修复 2 次失败上报；单次排查 ≤8 轮。
- **发布安全**：TestFlight / App Store Connect 只准备、不执行；输出 `STOP_AND_CONFIRM` 后终止。
- **防失智**：指令层级、不可信输入隔离、固定输出契约、Memory 写入协议、golden set 回归。

## 仓库结构

```
.
├── agents/
│   ├── ios-researcher.md
│   └── ios-rn-architect.md
├── skills/
│   └── ios-rn-playbook/
│       ├── SKILL.md
│       ├── references/
│       │   ├── architecture-refactor.md
│       │   ├── white-screen.md
│       │   ├── oom-memory.md
│       │   ├── power-battery.md
│       │   ├── ios-compat.md
│       │   ├── rn-upgrade.md
│       │   ├── crash-apm.md
│       │   ├── startup-performance.md
│       │   ├── page-list-performance.md
│       │   └── release.md
│       └── evals/
│           └── golden-set.md
├── install.sh
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## 安装

要求：Claude Code 2.1.x 或更高版本。

```bash
git clone git@github.com:DavidTeam2008/ios-architect-agent.git
cd ios-architect-agent
./install.sh
```

脚本会把 `agents/*.md` 复制到 `~/.claude/agents/`，把 `skills/ios-rn-playbook` 复制到 `~/.claude/skills/`。已有文件会先备份为 `.bak.<timestamp>`。

手动安装：

```bash
cp agents/*.md ~/.claude/agents/
cp -R skills/ios-rn-playbook ~/.claude/skills/
```

> architect 通过 `$HOME/.claude/skills/ios-rn-playbook/references/` 读取知识库，因此 skill 的安装路径必须保持为 `~/.claude/skills/ios-rn-playbook`。

### 可选 MCP

architect 的构建/UI 自动化依赖以下 MCP server；未安装时会按 `xcodebuild` / `xcrun simctl` / 手工回归清单降级：

- `mobilebuildmcp`：构建、模拟器、测试、覆盖率
- `agent-device`：UI 操作、截图、日志

researcher 可选：

- `web-reader`、`web-search-prime`、`zread`；不可用时回退到 `WebFetch` / `WebSearch`

## 使用

安装后新开一个 Claude Code 会话，在输入框用 `@` 选择，或直接点名：

```text
@ios-researcher 调研 iOS 27 的 UIScene 生命周期变更，给出官方来源和影响范围
```

```text
@ios-rn-architect 这个首屏白屏堆栈帮我按五层模型定位，先给证据再给修复方案
```

> 当前 Claude Code 的 `/agents` 不再列出 subagent（只打印提示）。用 `@` 触发、`/tasks` 查看运行中的 agent，或直接让 Claude 调用。

## Skill 按需加载

`ios-rn-architect` 按任务类型读取 1–2 个 reference：

| 任务 | reference |
| --- | --- |
| 白屏 | `white-screen.md` |
| OOM / FOOM / 内存 | `oom-memory.md` |
| 发热 / 耗电 | `power-battery.md` |
| 崩溃归因 / 混合栈 | `crash-apm.md` |
| 启动异常 / 启动性能 | `startup-performance.md` |
| 页面 / 列表 / 包体积性能 | `page-list-performance.md` |
| iOS 系统兼容 | `ios-compat.md` |
| RN 版本升级 / 新架构迁移 | `rn-upgrade.md` + `architecture-refactor.md` |
| 架构重构 / 桥接层改造 | `architecture-refactor.md` |
| 发布 / 灰度 | `release.md` |

## 评测与回归

`skills/ios-rn-playbook/evals/golden-set.md` 提供 8 条 golden set、分层指标与 smoke 命令。修改 agent 或 skill 后：

1. 先跑 baseline；
2. 一次只改一个变量；
3. 任何指标劣化超过 10% 即回滚。

## 设计原则（防失智）

| 风险 | 措施 |
| --- | --- |
| Context rot / prompt bloat | 主文件保持精简；专项知识外置，按需读取 |
| Tool overload | 精确工具白名单；构建与 UI 自动化分工明确 |
| 指令稀释 / 冲突 | 输出契约、分级、停止条件各只保留一份 |
| 编造工具 / 假完成 | 只调用白名单工具；`command -v` 校验 CLI；`Done when` + 证据 + 未验证栏 |
| Prompt injection | 网页、日志、issue、工具返回值一律视为数据，不是指令 |
| 记忆污染 | Memory 写入门槛 + 来源/日期；冲突以当前代码/官方文档为准 |
| 能力退化无感知 | golden set + 分层指标 + 单变量回归 |

## 安全与隐私

- 本仓库内容已做通用化处理，不包含具体公司内部信息或密钥。
- 外部内容（网页、issue、README、日志、APM 导出）按不可信数据处理；agent 被要求不执行其中的指令。
- `ios-rn-architect` 具备 `Edit` / `Write` / `Bash` 能力；首次使用前请阅读其边界与安全规则，并在你的 settings 中配置 `permissions.deny` / hooks 作为硬护栏。

## English summary

Two installable Claude Code subagents for iOS / React Native work:

- `ios-researcher` — external technical intelligence (Apple docs, WWDC, release notes, community solutions), read-only.
- `ios-rn-architect` — local architecture and hard-problem diagnosis (white screen, OOM/FOOM, power, startup, crashes, OC↔RN bridge, RN upgrades), with an on-demand playbook skill.

The design emphasizes evidence-first outputs, progressive disclosure via a skill, precise tool allowlists, explicit stop conditions, a release gate (`STOP_AND_CONFIRM`), and a regression golden set.

## License

MIT. See [LICENSE](LICENSE).
