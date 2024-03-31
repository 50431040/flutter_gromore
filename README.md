# Flutter版穿山甲Gromore广告插件

如使用的1.x版本请参考[文档](https://github.com/50431040/flutter_gromore/blob/main/v1.x_README.md)

## 特点

- 引入了最新的融合SDK（具体新特性请查看官方文档）
- 使用kotlin和swift语言开发
- 提供了较为完整的广告配置和回调事件
- 开屏广告支持配置logo及自定义渲染

## 支持平台

- ✅ 安卓
- ✅ iOS

## 支持功能

- ✅ 开屏广告
- ✅ 插屏广告
- ✅ 信息流广告
- ✅  Banner广告
- ✅ 激励广告

## 2.x版本特性

- 引入融合SDK
- 插件内部移除了某些参数/回调事件
- 接入变得更加简单
- 支持SurfaceView，提升Android广告性能

## 接入文档

### 初始工作

> 具体内容请参考官方SDK接入文档

#### Android

1. 将Gromore SDK【open_ad_sdk_6.0.1.4.arr】拷贝到资源目录(example：android/app/libs)下，添加除穿山甲以外的广告SDK和对应的适配器，下面添加了广点通、百度和快手。

```gradle
dependencies {
    // 广点通 SDK
    implementation (name: 'GDTSDK.unionNormal.4.563.1433', ext: 'aar')
    // 广点通 Adapter
    implementation(name: 'mediation_gdt_adapter_4.563.1433.0', ext: 'aar')
    // 百度SDK
    implementation(name: 'Baidu_MobAds_SDK_v9.34', ext: 'aar')
    // 百度 Adapter
    implementation(name: 'mediation_baidu_adapter_9.34.0', ext: 'aar')
    // 快手SDK
    implementation(name: 'kssdk-ad-3.3.59', ext: 'aar')
    // 快手 Adapter
    implementation(name: 'mediation_ks_adapter_3.3.59.0', ext: 'aar')
}
```

2. AndroidManifest.xml中手动添加对应adn的配置项（具体请参考官方文档）

```xml
<!-- GDT start================== -->
<!-- targetSDKVersion >= 24时才需要添加这个provider。provider的authorities属性的值为${applicationId}.fileprovider，请开发者根据自己的${applicationId}来设置这个值，例如本例中applicationId为"com.qq.e.union.demo"。 -->
<provider
          android:name="com.qq.e.comm.GDTFileProvider"
          android:authorities="${applicationId}.gdt.fileprovider"
          android:exported="false"
          android:grantUriPermissions="true">
  <meta-data
             android:name="android.support.FILE_PROVIDER_PATHS"
             android:resource="@xml/gdt_file_path" />
</provider>

<activity
          android:name="com.qq.e.ads.PortraitADActivity"
          android:configChanges="keyboard|keyboardHidden|orientation|screenSize"
          android:screenOrientation="portrait" />
<activity
          android:name="com.qq.e.ads.LandscapeADActivity"
          android:configChanges="keyboard|keyboardHidden|orientation|screenSize"
          android:screenOrientation="landscape"
          tools:replace="android:screenOrientation" />

<!-- 声明SDK所需要的组件 -->
<service
         android:name="com.qq.e.comm.DownloadService"
         android:exported="false" />
<!-- 请开发者注意字母的大小写，ADActivity，而不是AdActivity -->

<activity
          android:name="com.qq.e.ads.ADActivity"
          android:configChanges="keyboard|keyboardHidden|orientation|screenSize" />
<!-- GDT end================== -->

<!-- baidu start================== -->
<!-- 声明打开落地页的Activity（不建议修改主题配置）-->
<activity
          android:name="com.baidu.mobads.sdk.api.AppActivity"
          android:configChanges="screenSize|keyboard|keyboardHidden|orientation"
          android:theme="@android:style/Theme.NoTitleBar" />
<!-- 声明打开显示激励视频/全屏视频的Activity-->
<activity
          android:name="com.baidu.mobads.sdk.api.MobRewardVideoActivity"
          android:configChanges="screenSize|orientation|keyboardHidden"
          android:launchMode="singleTask"
          android:theme="@android:style/Theme.Translucent.NoTitleBar" />

<!-- 如果targetSdkVersion设置值>=24，则强烈建议添加以下provider，否则会影响app变现 -->
<!-- android:authorities="${packageName}.bd.provider" authorities中${packageName}部分必须替换成app自己的包名 -->
<!-- 原来的FileProvider在新版本中改为BdFileProvider,继承自v4的FileProvider,需要在应用内引用support-v4包 -->
<provider
          android:name="com.baidu.mobads.sdk.api.BdFileProvider"
          android:authorities="${applicationId}.bd.provider"
          android:exported="false"
          android:grantUriPermissions="true">
  <meta-data
             android:name="android.support.FILE_PROVIDER_PATHS"
             android:resource="@xml/bd_file_paths" />
</provider>
<!-- baidu end================== -->

```

3. **代码混淆及资源混淆配置，请务必配置！！！**（参考官方文档）

#### iOS

1. 引入**除穿山甲以外**的SDK和适配器，案例中使用 CocoaPods 引入百度和广点通，可见 `example/ios/Podfile` 。引入时需要注意 Adapter 所支持的 SDK 版本范围，可在 GroMore 接入文档查看。
2. 在XCode中添加依赖库【  TARGETS -> Build Phases 中添加...】
3. 建议允许 `http` 访问，`info.plist` 添加：

   ```plist
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
   ```

### 授权

1. 请求非必要权限（仅Android）

**方法已废弃，开发者请自行申请相关权限**

```dart
FlutterGromore.requestPermissionIfNecessary(); // 已废弃
```

修改AndroidManifest配置（注：插件内部已经添加了必要权限，如下所示，可选权限参考官方文档）

```xml
<!-- 必要权限 -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />

<!-- 可选权限 -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<!--suppress DeprecatedClassUsageInspection -->
<uses-permission android:name="android.permission.GET_TASKS" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />

<!--可选权限，申请后用于防作弊功能以及有助于广告平台投放广告-->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<permission
            android:name="${applicationId}.openadsdk.permission.TT_PANGOLIN"
            android:protectionLevel="signature" />
<uses-permission android:name="${applicationId}.openadsdk.permission.TT_PANGOLIN" />

<!--建议添加“query_all_package”权限，穿山甲将通过此权限在Android R系统上判定广告对应的应用是否在用户的app上安装，避免投放错误的广告，以此提高用户的广告体验。若添加此权限，需要在您的用户隐私文档中声明！ -->
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />


<!--可选权限，视情况添加，参考官方文档-->
```

2. ATT授权（仅iOS）

从iOS 14开始，只有在获得用户明确许可的前提下，应用才可以访问用户的IDFA数据并向用户投放定向广告。在应用程序调用 App Tracking Transparency 框架向最终用户提出应用程序跟踪授权请求之前，IDFA将不可用。如果某个应用未提出此请求，则读取到的IDFA将返回全为0的字符串，这个可能会导致广告收入降低。

```dart
FlutterGromore.requestATT();
```

在 info.plist中添加描述

```
<key>NSUserTrackingUsageDescription</key> 
<string>ATT权限使用说明，需要开发者自行设置描述</string>
```

> 可配置 `SKAdNetwork` ，让 iOS 14 以上版本 IDFA 不可用时进行归因，参考 [穿山甲 GroMore iOS14 适配说明](https://www.csjplatform.com/union/media/union/download/detail?id=108&docId=618373011352b00048decd33&osType=ios) 。

### 初始化SDK

新增参数：useMediation 是否使用聚合功能，默认为false

```dart
bool initResult = await FlutterGromore.initSDK(
  appId: "",
  appName: "",
  debug: true,
  useMediation: true);
```

| 参数名              | 说明                                                      | 必选 |
| ------------------- | --------------------------------------------------------- | ---- |
| appId               |                                                           | 是   |
| appName             |                                                           | 是   |
| debug               | debug模式，默认为true                                     | 是   |
| useMediation        | 是否使用聚合                                              | 是   |
| paid                | 是否为计费用户，默认为false。仅作用于Android              | 否   |
| allowShowNotify     | 是否允许SDK弹出通知，默认为false。仅作用于Android         | 否   |
| useTextureView      | 是否使用TextureView播放视频，默认为false。仅作用于Android | 否   |
| supportMultiProcess | 是否支持多进程，默认为false。仅作用于Android              | 否   |
| themeStatus         | 主题模式设置，0是正常模式；1是夜间模式。默认为正常模式    | 否   |

若需要添加本地缓存配置，请将文件`gromore_local_config`放在`android/src/main/assets/`目录下，初始化时会尝试加载该文件配置

### 开屏广告

1. 说明

- 开屏广告提供了两种方式：第一种是自渲染（仅Android端可用，不建议使用，**后续将不进行维护**），第二种是拉起原生Activity
- 自渲染方式以Widget的方式提供
- 原生页面方式支持传入logo，渲染时logo会在底部显示（logo值不需要文件后缀）
- 经线上反馈，部分场景下会导致开屏广告的activity无法关闭。所以增加了延时器自动关闭，事件为 onAutoClose 和 onAutoSkip

2. 使用

```dart
// 拉起开屏页（会等待广告关闭或广告渲染失败）
await FlutterGromore.showSplashAd(
  config: GromoreSplashConfig(
    adUnitId: GoMoreAdConfig.splashId, logo: "launch_image"),
  callback: GromoreSplashCallback(onAdShow: () {
    print("callback --- onAdShow");
}));

// 自渲染（由于iOS端SDK未提供相关支持，因此仅适用于安卓，后续将不进行维护）
child: GromoreSplashView(
  creationParams: GromoreSplashConfig(
    adUnitId: GoMoreAdConfig.splashId, height: height - 80),
  callback: GromoreSplashCallback(
    onAdEnd: () {
      Navigator.pop(context);
    }
),),
```

3. 参数（GromoreSplashConfig）

| 参数名            | 说明                                                         | 必选 |
| ----------------- | ------------------------------------------------------------ | ---- |
| adUnitId          | 聚合开屏广告位id                                             | 是   |
| ~~width~~         | 广告宽度（自定义渲染可用）                                   | 否   |
| ~~height~~        | 广告高度（自定义渲染可用）                                   | 否   |
| logo              | 如果传入了logo则会在底部显示logo，Android放在android/app/src/main/res/mipmap下，iOS放在Assets中，值不需要文件后缀（非自定义渲染可用）。不传则全屏显示。 | 否   |
| muted             | 静音，默认为true                                             | 否   |
| preload           | 预加载，默认为true。仅Android可用                            | 否   |
| volume            | 声音配置，与muted配合使用，默认为1。仅Android可用            | 否   |
| ~~buttonType~~    | 按钮样式（1：全屏可点击，2：仅按钮可点击，默认为1）          | 否   |
| ~~downloadType~~  | 点击下载样式（0或者1，默认为1）                              | 否   |
| splashShakeButton | 开屏摇一摇开关，默认为true。仅Android可用                    | 否   |
| bidNotify         | bidding类型广告，竞价成功或者失败后是否通知对应的adn，默认为false | 否   |
| timeout           | 超时时间，默认为3500，单位：毫秒                             | 否   |
| useSurfaceView    | 是否使用SurfaceView，默认为true。建议开启，仅对Android生效   | 否   |

4. 回调（GromoreSplashCallback）

| 回调方法名            | 说明                                                         |
| --------------------- | ------------------------------------------------------------ |
| onAdClicked           | 点击                                                         |
| onAdShow              | 展示成功                                                     |
| onSplashAdLoadFail    | 加载失败                                                     |
| onSplashAdLoadSuccess | 加载成功                                                     |
| onSplashRenderSuccess | 渲染成功。貌似iOS不会触发回调                                |
| onSplashRenderFail    | 渲染失败。貌似iOS不会触发回调                                |
| onSplashAdClose       | 关闭                                                         |
| **onAdEnd**           | **开屏广告结束，这个时候会销毁广告（点击跳过、倒计时结束或渲染错误等 理应隐藏广告 的情况都会触发此回调，建议统一在此回调处理路由跳转等逻辑）** |
| onAutoClose           | 开屏广告自动关闭，超过6s未触发onAdShow回调时会执行（由于存在异常场景，导致广告无法正常展示，但无相关回调） |
| onAutoSkip            | 开屏广告自动跳过，onAdShow回调触发后6s内未关闭广告时会执行（由于存在部分场景，导致广告无法跳过） |

### 插全屏广告

1. 说明

- 该广告类型支持插屏、全屏混出（穿山甲插屏/全屏代码位已无法新建，都使用GroMore【插全屏】广告位代替）
- 先加载广告id，成功后再渲染展示
- 某些1.x版本的参数/回调已经废弃

2. 使用

```dart
// 加载全屏广告
interstitialId = await FlutterGromore.loadInterstitialAd(
    GromoreInterstitialConfig(
        adUnitId: GroMoreAdConfig.interstitialId,
        size: GromoreAdSize.withPercent(
            MediaQuery.of(context).size.width * 2 / 3, 2 / 3)));
if (interstitialId.isEmpty) {
    print("加载全屏广告失败");
}

// 合适的时机展示插屏广告
if (interstitialId.isNotEmpty) {
    await FlutterGromore.showInterstitialAd(
        interstitialId: interstitialId,
        callback: GromoreInterstitialCallback(onInterstitialShow: () {
            print("===== showInterstitialAd success ======");
        }, onInterstitialClosed: () {
            FlutterGromore.removeInterstitialAd(interstitialId);
            interstitialId = "";
            loadInterstitialAd();
        }));
}
```

3. 配置（GromoreInterstitialConfig）

| 参数名         | 说明                                                       | 必填 |
| -------------- | ---------------------------------------------------------- | ---- |
| adUnitId       | 插屏广告位id                                               | 是   |
| orientation    | 设置横竖，仅Android可用。竖屏为1，横屏为2。默认竖屏        | 否   |
| muted          | 是否静音，默认为true                                       | 否   |
| useSurfaceView | 是否使用SurfaceView，默认为true。建议开启，仅对Android生效 | 否   |

4. 回调（GromoreSplashCallback，命名和 **Android** 聚合文档基本一致）

| 回调方法名             | 说明       | 备注      |
| ---------------------- | ---------- | --------- |
| onInterstitialShow     | 广告展示   |           |
| onInterstitialShowFail | 展示失败   | 仅iOS可用 |
| onInterstitialAdClick  | 广告被点击 |           |
| onInterstitialClosed   | 广告关闭   |           |

### 信息流广告

1. 说明

- 先加载广告id，成功后再渲染展示
- 渲染成功回调中(onRenderSuccess)提供了一个参数，表示渲染后的广告高度，可以用来动态控制组件显示与否
- 广告加载成功后会存放在内存当中，当广告不再展示时（用户主动关闭、某种条件触发关闭等场景）开发者不需要手动移除缓存中的广告，因为插件内部在销毁时会进行处理。（当然也提供了`removeCacheFeedAd`方法来手动移除）
- 具体使用参考example

2. 使用

```dart

// 加载信息流广告
List<String> idList = await FlutterGromore.loadFeedAd(GromoreFeedConfig(adUnitId: GroMoreAdConfig.feedId));
if (idList.isNotEmpty) {
    String id = idList.removeLast();
    feedAdIdList.addAll(idList);
    return id;
} else {
    // 加载信息流广告失败
}

// 展示信息流广告
GromoreFeedView(
  creationParams: {
      "feedId": _feedAdId!
  },
  callback: GromoreFeedCallback(
    onRenderSuccess: (double height) {
      print("GromoreFeedView | onRenderSuccess | $height");
      setState(() {
        _height = height;
      });
    },
    onSelected: () {
      setState(() {
        _show = false;
      });
    },
    onAdTerminate: () {
      setState(() {
        _show = false;
      });
    }
))
```

3. 配置（GromoreFeedConfig）

| 参数名         | 说明                                                       | 必填 |
| -------------- | ---------------------------------------------------------- | ---- |
| adUnitId       | 信息流广告位id                                             | 是   |
| count          | 请求数量，默认为3                                          | 否   |
| width          | 宽度，默认宽度占满。double类型                             | 否   |
| height         | 高度，默认150。double类型                                  | 是   |
| useSurfaceView | 是否使用SurfaceView，默认为true。建议开启，仅对Android生效 | 否   |

4. 回调（GromoreFeedCallback，命名和 **Android** 聚合文档基本一致）

| 回调方法名      | 说明                   | 备注                                         |
| --------------- | ---------------------- | -------------------------------------------- |
| onAdClick       | 信息流广告点击         |                                              |
| onAdShow        | 信息流广告在视图中展示 |                                              |
| onRenderFail    | 模板渲染失败           |                                              |
| onRenderSuccess | 模板渲染成功           | 此回调有一个参数：height，表示广告渲染后高度 |
| onSelected      | 用户选择不喜欢原因     |                                              |
| onCancel        | 取消选择不喜欢原因     | 仅Android可用                                |
| ~~onRefuse~~    | 拒绝填写原因           | 仅Android可用                                |
| onShow          | 拒绝弹框显示           | 仅Android可用                                |
| onAdTerminate   | 广告被强制移除         | 仅iOS可用，当收到此回调时应当移除该组件      |

### 激励视频

1. 说明

- 先加载广告id，成功后再渲染展示
- 没有服务端奖励验证功能

2. 使用

```dart
String rewardAdId = await FlutterGromore.loadRewardAd(
  GromoreRewardConfig(adUnitId: GroMoreAdConfig.rewardId));

if (rewardAdId.isNotEmpty) {
  showRewardAd(rewardAdId);
}

Future<void> showRewardAd(String rewardId) async {
  await FlutterGromore.showRewardAd(rewardId: rewardId, callback: GromoreRewardCallback(
    onRewardVerify: (bool verify) {
      if (verify) {
        // 如果需要在关闭广告后再判断，可以先把这个值用变量存储一下，在onAdClose回调中根据变量的值进行判断
        print("恭喜你，获得奖励");
      }
    }
  ));
}
```

3. 配置（GromoreRewardConfig）

| 参数名         | 说明                                                       | 必填 |
| -------------- | ---------------------------------------------------------- | ---- |
| adUnitId       | 信息流广告位id                                             | 是   |
| orientation    | 播放方向。竖屏：1，横屏：2。默认为竖屏。仅Android端有效    | 否   |
| muted          | 是否静音，默认为true                                       | 否   |
| volume         | 音量，默认为0。仅Android端有效                             | 否   |
| useSurfaceView | 是否使用SurfaceView，默认为true。建议开启，仅对Android生效 | 否   |

4. 回调（GromoreFeedCallback，命名和 **Android** 聚合文档基本一致）

| 回调方法名        | 说明                                              | 备注                         |
| ----------------- | ------------------------------------------------- | ---------------------------- |
| onAdShow          | 广告的展示回调                                    |                              |
| onAdVideoBarClick | 广告的下载bar点击回调，非所有广告商的广告都会触发 |                              |
| onAdClose         | 广告关闭的回调                                    |                              |
| onVideoComplete   | 视频播放完毕的回调，非所有广告商的广告都会触发    |                              |
| onVideoError      | 视频播放失败的回调                                |                              |
| onRewardVerify    | 激励视频播放完毕，验证是否有效发放奖励的回调      | 参数 verify 表示是否验证成功 |
| onSkippedVideo    | 跳过视频播放                                      |                              |

### Banner广告

1. 说明

- 不需要加载广告id
- 高度为申请广告位时选择的高度
- 具体使用参考example

2. 使用

```dart
SizedBox(
  height: _height,
  child: GromoreBannerView(
    creationParams: {"adUnitId": GroMoreAdConfig.bannerId, "height": _bannerHeight.toString()},
    callback: GromoreBannerCallback(onRenderSuccess: () {
      print("GromoreBannerView | onRenderSuccess");
      setState(() {
        _height = _bannerHeight;
      });
    }, onSelected: () {
      setState(() {
        _show = false;
      });
    }, onLoadError: () {
      setState(() {
        _show = false;
      });
    }, onAdTerminate: () {
      setState(() {
        _show = false;
      });
    })),
)
```

3. 配置（GromoreFeedConfig）

| 参数名         | 说明                                                       | 必填 |
| -------------- | ---------------------------------------------------------- | ---- |
| adUnitId       | 信息流广告位id                                             | 是   |
| width          | 宽度，默认宽度占满。Int类型                                | 否   |
| height         | 高度，默认为150。Int类型                                   | 否   |
| useSurfaceView | 是否使用SurfaceView，默认为true。建议开启，仅对Android生效 | 否   |

4. 回调（GromoreBannerCallback，命名和 **Android** 聚合文档基本一致）

| 回调方法名      | 说明                          | 备注      |
| --------------- | ----------------------------- | --------- |
| onAdClick       | banner广告点击                |           |
| onAdShow        | banner广告展示，仅Android可用 |           |
| onRenderFail    | 模板渲染失败                  |           |
| onRenderSuccess | 模板渲染成功                  |           |
| onSelected      | 用户选择不喜欢原因            |           |
| onAdTerminate   | 进程被终止                    | 仅iOS可用 |
| onLoadError     | 广告加载失败                  |           |

## 问题

1. iOS端的开屏广告只能使用`FlutterGromore.showSplashAd`进行，如果在此时同时加载插屏广告，可能会导致插屏广告出现在开屏广告上方

使用`await`保证`FlutterGromore.showSplashAd`方法结束后再调用插屏广告的展示方法。

2. 穿山甲信息流广告使用 `WebView` 实现，在 iOS 上存在触摸穿透的问题。插件中对穿山甲广告做了触摸事件拦截，可见 [FlutterGromoreIntercptPenetrateView.swift](https://github.com/50431040/flutter_gromore/blob/main/ios/Classes/view/FlutterGromoreIntercptPenetrateView.swift) ，有任何问题请提 [issue](https://github.com/50431040/flutter_gromore/issues)。

   > Flutter 社区有相关讨论：[flutter#58659](https://github.com/flutter/flutter/issues/58659) 、[flutter#89956](https://github.com/flutter/flutter/issues/89956) 、[flutter#35784-comment](https://github.com/flutter/flutter/issues/35784#issuecomment-516243057) 等

3. iOS 信息流广告卡顿掉帧问题。穿山甲广告 `WebView` 在每次滑入可视区域时都会申请展示广告，在列表滚动时有卡顿，已尝试优化；掉帧问题可跟踪社区：[flutter#107486](https://github.com/flutter/flutter/issues/107486) 、[flutter#103014-comment](https://github.com/flutter/flutter/issues/103014#issuecomment-1118341729)、[flutter#101776](https://github.com/flutter/flutter/issues/101776) 。

4. 升级到2.x版本需要做些什么？

- 移除之前手动导入的SDK，改为pod/maven方式引入，并且无需引入穿山甲广告的SDK和适配器
- 如果使用过已废弃的参数和回调则需要移除，一般不需要
- 如需要使用聚合功能请在`initSDK`方法中传入`useMediation`参数

其他问题请提[issue](https://github.com/50431040/flutter_gromore/issues)

## 加好友进群

![qrcode.jpg](./screenshots/qrcode.jpg)

## 团队

> 牛小二招聘前端

牛小二招聘是一款致力为国内物流蓝领提供靠谱的求职招聘服务平台，全网累计拥有数百万会员用户，每日实时更新司机、押运员、搬卸工、快递员招工及牛人信息，司机招聘与技术牛人涵盖挂车、叉车司机、客车司机、铲车司机、罐车司机、拖车司机及货运车司机等，求职者和雇主可挑选匹配沟通，提高人岗匹配率，降低沟通成本

### 招聘

正在持续招聘2年经验以上的前端工程师，base成都，感兴趣的话请把简历发送到邮箱：jianglinqi@niuxiaoer.net，备注下github。我们主要是做蓝领行业的招聘，产品包括牛小二招聘APP、牛小二招聘小程序等，总用户数超千万，DAU几十万~
