
# Haxe Chrome Extension [![Build Status](https://travis-ci.org/tong/chrome.extension.svg?branch=master)](https://travis-ci.org/tong/chrome.extension)

Haxe/Javascript type definitions for [google chrome extensions](https://developer.chrome.com/extensions/api_index).

API version: 46

---

To install from haxelib run:
```
$ haxelib install chrome-extension
```

For packaged apps types see: https://github.com/tong/chrome.app  

---

### Haxe Defines

* `-D chrome`  Required (added automatically when using from haxelib)
* `-D chrome_ext`  Required (added automatically when using from haxelib)
* `-D chrome_os`  To access apis available on chrome-os only.
* `-D chrome_dev`  To access apis available on the dev channel only.
* `-D chrome_experimental`  To access experimental apis.

---

### zh_CN Progress

如果可以翻qiang,推荐这个中文 API链接: https://crxdoc-zh.appspot.com/
	
[crxdoc 镜像](http://api.gjcq176.com/chromeplugin/api%20zh/extensions/api_index.html)

备用中文API http://chajian.baidu.com/developer/extensions/api_index.html

 * devtools 在扩展的manifest中指定 `devtools_page: "devtools.html"` 项

  - [ ] inspectedWindow

  - [ ] network

  - [ ] panels

 * enterprise

  - [ ] deviceAttributes

  - [ ] platformKeys

 * input

  - [ ] ime (为 Chrome OS 实现自定义的输入法，它允许您的扩展程序处理键盘输入、设置候选内容及管理候选窗口)

 * networking

  - [ ] config (only on Chrome OS)

 * system

  - [x] cpu 查询 cpu 相关信息.

  - [x] memory 获取物理内存信息

  - [x] storage 查询存储设备信息，并在连接或移除可移动存储设备时得到通知

 - [ ] accessibilityFeatures (管理 Chrome 浏览器的辅助功能)

 - [x] alarms 定时器

 - [x] bookmarks 创建、组织以及通过其他方式操纵书签。您也可以参见替代页面，通过它您可以创建一个自定义的书签管理器页面

 - [x] browserAction 主要用于动态设置 badge,icon,title,popup_url

 - [x] browsingData 从用户的本地配置文件删除浏览数据

 - [ ] certificateProvider

 - [x] commands	绑定各种组合快捷键

 - [x] contentSetting (更改设置，控制网站能否使用 Cookie、JavaScript 和插件之类的特性。大体上说，内容设置允许您针对不同的站点（而不是全局地）自定义 Chrome 浏览器的行为)

 - [x] contextMenus 右键菜单,

 - [x] cookies 需要在 manifest 中限定网址

 - [ ] debugger (可以附加到一个或多个标签页，以便查看网络交互、调试 JavaScript、改变 DOM 和 CSS 等等。使用调试对象的标签页标识符来指定 sendCommand 的目标标签页，并在 onEvent 的回调函数中通过标签页标识符分发事件)
 
 - [x] declerativeContent 用于在何时显示 pageAction 按钮,或更改其图标

 - [ ] desktopCapture (用于捕获屏幕、单个窗口或标签页的内容)

 - [ ] documentScan

 - [x] downloads 以编程方式开始下载，监视、操纵、搜索下载的文件

 - [x] extension 扩展的一些帮助方法

 - [ ] fileBrowserHandler (扩展 Chrome OS 的文件浏览器。例如，您可以使用这一 API 让用户向您的网站上传文件)

 - [ ] fileSystemProvider

 - [ ] fontSettings (管理 Chrome 浏览器的字体设置)

 - [ ] gcm (通过 Google Cloud Messaging 在应用和扩展程序中发送和接收消息)

 - [ ] history (与浏览器的历史记录交互，您可以添加、删除、通过 URL 查询浏览器的历史记录。如果您想要使用您自己的版本替换默认的历史记录页面，请参见替代页面)

 - [x] i18n 国际化

 - [ ] identity (chrome_dev: 获取 OAuth2 访问令牌)

 - [x] idle 检测计算机的状态"锁定, 空闲(一定时间内无人机交互), 活动",

 - [ ] instanceID

 - [ ] location (chrome_dev: 获取计算机的地理位置。该 API 是 HTML 地理定位 API 的另一种版本，与事件页面兼容)

 - [x] management (部分)用来管理已经安装并且正在运行的应用或应用

	> TODOS: 文档说可以在 URL 之后加 `?grayscale=true` 把图标变成灰色, 但是根本不起作用.

 - [x] notifications 托盘(右下角)通知(部分)

 - [ ] omnibox (多功能框 API 允许您在 Google Chrome 浏览器的地址栏（又叫多功能框）中注册一个关键字)

 - [x] pageAction 页面按钮(浏览器地址栏最右)

 - [x] pageCapture 将标签页保存为 MHTML

 - [x] permissions 运行时请求(用户交互)清单文件声明的可选权限.

 - [ ] platformKeys

 - [x] power 修改系统的电源管理特性

 - [ ] printerProvider

 - [ ] privacy (控制 Chrome 浏览器中可能会影响用户隐私的特性)

 - [x] proxy 浏览器代理设置

 - [x] runtime 运行时的一些方法(相对原(origin)项目一些方法改动很大)

 - [x] sessions 查询和恢复浏览器会话中的标签页和窗口(似乎没什么作用)

 - [ ] signedInDevices (获取以当前配置文件所对应的账户登录的设备列表)

 - [x] storage 异步离线存储

 - [ ] tabCapture (与标签页的媒体流交互)

 - [x] tabs 浏览器"标签页"交互

 - [ ] topSites (访问“打开新的标签页”页面中的显示的“常去网站”)

 - [x] tts 文本语音

 - [ ] ttsEngine (程序实现TTS)

 - [x] types 一些类型声明, 其实也没什么内容, chrome.types.chromeSetting

 - [ ] vpnProvider

 - [ ] wallpaper

 - [ ] webNavigation 实时地接收有关导航请求状态的通知

 - [x] webRequest 监控与分析流量，还可以实时地拦截、阻止或修改请求(部分,方法的回调函数返回值,及 addListener 的参数, 需要更改).

	> **BETA(未添加到库)** , 使用 `chrome.declarativeWebRequest` 实时地拦截、阻止或者修改请求，它比 chrome.webRequest 要快得多，因为您注册的规则在浏览器而不是 JavaScript 引擎中求值，这样就减少了来回延迟并且可以获得极高的效率。

 - [x] webstore 在您的网站上“内嵌”安装应用与扩展程序。

 - [x] windows 与浏览器窗口交互。您可以使用该模块创建、修改和重新排列浏览器中的窗口
