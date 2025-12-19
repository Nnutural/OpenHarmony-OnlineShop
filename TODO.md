华为鸿蒙-电子商城
增加：
https://developer.huawei.com/consumer/cn/codelabsPortal/carddetails/tutorials_NEXT-WaterFlow


# DONE

# TODO
商品详细介绍页，增加搜索功能并可查看

3）P0：商品详情页（TODO.md 第一项）

目标：把“点击列表项 → 进入详情 → 看完整信息 → 可加购”打通。

 路由与页面骨架

 新建 pages/ProductDetailPage.ets。

 路由参数：至少传 productId（以及可选 from=search/home）。

 进入页：调用 getProductById(productId)；包含 loading/失败重试。

 UI 模块拆分（建议按区块做组件）

 ProductGallery：轮播/左右滑图片（images[]）。

 ProductHeader：标题、价格、销量、评分、标签。

 ProductSpecs：规格/sku 选择（先做单规格也行）。

 ProductDetail：图文详情（detailBlocks 或 html 渲染策略二选一）。

 底部 ActionBar：加入购物车、立即购买（购买可先 toast/占位）。

 实现“加购”最小闭环

 新建 store/cart.store.ts（见第 5 节会扩展）：add(product, sku, count)、remove、updateCount、totalCount。

 详情页点击“加入购物车”后：本地 store 更新 + toast 提示。

4）P0：搜索功能（TODO.md 第二项）

目标：用户能“搜 → 看结果 → 点进详情”。

 搜索入口

 首页顶部加入搜索入口（点击进入 SearchPage 或直接内联搜索框）。

 如果使用独立页面：新建 pages/SearchPage.ets。

 搜索交互

 输入框：实现 debounce（例如 300ms）+ 清空按钮 + 回车搜索。

 搜索历史：本地存储（key：search_history，最多 20 条，去重）。

 热门搜索：先 mock（后续可由服务返回）。

 结果展示

 结果列表仍用 WaterFlow（复用 ProductCard），保持一致体验。

 空结果页：给出“无结果/换个关键词/清空筛选”。

 验收标准

 输入关键词能过滤到正确商品；点击结果能进入详情页；返回能保持上次 query 与滚动位置。

5）P1：购物车页 + 订单占位（为“跨设备同步/卡片”铺垫）

你提出的“跨设备购物车同步 Agent、桌面卡片、订单状态卡片”都需要购物车/订单的最小数据结构先落地。

 购物车页面

 pages/CartPage.ets：列表、数量加减、全选、删除、总价结算。

 购物车持久化：本地 KV/Preferences（先本地，后面再升级分布式）。

 订单占位（不用做支付，做结构即可）

 models/Order.ts + pages/OrdersPage.ets：展示“待付款/待发货/待收货”三类列表（数据先 mock）。

 让后续 Widget 可以直接读“最近订单状态”。

6）P2：跨设备购物车同步（分布式数据能力优先落地）

实现建议：优先用分布式 KV 存储/数据管理做同步，而不是一上来就依赖“ServiceExtensionAbility 充当后台 Agent”。原因是 OpenHarmony 文档里明确：Stage 模型的 ServiceExtensionAbility 目前仅对系统应用开放；普通三方应用可能无法按你设想部署“纯后台服务”。
OpenHarmony

 分布式购物车数据模型

 key 设计：cart:<accountId> → value（JSON 字符串/结构化序列化）。

 冲突策略：同一商品以“最后写入时间 + 合并计数”为准（写入携带 updatedAt）。

 实现分布式 KV 读写与同步

 新建 services/distributed-cart.service.ts

 初始化分布式 KV store（创建/获取 storeId）。

 loadCart()：优先读分布式；失败则读本地。

 saveCart()：写入分布式并触发同步；本地同时落盘（离线可用）。

 UI 侧：cart.store.ts 订阅变化（拉/推都行），变化自动刷新 UI。

分布式 KV/数据管理属于 ArkData 体系，OpenHarmony 文档对分布式数据管理/接口有专门说明。
码云
+1

 验收标准

 两台同账号设备：A 加购后，B 打开购物车能看到一致数据（允许秒级延迟）。

 断网：本地仍可加购；网络恢复后能合并同步。

7）P2：原子化服务卡片（Service Widget / FormExtensionAbility）

目标：把“搜索入口/热门商品/订单状态”放到桌面卡片，形成 HarmonyOS 亮点。ArkTS 支持通过表单扩展能力实现服务卡片（FormExtensionAbility）。
码云
+1

 卡片能力接入

 新增 FormExtensionAbility（如 EntryFormAbility.ets），并在 module.json5 注册扩展能力与卡片配置。

 新增 resources/base/profile/form_config.json：定义 2x2 / 4x2 两种规格。

 卡片内容设计（按你建议落地）

 小卡（2x2）：1 个热门商品（图 + 价）/ 最近浏览商品。

 大卡（4x2）：最近 3 笔订单状态 + 一个“快速搜索”按钮。

 跳转与参数

 点击商品 → 跳转详情页并带 productId

 点击搜索 → 跳转 SearchPage 并自动聚焦输入框

 数据来源

 热门商品：product.service mock

 订单状态：orders mock（后续接真实）

 卡片刷新：先做“手动刷新/定时刷新”的最小实现

8）P3：分布式商品详情页流转（Ability Continuation + 状态恢复）

目标：在详情页加“流转到附近设备”按钮，把当前商品 + UI 状态（sku、滚动位置）迁移过去。OpenHarmony/UIAbility 体系支持跨设备迁移，并且滚动容器可通过 restoreId 等机制参与状态恢复。
OpenHarmony
+2
OpenHarmony
+2

 详情页状态可序列化

 continueData = { productId, selectedSkuId, scrollOffset }

 在详情页：监听滚动容器位置；进入/返回时恢复。

 接入 continuation 流程

 UIAbility 实现 continuation 回调：保存 continueData、恢复 continueData。

 详情页加“流转”按钮：调起设备选择/发起迁移（具体 API 以当前 SDK 为准；Agent 按官方 continuationManager 流程实现）。
华为开发者

 验收标准

 设备 A 在详情页中间位置 → 点击流转 → 设备 B 打开同一商品并尽量恢复到接近位置/同一 sku。

9）P3：智能导购 Agent（先规则化，后可插拔 LLM）

为了可控与可验收，建议分两步：先做“本地规则推荐”，再把“LLM 文案生成/搭配推荐”做成可插拔 Provider。

 行为埋点（本地）

 记录：曝光、点击、搜索词、加购、收藏（如果做收藏）。

 本地聚合：最近浏览、偏好标签 topN。

 推荐策略 v1（不依赖外部 AI）

 “相似标签 + 热门度”的简单排序。

 在首页/详情页底部展示“你可能还喜欢”。

 LLM Provider（可选）

 services/reco-llm.provider.ts：输入（用户偏好摘要 + 候选商品）→ 输出（推荐理由/搭配文案）。

 默认关闭；需要用户显式开启；并在 docs/PRIVACY.md 说明数据范围与脱敏策略。

10）交付检查清单（Agent 每完成一块就自检）

 关键路径：首页列表 → 搜索 → 详情 → 加购 → 购物车 全程无崩溃。

 状态完备：loading/空态/错误态齐全。

 可演示素材：screenshots/ 补齐（首页、搜索、详情、购物车、卡片、流转）。

 更新 README.md：从“瀑布流示例”升级为“电子商城 MVP + Harmony 亮点能力”说明（保留原 WaterFlow 说明也可以）。
GitHub
+1