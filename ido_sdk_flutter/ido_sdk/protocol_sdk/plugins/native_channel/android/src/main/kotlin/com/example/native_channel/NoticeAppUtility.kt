package com.example.native_channel

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Handler
import android.os.Looper
import com.example.native_channel.models.NotificationGroup
import com.example.native_channel.models.TranferIconModel
import java.io.File
import java.io.FileOutputStream
import java.util.*

interface LoadAppListener {

    fun loadFinish();

}

object NoticeAppUtility {

    /**
     * 类型对应包名，(type, pkg)
     */
    @JvmField
    var allNoticeAppTypeBeans = LinkedHashMap<Int, String>()

    /**
     * 预置给设备的应用清单
     */
    private var mAllPresetApps: MutableList<String> = mutableListOf()

    /**
     * 组合包名列表
     */
    private val composeApps: MutableList<String> = ArrayList()

    /**
     * 不包含组合应用的应用集合
     */
    private val allNoticeAppBeansWithoutCompose = LinkedHashMap<String, TranferIconModel>()

    /**
     * 获取所有安装的APP信息
     */
    fun getInstalledAppList() = allNoticeAppBeansWithoutCompose.values

    private var mLoadAppListener: LoadAppListener? = null

    var loadFinish: Boolean = false

    fun setLoadAppListener(loadAppListener: LoadAppListener?) {
        mLoadAppListener = loadAppListener
    }

    private fun convertPackageToNumber(packageName: String): Int {
//        val hash = packageName.hashCode()
        /// 修复hash值重复问题
        val h: Int = packageName.hashCode()
        val hash = h xor (h ushr 16)
        return (16384 - 1) and hash
       // return java.lang.Math.abs(newHash % 20001) // 取绝对值并限制在 0 到 20000 之间
    }

    /**
     * 生成app唯一整型类型值
     *
     * @param pkg
     * @return
     */
    private fun convertPkg2Type(pkg: String): Int {
        var value = 0
        value = convertPackageToNumber(pkg)
        allNoticeAppTypeBeans[value] = pkg
        return value
    }

    /**
     * type转包名
     */
    @JvmStatic
    fun convertType2Pkg(type: Int): String? {
        return allNoticeAppTypeBeans[type]
    }

    /**
     * type转包名
     */
    @JvmStatic
    fun getTypeByPkg(pkg: String): Int {
        allNoticeAppTypeBeans.forEach {
            if (it.value == pkg) {
                return it.key
            }
        }
        return -1
    }

    @JvmStatic
    fun init(context: Context) {
        loadFinish = false
        loadInstallApp(context)
    }

    @JvmStatic
    fun getDefaultApp(): LinkedHashMap<String, TranferIconModel> {
        val allNoticeAppBeans = LinkedHashMap<String, TranferIconModel>()
        for (pkg in mAllPresetApps) {
            val bean = TranferIconModel()
            bean.group = NotificationGroup.DEFAULT
            when (pkg) {
                AppPackageNameConstant.email -> {
                    bean.appName = "Emails"
                }
                AppPackageNameConstant.missCall-> {
                    bean.appName = "Missed calls"
                }
                AppPackageNameConstant.calendar-> {
                    bean.appName = "Calendar"
                }
                AppPackageNameConstant.sms -> {
                    bean.appName = "SMS"
                }else -> {
                    bean.group = NotificationGroup.BASIC
                    bean.mIsInstalled = false//假设未安装，已安装的会在下方过滤掉
                }
            }
            val appInfo = allNoticeAppBeansWithoutCompose[pkg]
            bean.appName = appInfo?.appName ?: ""
            bean.mIconFilePath = appInfo?.mIconFilePath ?: ""
            bean.pkgName = pkg
            bean.type = convertPkg2Type(bean.pkgName)
            //去重
            if (!allNoticeAppBeans.containsKey(bean.pkgName)) {
                 allNoticeAppBeans[bean.pkgName] = bean
            }
        }
        return allNoticeAppBeans
    }

    /**
     * 获取已安装非系统应用
     */
    private fun loadInstallApp(context: Context) {
        Thread {
            synchronized(this::class.java) {
                allNoticeAppTypeBeans.clear()
                val listAppcations =
                    context.packageManager.getInstalledApplications(0)
                Collections.sort(
                    listAppcations,
                    ApplicationInfo.DisplayNameComparator(context.packageManager)
                ) // 字典排序
                var bean: TranferIconModel
                for (app in listAppcations) {
                    if (   app.flags and ApplicationInfo.FLAG_SYSTEM <= 0
                        || app.flags and ApplicationInfo.FLAG_UPDATED_SYSTEM_APP != 0
                    ) {
                        //非系统程序
                        //本来是系统程序，被用户手动更新后，该系统程序也成为第三方应用程序了
                        bean = getAppInfo(context, app)
                        bean.type = convertPkg2Type(bean.pkgName)
                        bean.group = NotificationGroup.THIRD_PARTY
                        allNoticeAppBeansWithoutCompose[bean.pkgName] = bean
                    }
                }

                //处理4个默认图标
                for (pack in composeApps) {
                    var bean = TranferIconModel()
                    if (AppPackageNameConstant.email == pack) {
                        bean.appName = "Emails"
                    } else if (AppPackageNameConstant.missCall == pack) {
                        bean.appName = "Missed calls"
                    } else if (AppPackageNameConstant.calendar == pack) {
                        bean.appName = "Calendar"
                    } else if (AppPackageNameConstant.sms == pack) {
                        bean.appName = "SMS"
                    }
                    try {
                        val directoryPath = context.filesDir.absolutePath.plus(File.separatorChar).plus("android_icon")
                        val directory = File(directoryPath)
                        if (!directory.exists()) {
                            directory.mkdirs()
                        }
                        val filePath = directoryPath.plus(File.separatorChar).plus(pack).plus(".png")
                        bean.mIconFilePath = filePath
                        val file = File(filePath)
                        if (!file.exists()) { //不存在则拷贝图片
                            val outputStream = FileOutputStream(file)
                            val imageFile = context.assets.open("$pack.png")
                            val bitmap = BitmapFactory.decodeStream(imageFile)
                            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                            outputStream.flush()
                            outputStream.close()
                            bitmap.recycle()
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                    bean.pkgName = pack
                    bean.type = convertPkg2Type(pack)
                    bean.group = NotificationGroup.DEFAULT
                    allNoticeAppBeansWithoutCompose[bean.pkgName] = bean
                }

                Handler(Looper.getMainLooper()).post {
                    allNoticeAppBeansWithoutCompose
                    loadFinish = true
                    mLoadAppListener?.loadFinish()
                }
            }
        }.start()

    }

    /**
     * 构造一个AppInfo对象 ，并赋值
     */
    private fun getAppInfo(context: Context, app: ApplicationInfo): TranferIconModel {
        val appInfo = TranferIconModel()
        try {
            appInfo.appName = context.packageManager.getApplicationLabel(app).toString() //应用名称
        } catch (e: Exception) {
            e.printStackTrace()
        }
        try {
            /// 创建 android_icon 目录存放 APP图标
            val directoryPath = context.filesDir.absolutePath.plus(File.separatorChar).plus("android_icon")
            val directory = File(directoryPath)
            if (!directory.exists()) {
                directory.mkdirs()
            }
            val filePath = directoryPath.plus(File.separatorChar).plus(app.packageName).plus(".png")
            appInfo.mIconFilePath = filePath
            saveDrawable(context,drawable = app.loadIcon(context.packageManager), filePath = appInfo.mIconFilePath)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        appInfo.pkgName = app.packageName //应用包名，用来卸载
        var packageInfo: PackageInfo? = null
        try {
            packageInfo = context.packageManager.getPackageInfo(app.packageName, 0)
            val lastUpdateTime = packageInfo.lastUpdateTime //应用最近一次更新时间
            appInfo.appUpdateTime = lastUpdateTime
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return appInfo
    }

    /**
     * Drawable转文件
     */
    private fun saveDrawable(context: Context,drawable: Drawable, filePath: String) {
        val file = File(filePath)
        if (file.exists() && file.isFile) {
            val lastModified = file.lastModified()
            val date = Date(lastModified)
            val timestamp = date.time/1000
            val currentTimestamp = System.currentTimeMillis()/1000
            if (currentTimestamp - timestamp < 86400) {
                return
            }
            /// 图片每天重新更新
            file.delete()
        }
        file.createNewFile()
        var width = drawable.intrinsicWidth
        if (width > 200) {
            width = 200
        }
        var height = drawable.minimumHeight
        if (height > 200) {
            height = 200
        }
        val bitmap = Bitmap.createBitmap(
            width,
            height,
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bitmap)

        val x = width.toFloat() / drawable.intrinsicWidth.toFloat()
        val y = height.toFloat() / drawable.minimumHeight.toFloat()

        canvas.scale(x,y)
        drawable.setBounds(0,0,drawable.intrinsicWidth,drawable.minimumHeight)
        drawable.draw(canvas)
        val newDrawable = BitmapDrawable(context.resources, bitmap)
        val outputStream = FileOutputStream(file)
        newDrawable.bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        outputStream.flush()
        outputStream.close()
        bitmap.recycle()
    }

    init {
        //组合包名，如多个email应用统一包名
        composeApps.add(AppPackageNameConstant.sms)
        composeApps.add(AppPackageNameConstant.email)
        composeApps.add(AppPackageNameConstant.calendar)
        composeApps.add(AppPackageNameConstant.missCall)
        //默认下发给设备的应用
        mAllPresetApps.add(AppPackageNameConstant.wechat)
        mAllPresetApps.add(AppPackageNameConstant.veryFit)
        mAllPresetApps.add(AppPackageNameConstant.qq)
        mAllPresetApps.add(AppPackageNameConstant.qq2)
        mAllPresetApps.add(AppPackageNameConstant.youtube)
        mAllPresetApps.add(AppPackageNameConstant.facebook)
        mAllPresetApps.add(AppPackageNameConstant.whatsApp)
        mAllPresetApps.add(AppPackageNameConstant.whatsappBusiness)
        mAllPresetApps.add(AppPackageNameConstant.twitter)
        mAllPresetApps.add(AppPackageNameConstant.tumblr)
        mAllPresetApps.add(AppPackageNameConstant.instagram)
        mAllPresetApps.add(AppPackageNameConstant.linkedin)
        mAllPresetApps.add(AppPackageNameConstant.messenger)
        mAllPresetApps.add(AppPackageNameConstant.snapchat)
        mAllPresetApps.add(AppPackageNameConstant.line)
        mAllPresetApps.add(AppPackageNameConstant.line2)
        mAllPresetApps.add(AppPackageNameConstant.vkontakte)
        mAllPresetApps.add(AppPackageNameConstant.viber)
        mAllPresetApps.add(AppPackageNameConstant.skype)
        mAllPresetApps.add(AppPackageNameConstant.skype2)
        mAllPresetApps.add(AppPackageNameConstant.skype3)
        mAllPresetApps.add(AppPackageNameConstant.kakaoTalk)
        mAllPresetApps.add(AppPackageNameConstant.pinterest)
        mAllPresetApps.add(AppPackageNameConstant.telegram)
        mAllPresetApps.add(AppPackageNameConstant.tiktok1)
        mAllPresetApps.add(AppPackageNameConstant.tiktok2)
        mAllPresetApps.add(AppPackageNameConstant.ebay)
        mAllPresetApps.add(AppPackageNameConstant.netflix)
        mAllPresetApps.add(AppPackageNameConstant.amazonShopping)
        mAllPresetApps.add(AppPackageNameConstant.zoom)
        mAllPresetApps.add(AppPackageNameConstant.disneyPlus)
        mAllPresetApps.add(AppPackageNameConstant.shazam)
        mAllPresetApps.add(AppPackageNameConstant.googleMeet)
        mAllPresetApps.add(AppPackageNameConstant.houseParty)
        mAllPresetApps.add(AppPackageNameConstant.mxTakatak)
        mAllPresetApps.add(AppPackageNameConstant.moj)
        mAllPresetApps.add(AppPackageNameConstant.discord)
        mAllPresetApps.addAll(composeApps)
    }

}

