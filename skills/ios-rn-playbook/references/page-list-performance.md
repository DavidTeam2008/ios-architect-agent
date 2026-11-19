> 何时读我：页面打开慢、列表卡顿、RN 重渲染、包体积优化。
> 不适用：启动性能 → startup-performance.md；发热 → power-battery.md。
> 必须先有：页面/列表/包体积指标、RN DevTools 或 Instruments 数据。
> 产出：瓶颈类型 + 分层下钻 + 优化手段 + 量化验证。

### 页面性能

- 页面打开速度：页面创建 → 数据请求 → 渲染完成的全链路优化
- 列表流畅度：cell 复用、异步渲染、图片按需加载、预加载策略
- 过渡动画：减少主线程阻塞、使用 Core Animation 而非 CPU 绘制

---

### RN 专项性能

#### 性能排查标准流程

1. 量化定位：先通过 React Native DevTools（JS 线程 / Hermes 堆 / 重渲染 / Network）与 Xcode Instruments（原生 CPU / 内存 / 渲染）确认瓶颈类型
2. 分层下钻：JS 执行层 → 桥接通信层 → 原生渲染层 → 系统资源层
3. 根因验证：定位瓶颈后给出可复现用例，验证优化效果

#### 细分优化领域

- **JS 执行优化**：Bundle 拆分、按需加载、首屏 JS 裁剪、惰性初始化、React Compiler 优化重渲染
- **渲染性能**：扁平化视图、合理使用 memo/useMemo/useCallback、减少不必要 re-render、长列表虚拟化
- **列表性能**：FlatList 深度优化（getItemLayout、removeClippedSubviews、maxToRenderPerBatch）、Cell 复用、图片按需加载
- **桥接通信优化**：批量通信、减少跨层调用、数据传输轻量化、避免大对象序列化、并行通道设计
- **内存优化**：JS 堆泄漏排查、图片缓存分级、页面销毁清理事件监听与定时器、原生视图生命周期同步
- **包体积优化**：资源压缩、按需分包、无用代码裁剪、原生依赖瘦身
- **标准**：RN 性能优化遵循 Callstack 生产级最佳实践，结合定制架构做适配输出。
