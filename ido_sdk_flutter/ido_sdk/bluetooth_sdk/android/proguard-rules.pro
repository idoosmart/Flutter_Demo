# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in E:\tools\sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-dontshrink#混淆jar的时候一定要配置，不然会把没有用到的代码全部remove   我本来封装一个jar就是给别人调用的，全部删掉就没有东西了
-verbose

-keepattributes Signature #过滤泛型 用到发射，泛型等要添加这个
-keepattributes *Annotation*

-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

#如果你使用了ProGuard来导入第三方jar这个地方就不用配置了
#-libraryjars ../meddo/libs/android.jar
#-libraryjars ../meddo/libs/gson-2.5.jar
#-libraryjars ../meddo/libs/okhttp-2.5.0.jar
#-libraryjars ../meddo/libs/okio-1.6.0.jar

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
#-keep public class com.android.vending.licensing.ILicensingService

#-keepclasseswithmembernames class * {
#    native <methods>;
#}
#
#-keepclasseswithmembernames class * {
#    public <init>(android.content.Context, android.util.AttributeSet);
#}
#
#-keepclasseswithmembernames class * {
#    public <init>(android.content.Context, android.util.AttributeSet, int);
#}

#-keepclassmembers enum * {
#    public static **[] values();
#    public static ** valueOf(java.lang.String);
#}

#-keep class * implements android.os.Parcelable {
#  public static final android.os.Parcelable$Creator *;
#}
#公开两个方法供使用者调用
#-keep public class com.hsji.makejar.MeddoInterface{
# public static void UserLogin(java.util.HashMap, com.hsji.makejar.network.ResultCallback);
# public static void init(android.content.Context);
#}
#解析数据是用的的bean  完全不混淆，不然解析json数据时什么都找不到
#-keep public class com.hsji.makejar.UserLoginResponse{*;}
#不要混淆ResultCallback的public方法
#-keep public class com.hsji.makejar.network.ResultCallback{
# public <methods>;
#}

#okhttp
#-dontwarn com.squareup.okhttp.**
#
#-keep class com.squareup.okhttp.** { *;}
#
#-dontwarn okio.**
#
#-keep class okio.** {*;}

#json
-dontwarn com.google.gson.**
-keep class com.google.gson.**{*;}
-keep class com.alibaba.fastjson.**{*;}

-keep class com.realsil.**{*;}

#升级
-keep class com.example.flutter_bluetooth.**{*;}

-keep class no.nordicsemi.android.dfu.**{ *; }