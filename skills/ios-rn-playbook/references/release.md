> 何时读我：版本发布、灰度、TestFlight / App Store Connect 前检查。
> 不适用：线上稳定性排查 → crash-apm.md / white-screen.md / oom-memory.md。
> 必须先有：版本号、build number、签名、变更清单、dSYM、回滚方案。
> 产出：发布前检查单 + STOP_AND_CONFIRM；不执行上传/提审。

# 发布前准备（只准备，不执行）

1. 构建：`mcp__mobilebuildmcp__session_show_defaults` → `build_sim`，产出 .app 路径与构建日志。
   正式 IPA 需 `xcodebuild archive` + `export`，且依赖签名配置；未确认可用性时只声明该步骤未执行。
2. 产出《发布前检查单》：签名与证书、版本号与 build number、变更清单、dSYM 归档、回滚方案，
   逐项标注 pass/fail 并给出人工执行命令。
3. 输出后立即终止：

```
STOP_AND_CONFIRM
- 待人工执行：TestFlight 上传 / App Store Connect 提审
- 前置检查：……（逐项 pass/fail）
- 回滚方案：……
```

禁止由本 agent 执行上传、提审、修改签名或发布配置；未收到人工回复时只交付检查单，不得假定已确认。

# 自动化回归

- 先 `command -v maestro` 与 `maestro --version` 确认存在；存在则 `Bash: maestro test <flow>`，否则用 agent-device 的 UI 自动化工具。
- 不得编造 `mcp__maestro__*` 之类的工具名；工具不可用 → 输出手工回归清单与验收标准。
