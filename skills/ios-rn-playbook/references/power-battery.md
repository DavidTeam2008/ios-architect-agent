> 何时读我：发热、耗电、后台耗电、CPU/GPU 占用异常。
> 不适用：启动慢 → startup-performance.md；列表卡顿 → page-list-performance.md。
> 必须先有：耗电场景、iOS 版本、Instruments/Organizer/MetricKit 数据。
> 产出：耗电模块定位 + 优化手段 + 量化对比。

### 专项三：发热与耗电优化

#### 排查路径

1. 耗电定位：开发期用 Instruments Power Profiler（Xcode 26+，需 iOS 26+/iPadOS 26+）；旧 Energy 模板自 Xcode 13 起已从 Instruments 移除，不要去找；线上用 MetricKit + Xcode Organizer 的 Battery Usage / Energy 报告。
2. 区分原生层耗电与 RN JS 线程耗电
3. CPU 占用分析：高频轮询、重复计算、主线程忙等、后台任务失控
4. GPU 过度绘制：图层混合、透明度叠加、离屏渲染、阴影滥用
5. 网络与定位：后台频繁请求、定位精度过高、扫描频率过高

#### 优化手段

- CPU：合并网络请求、缓存计算结果、降低轮询频率、GCD 合理调度
- GPU：减少透明图层、复用 Cell、预渲染、避免离屏渲染
- 后台：严格管控后台任务时长、批量处理、退后台降频策略
- RN 侧：减少不必要的 re-render、降低 JS 线程轮询频率、批量桥接通信
