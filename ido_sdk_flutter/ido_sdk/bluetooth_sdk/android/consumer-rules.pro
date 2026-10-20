# ============================================================
# IDO Bluetooth SDK（flutter_bluetooth）—— 下发给接入方 App 的 ProGuard / R8 规则
#
# 本文件由 build.gradle 的 consumerProguardFiles 声明，会被 AGP 打进 AAR 的
# proguard.txt，并自动合并进接入方 App 的 R8 配置。因此这里只允许出现 SDK
# 自身运行所必需的规则：
#   - 不得出现作用于整个 App 的全局 keep（四大组件、公共库整包等）
#   - 不得出现 -optimizations / -optimizationpasses 等会改变接入方构建行为
#     的开关
# 违反上述约束会拉低 Google Play「DEX 代码优化」的
# shrinking / optimization / obfuscation 覆盖率（要求不低于 25%）。
#
# SDK 自身构建时的混淆配置请改 proguard-rules.pro，那份不会下发给接入方，
# 两个文件用途不同，勿相互复制。
# ============================================================

# ---------- SDK 对外 API 与 GsonUtil 反射解析的数据类 ----------
-keep class com.idosmart.bluetooth.** { *; }

# ---------- Nordic DFU（Flutter 默认随库传递；Native AAR 打包时为 compileOnly）----------
# 打包态（idoSdkPackaging=true）下 App 须按需 implementation dfu:2.5.0；
# 已集成时 keep Service/回调相关类；未集成时 -dontwarn 避免 R8 Missing class。
-keep class no.nordicsemi.android.dfu.** { *; }
-dontwarn no.nordicsemi.android.dfu.**
-dontwarn no.nordicsemi.android.error.**

# ---------- Gson 反射所需的元数据属性 ----------
-keepattributes Signature
-keepattributes *Annotation*

# ---------- 仅抑制告警，不阻止 R8 优化 ----------
-dontwarn com.google.gson.**
