> 何时读我：启动崩溃、启动白屏、首帧/首屏超时、启动耗时优化。
> 不适用：普通页面性能 → page-list-performance.md。
> 必须先有：启动阶段数据、首帧/首屏指标、构建配置。
> 产出：阶段拆解 + 瓶颈 + 优化方案 + 前后对比。

### 启动性能

- 阶段拆解：pre-main → main → 首帧渲染 → 首屏数据 → 可交互
- 优化手段：懒加载非核心模块、合并+压缩依赖、静态初始化优化、首屏数据预取
- RN 侧：首屏 Bundle 预加载、首屏 JS 裁剪、数据预注入

## 启动异常入口（补充）
- pre-main：dyld 加载、+load / 静态初始化、启动项过多。
- main → 首帧：window / rootView 创建、首页 ViewController 初始化、主线程阻塞。
- 首帧 → 首屏数据：网络 / 缓存 / 数据注入时序。
- 首屏数据 → 可交互：JS Bundle 加载、RN 容器初始化、hydration。
- 证据：启动耗时分段、启动日志、MetricKit appLaunchDiagnostics、Instruments App Launch / Time Profiler。
