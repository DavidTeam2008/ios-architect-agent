# Contributing

欢迎 issue 与 PR。这个仓库的目标不是“更长的 prompt”，而是**更稳定、更可验证的 agent 行为**。

## 提交前

1. 不要提交公司内部信息、客户数据、密钥、内部 URL 或未公开的架构细节。
2. 保持内容通用化：用“大型 OTA App”“定制 RN 框架”等表述，不绑定具体公司。
3. 修改 agent / skill 后，按 `skills/ios-rn-playbook/evals/golden-set.md` 跑一遍 baseline；
   一次只改一个变量，劣化超过 10% 回滚。
4. 本地校验：

```bash
claude plugin validate ~/.claude
```

5. 不要用 `skills:` 预加载 `ios-rn-playbook`；它是按需知识库，预加载会失去渐进披露优势。

## PR 约定

- 一个 PR 只做一件事（路由、工具、输出契约、领域知识分开）。
- 涉及事实更新（版本号、API 弃用状态）时附官方来源链接与日期。
- 新增规则时说明它解决的具体失败案例；没有失败案例的规则优先不加。
- 保持中文 prompt 的可读性；英文术语保留原文。

## 安全

- agent 的只读/禁改边界最终应由 Claude Code settings 的 `permissions.deny` 与 hooks 强制，prompt 只是补充。
- 不要在 reference 中放可执行脚本；脚本放 `scripts/`，只给路径不读内容。
