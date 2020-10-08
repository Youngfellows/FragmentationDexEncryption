########################################
#
# 通用混淆配置
#
########################################

# 代码混淆压缩比，在0~7之间，默认为5，一般不做修改
-optimizationpasses 5

# 混合时不使用大小写混合，混合后的类名为小写
-dontusemixedcaseclassnames

# 指定不去忽略非公共库的类
-dontskipnonpubliclibraryclasses

# 这句话能够使我们的项目混淆后产生映射文件
# 包含有类名->混淆后类名的映射关系
-verbose

# 指定不去忽略非公共库的类成员
-dontskipnonpubliclibraryclassmembers

# 不做预校验，preverify是proguard的四个步骤之一，Android不需要preverify，去掉这一步能够加快混淆速度。
-dontpreverify
-dontoptimize

# 混淆时是否记录日志
-verbose
-ignorewarnings

# 保留Annotation不混淆
-keepattributes *Annotation*

# 避免混淆泛型
-keepattributes Signature
-keepattributes Exceptions,InnerClasses

-dontnote com.google.vending.licensing.ILicensingService
-dontnote com.android.vending.licensing.ILicensingService

# 抛出异常时保留代码行号
-keepattributes SourceFile,LineNumberTable
-keepattributes Deprecated,Synthetic,EnclosingMethod

# 重命名抛出异常时的文件名称
-renamesourcefileattribute SourceFile

# 指定混淆是采用的算法，后面的参数是一个过滤器
# 这个过滤器是谷歌推荐的算法，一般不做更改
-optimizations !code/simplification/cast,!field/*,!class/merging/*

#忽略警告
#-ignorewarning

#######################################################
#
#记录生成的日志数据,gradle build时在本项目根目录输出
#
#######################################################
#apk 包内所有 class 的内部结构
-dump ./mapping/class_files.txt
#未混淆的类和成员
-printseeds ./mapping/seeds.txt
#列出从 apk 中删除的代码
-printusage ./mapping/unused.txt
#混淆前后的映射
-printmapping ./mapping/mapping.txt


#############################################
#
# Android开发中一些需要保留的公共部分
#	
#	保留自定义View的set方法和get方法不要被混淆 set*代表任意字符
#  	通配符*，匹配任意长度字符，但不含包名分隔符(.)
# 	通配符**，匹配任意长度字符，并且包含包名分隔符(.)
#	通配符***，匹配任意参数类型
#
#############################################

# 保留我们使用的四大组件，自定义的Application等等这些类不被混淆
# 因为这些子类都有可能被外部调用
#-keep class com.czq.pets.app.application.**{*;}
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.support.v4.app.Fragment
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class com.android.vending.licensing.ILicensingService


# 保留support下的所有类及其内部类
-keep class android.support.** {*;}
-keep interface android.support.** {*;}
-dontwarn android.support.**

# 保留继承的
-keep public class * extends android.support.v4.**
-keep public class * extends android.support.v7.**
-keep public class * extends android.support.annotation.**
-keep class android.support.annotation.** { *; }
-keep interface android.support.annotation.** { *; }

# support-v4
-dontwarn android.support.v4.**
-keep class android.support.v4.app.** { *; }
-keep interface android.support.v4.app.** { *; }
-keep class android.support.v4.** { *; }

# support-v7
-dontwarn android.support.v7.**
-keep class android.support.v7.internal.** { *; }
-keep interface android.support.v7.internal.** { *; }
-keep class android.support.v7.** { *; }

# support design
-dontwarn android.support.design.**
-keep class android.support.design.** { *; }
-keep interface android.support.design.** { *; }
-keep public class android.support.design.R$* { *; }

# 保留R下面的资源
-keep class **.R$* {*;}

# 保留本地native方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}

# 保留在Activity中的方法参数是view的方法，
# 这样以来我们在layout中写的onClick就不会被影响
-keepclassmembers class * extends android.app.Activity{
    public void *(android.view.View);
}

# 保留枚举类不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留我们自定义控件（继承自View）不被混淆
-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# 保留Parcelable序列化类不被混淆
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# 保留Serializable序列化的类不被混淆
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# 对于带有回调函数的onXXEvent、**On*Listener的，不能被混淆
-keepclassmembers class * {
    void *(**On*Event);
    void *(**On*Listener);
}

# webView处理，项目中没有使用到webView忽略即可
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
    public *;
}
-keepclassmembers class * extends android.webkit.webViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}
-keepclassmembers class * extends android.webkit.webViewClient {
    public void *(android.webkit.webView, jav.lang.String);

}

#不对指定的类、包中的不完整的引用发出警告
-dontwarn android.support.**

# @Keep support annotation.
-keep class android.support.annotation.Keep
-keep @android.support.annotation.Keep class * {*;}
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <methods>;
}
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <fields>;
}
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <init>(...);
}

# 保持测试相关的代码
-dontnote junit.framework.**
-dontnote junit.runner.**
-dontwarn android.test.**
-dontwarn android.support.test.**
-dontwarn org.junit.**

	
#############################################
#
# 	保留自己的项目部分代码不能被混淆（需要根据自己项目）
#
#   1) 网络请求（如果混淆,就会发生字段的错乱，无法正常解析）
#   2) 加密类
#   3) 数据库实体类
#   4) 工具类
#   5) 项目中应用到的第三方工具类（如okhttp，eventbus，rxjava等），需要根据具体的工具介绍进行操作
#   6) 保留lib和compile引用的第三方jar包不被混淆的方法：
#   -keep class 包名.** { *; } 。
#   如：保留引用的科大讯飞的第三方jar包不被混淆
#   -keep class com.iflytek.** { *; }
#   
#############################################
#网络请求等与外界通信不能混淆
#-keep class com.xxxxx.function.**.net.** { *; }
#-keep class com.xxxxx.function.**.bean.** { *; }
#-keep class com.xxxxx.common.net.** { *; }
#-keep class com.xxxxx.common.bean.** { *; }
#加密不能混淆
#-keep class com.xxxxx.crypt.** {*;}


#数据库实体类不能混淆
#-keep class com.xxxxxx.function.**.dao.** { *; }
#工具类不混淆
#-keep class com.xxxxx.common.utils.** { *; }

#greenDAO 3
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
}
-keep class **$Properties
-dontwarn org.greenrobot.greendao.database.**
-dontwarn rx.**

# Fresco
-keep class com.facebook.** {*;}
-keep interface com.facebook.** {*;}
-keep enum com.facebook.** {*;}

# OkHttp3
-dontwarn com.squareup.okhttp3.**
-keep class com.squareup.okhttp3.** { *;}
-dontwarn okio.**

-keepattributes SourceFile,LineNumberTable
-keep class com.parse.*{ *; }
-dontwarn com.parse.**
-dontwarn com.squareup.picasso.**
-keepclasseswithmembernames class * {
    native <methods>;
}

# okhttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn com.squareup.okhttp.**

#Picasso
#-dontwarn com.squareup.okhttp.**

#zxing
-dontwarn com.google.zxing.**
-keep class com.google.zxing.** { *; }


#webview
-dontwarn  com.tencent.**


#eventbus不能混淆
-keepattributes *Annotation*
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}
#如果项目中倒入了de.greenrobot.even的beta1版本，需要添加此行代码
-keepclassmembers class ** {
    public void onEvent*(**);
}


#AndroidEventBus
-keep class org.simple.** { *; }
-keep interface org.simple.** { *; }
-keepclassmembers class * {
    @org.simple.eventbus.Subscriber <methods>;
}
-keepattributes *Annotation*


#高德
-dontwarn  com.amap.api.**
-keep class com.amap.api.** {*;}


#bugout
-dontwarn com.qamaster.android.**
-dontwarn com.testin.agent.**
-keepattributes InnerClasses
-keep class com.testin.agent.** { *; }
-keepattributes SourceFile, LineNumberTable


#butterknife
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewBinder { *; }
-keepclasseswithmembernames class * {
   @butterknife.* <fields>;
}
-keepclasseswithmembernames class * {
   @butterknife.* <methods>;
}


#butterknife
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewBinder { *; }
-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}
-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}


# Apache&HttpClient
-keep class android.net.**{*;}
-dontwarn android.net.**
-keep class com.android.internal.http.multipart.**{*;}
-dontwarn com.android.internal.http.multipart.**
-keep class org.apache.**{*;}
-dontwarn org.apache.**

# commons-lang
-keep class org.apache.commons.lang.**{*;}
-dontwarn org.apache.commons.lang.**


# sharesdk
-keep class cn.sharesdk.**{*;}
-keep class com.sina.**{*;}
-keep class **.R$* {*;}
-keep class **.R{*;}
-dontwarn cn.sharesdk.**
-dontwarn **.R$*
-dontwarn com.tencent.**
-keep class com.tencent.** {*;}


# Glide
-keep public class * implements com.bumptech.glide.module.AppGlideModule
-keep public class * implements com.bumptech.glide.module.LibraryGlideModule
-keep class com.bumptech.glide.** { *; }
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
    **[] $VALUES;
    public *;
}


# xutil 混淆规则
-keepattributes Signature,*Annotation*
-keep public class org.xutils.** {
    public protected *;
}
-keep public interface org.xutils.** {
    public protected *;
}
-keepclassmembers class * extends org.xutils.** {
    public protected *;
}
-keepclassmembers @org.xutils.db.annotation.* class * {*;}
-keepclassmembers @org.xutils.http.annotation.* class * {*;}
-keepclassmembers class * {
    @org.xutils.view.annotation.Event <methods>;
}


#okhttputils
-dontwarn com.zhy.http.**
-keep class com.zhy.http.**{*;}


#友盟统计
-keep class com.umeng.message.protobuffer.* {
     public <fields>;
         public <methods>;
}
-keep class com.umeng.message.* {
     public <fields>;
         public <methods>;
}


#ormLite
-keep public class * extends com.j256.ormlite.android.apptools.OrmLiteSqliteOpenHelper
-keep public class * extends com.j256.ormlite.android.apptools.OpenHelperManager
-keepclassmembers class * {@com.j256.ormlite.field.DatabaseField *;}
-keep class com.j256.ormlite.** {*;}


# Gson specific classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.examples.android.model.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keep class com.google.gson.examples.android.model.** { *; }
# 使用Gson时需要配置Gson的解析对象及变量都不混淆。不然Gson会找不到变量。下面替换成自己的实体类
#-keep class com.ej.ejbase.bean.** { *; }

# gson
-keep class com.google.gson.** {*;}
-keep class com.google.**{*;}
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.examples.android.model.** { *; }

# FastJson 混淆代码
-dontwarn com.alibaba.fastjson.**
-keep class com.alibaba.fastjson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*


#身份证ocr
-keep class com.yd.ocr.idcard.** { *; }
-keep class com.googlecode.** { *; }
-keep class org.opencv.** { *; }


#讯飞语音
-keep class com.iflytek.** { *; }


## retrofit2[version 2.1.0]
-dontnote retrofit2.Platform
-dontnote retrofit2.Platform$IOS$MainThreadExecutor
-dontwarn retrofit2.Platform$Java8
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions
## retrofit2


# 极光推送
-dontoptimize
-dontpreverify
-dontwarn cn.jpush.**
-keep class Lcn.jpush.android.ui.**{*;}
-keep class cn.jpush.** { *; }
-keep class com.test.functionlibrary.jpush.** { *; }
-keep class * extends cn.jpush.android.helpers.JPushMessageReceiver { *; }
-dontwarn cn.jiguang.**
-keep class cn.jiguang.** { *; }
-dontwarn com.google.**
-keep class com.google.gson.** {*;}
-keep class com.google.protobuf.** {*;}


# 友盟统计分析
-keepclassmembers class * { public <init>(org.json.JSONObject); }
-keepclassmembers enum com.umeng.analytics.** {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-dontwarn com.umeng.analytics.**
-keep class com.umeng.analytics.* { *;}
-dontwarn com.umeng.analytics.social.**
-keep class com.umeng.analytics.social.* { *;}


# 友盟统计分析
-keepclassmembers class * { public <init>(org.json.JSONObject); }
-keepclassmembers enum com.umeng.analytics.** {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}


# EventBus
-keepattributes *Annotation*
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }


#activityRouter
-keep class com.github.mzule.activityrouter.router.** { *; }


# Marshmallow removed Notification.setLatestEventInfo()
-dontwarn android.app.Notification


# tinker混淆规则
-dontwarn com.tencent.tinker.**
-keep class com.tencent.tinker.** { *; }

#微信分享
#-dontwarn com.tencent.**
#-keep class com.tencent.** {
#   *;
#}
-keep class com.tencent.mm.opensdk.** {
   *;
}
-keep class com.tencent.wxop.** {
   *;
}
#-keep class com.tencent.mm.sdk.** {
#   *;
#}
-keep class com.dzm.jcenter.share.** {*;}


#QQ
-keep class com.tencent.open.TDialog$*
-keep class com.tencent.open.TDialog$* {*;}
-keep class com.tencent.open.PKDialog
-keep class com.tencent.open.PKDialog {*;}
-keep class com.tencent.open.PKDialog$*
-keep class com.tencent.open.PKDialog$* {*;}

#微博
-dontwarn com.weibo.sdk.Android.WeiboDialog
-dontwarn android.NET.http.SslError
-dontwarn android.webkit.WebViewClient
-keep public class android.Net.http.SslError{
*;
}
-keep public class android.webkit.WebViewClient{
*;
}
-keep public class android.webkit.WebChromeClient{
*;
}
-keep public interface android.webkit.WebChromeClient$CustomViewCallback {
*;
}
-keep public interface android.webkit.ValueCallback {
*;
}
-keep class * implements android.webkit.WebChromeClient {
*;
}

-keep class com.sina.weibo.sdk.api.** {
*;
}

-keep class com.sina.weibo.sdk.** {
*;
}


#router
-keep class com.ej.ejbase.router.**{*;}
-keep class * implements com.ej.ejbase.http.EjBaseInterface{*;}


#3D 地图 V5.0.0之前：
-keep   class com.amap.api.maps.**{*;}
-keep   class com.autonavi.amap.mapcore.*{*;}
-keep   class com.amap.api.trace.**{*;}


#3D 地图 V5.0.0之后：
-keep   class com.amap.api.maps.**{*;}
-keep   class com.autonavi.**{*;}
-keep   class com.amap.api.trace.**{*;}


#定位
-keep class com.amap.api.location.**{*;}
-keep class com.amap.api.fence.**{*;}
-keep class com.autonavi.aps.amapapi.model.**{*;}


#搜索
-keep   class com.amap.api.services.**{*;}


#2D地图
-keep class com.amap.api.maps2d.**{*;}
-keep class com.amap.api.mapcore2d.**{*;}


#导航
-keep class com.amap.api.navi.**{*;}
-keep class com.autonavi.**{*;}


#听云
# ProGuard configurations for NetworkBench Lens
-keep class com.networkbench.** { *; }
-dontwarn com.networkbench.**
-keepattributes Exceptions, Signature, InnerClasses
-keepattributes SourceFile,LineNumberTable


### greenDAO 3
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
}
-keep class **$Properties

### SQLCipher:
-dontwarn org.greenrobot.greendao.database.**
# If you do not use RxJava:
#-dontwarn rx.**

### 腾讯bugly
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}


### 百度地图、替换成自己所用版本的jar包
#-libraryjars libs/BaiduLBS_Android.jar
-keep class com.baidu.** { *; }
-keep class vi.com.gdi.bgl.android.**{*;}


### 腾讯统计
-keep class com.tencent.stat.**  {* ;}
-keep class com.tencent.mid.**  {* ;}



################alipay###############

-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}


################autolayout###############
-keep class com.zhy.autolayout.** { *; }
-keep interface com.zhy.autolayout.** { *; }


################RxJava and RxAndroid###############
-dontwarn rx.**
-keepclassmembers class rx.** { *; }
-dontwarn org.mockito.**
-dontwarn org.junit.**
-dontwarn org.robolectric.**

-keep class io.reactivex.** { *; }
-keep interface io.reactivex.** { *; }

-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.** { *; }
-dontwarn okio.**
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

-dontwarn io.reactivex.**
-dontwarn retrofit.**
-keep class retrofit.** { *; }
-keepclasseswithmembers class * {
    @retrofit.http.* <methods>;
}

-keep class sun.misc.Unsafe { *; }

-dontwarn java.lang.invoke.*

-keep class io.reactivex.schedulers.Schedulers {
    public static <methods>;
}
-keep class io.reactivex.schedulers.ImmediateScheduler {
    public <methods>;
}
-keep class io.reactivex.schedulers.TestScheduler {
    public <methods>;
}
-keep class io.reactivex.schedulers.Schedulers {
    public static ** test();
}
-keepclassmembers class io.reactivex.internal.util.unsafe.*ArrayQueue*Field* {
    long producerIndex;
    long consumerIndex;
}
-keepclassmembers class io.reactivex.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    long producerNode;
    long consumerNode;
}

-keepclassmembers class io.reactivex.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    io.reactivex.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class io.reactivex.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    io.reactivex.internal.util.atomic.LinkedQueueNode consumerNode;
}

-dontwarn io.reactivex.internal.util.unsafe.**


################espresso###############
-keep class android.support.test.espresso.** { *; }
-keep interface android.support.test.espresso.** { *; }


################RxLifeCycle#################
-keep class com.trello.rxlifecycle2.** { *; }
-keep interface com.trello.rxlifecycle2.** { *; }
-dontwarn com.trello.rxlifecycle2.**
-keep class com.github.mikephil.charting.** { *; }
-dontwarn com.github.mikephil.charting.data.realm.**


################RxPermissions#################
-keep class com.tbruyelle.rxpermissions2.** { *; }
-keep interface com.tbruyelle.rxpermissions2.** { *; }


################RxCache#################
-dontwarn io.rx_cache2.internal.**
-keep class io.rx_cache2.internal.Record { *; }
-keep class io.rx_cache2.Source { *; }

-keep class io.victoralbertos.jolyglot.** { *; }
-keep interface io.victoralbertos.jolyglot.** { *; }

################RxErrorHandler#################
-keep class me.jessyan.rxerrorhandler.** { *; }
-keep interface me.jessyan.rxerrorhandler.** { *; }

################Timber#################
-dontwarn org.jetbrains.annotations.**


################Canary#################
-dontwarn com.squareup.haha.guava.**
-dontwarn com.squareup.haha.perflib.**
-dontwarn com.squareup.haha.trove.**
-dontwarn com.squareup.leakcanary.**
-keep class com.squareup.haha.** { *; }
-keep class com.squareup.leakcanary.** { *; }


	
#############################################
#
# 	需要根据项目更改
#
# 	1)保留项目中需要gson转换的数据基类)
# 	  -keep class com.skyzone.netdemomvp.data.** { *; }
#   
#############################################
