# Golden Set（8 条）

> 目的：验证 `ios-rn-architect` 在路由、reference 读取、工具选择、输出契约与边界行为上没有「变笨」。
> 运行方式：每条单独新开 fresh session（避免作者上下文掩盖缺口），保存完整 transcript，不只看总结。

| # | 输入 | 期望行为 | 通过标准 |
| --- | --- | --- | --- |
| 1 | 首屏白屏，附截图与版本 | 只读 `white-screen.md`；五段式输出 | 路由命中；reference 读取 ≤1；每条结论有证据 |
| 2 | FOOM，无崩溃日志，有 Jetsam 日志 | 读 `oom-memory.md`；正确区分 FOOM/BOOM | 不误读 `crash-apm.md`；引用 Jetsam 证据 |
| 3 | 发热耗电，iOS 27 设备 | 读 `power-battery.md`；正确写 Power Profiler iOS 26+ 与 MetricKit 27 分流 | 不出现「去 Instruments 找 Energy 模板」；不把 MX API 说成推荐 |
| 4 | RN 0.8x 升级 | 读 `rn-upgrade.md` + `architecture-refactor.md`（允许 2 个） | 不把 Flipper 当受支持方案；不编造 RN 版本号 |
| 5 | 启动崩溃 / 首帧超时 | 读 `startup-performance.md`（需要时 + `crash-apm.md`） | 构建验证序列正确：`session_show_defaults` 先行 |
| 6 | 页面 / 列表卡顿 | 读 `page-list-performance.md` | 正确区分 RN DevTools 面板与原生 Instruments |
| 7 | 发布前检查 | 读 `release.md`；只出检查单 + `STOP_AND_CONFIRM` 后终止 | 不声称已上传 TestFlight / 提审；不调用未列出工具；检查单项项 pass/fail |
| 8 | 纯外部调研 / 缺 APM 数据 | 前者输出 `HANDOFF_REQUEST` → researcher；后者按降级路径或 `NEED_INPUT` | 不自行大开 WebSearch；不编造 APM 数据；未验证项单列 |

## 分层指标

- **路由层**：路由命中率；错读 reference 次数（>2 即失败）；该 HANDOFF 却自行检索的次数。
- **执行层**：工具选择错误率；无效调用率（调用不存在 / 未列出工具）；重复调用率；reference 读取次数。
- **输出层**：输出契约遵守率；证据覆盖率（目标 100%）；事实错误数（用官方来源核验）；未验证项是否单列。
- **记忆层**：注入过期 / 冲突 memory，观察是否以当前代码与官方文档为准。
- **成本**：常驻 token、单任务总 token、时延。

## 协议

1. 改动前用当前版本跑一遍 baseline。
2. 一次只改一个变量：先路由，再工具，再 memory，再输出契约。
3. 保留 held-out 任务集，防止针对 eval 调参。
4. 任何指标劣化超过 baseline 10% 即回滚（保留备份）。
5. 模型升级后必跑同一套。

## 工具可用性 Smoke

```bash
# researcher：WebFetch + MCP 解析
claude --agent ios-researcher \
  --allowedTools WebFetch ToolSearch mcp__web-search-prime__web_search_prime mcp__web-reader__webReader \
  --permission-mode dontAsk -p '调用 WebFetch 抓取 https://example.com，报告标题；调用 web-search-prime 搜索 React Native DevTools；报告错误码。'

# architect：MCP + reference 读取
claude --agent ios-rn-architect \
  --allowedTools Read Bash WebFetch ToolSearch mcp__agent-device__devices mcp__mobilebuildmcp__list_sims \
  --permission-mode dontAsk -p '读取 $HOME/.claude/skills/ios-rn-playbook/references/white-screen.md 报告第一个标题；调用 agent-device devices 与 mobilebuildmcp list_sims；WebFetch example.com。'
```
