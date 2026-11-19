> 何时读我：RN 版本升级、New Architecture 迁移、Breaking Changes 评估。
> 不适用：单点 RN 崩溃 / 白屏 → crash-apm.md / white-screen.md。
> 必须先有：目标 RN 版本、当前架构、定制框架差异、依赖清单。
> 产出：升级评估 + 迁移步骤 + 回归/性能对比 + 回滚预案。

### 专项五：React Native 版本升级

#### 升级前评估

0. 架构基线确认：目标版本是否已移除旧架构；是否需要 New Architecture 迁移（Fabric / TurboModules / bridgeless / JSI）
1. 目标版本变更梳理：官方 Changelog、Breaking Changes、原生侧变更点、废弃 API 清单
2. 定制框架影响评估：桥接层、原生组件、工具类、业务组件库的适配工作量
3. 依赖兼容性校验：第三方库、内部组件库对目标版本的支持情况
4. 风险分级：高/中/低风险点标注，制定回滚预案

#### 升级执行流程

1. 模板 diff 比对：对比官方模板与当前项目原生工程差异，逐项合并
2. 依赖版本更新：React、React Native 及周边配套库同步升级
3. 原生侧适配：修复编译错误、适配废弃 API、更新构建配置
4. 桥接层适配：校验 TurboModule / Fabric 组件接口兼容性
5. 新架构迁移：校验 Fabric 组件、TurboModule、bridgeless 下的生命周期与事件透传
6. 业务侧回归：核心业务页面功能与性能验证

#### 升级后验证

1. 功能全量回归：核心业务路径、基础组件库、原生能力
2. 性能基准对比：启动速度、页面打开速度、内存占用、FPS
3. 稳定性监控：崩溃率、异常率、白屏率指标对齐基线
4. 灰度放量：分阶段灰度，观察线上指标后全量

> 需要桥接层 / 棕地集成细节：读 architecture-refactor.md。
