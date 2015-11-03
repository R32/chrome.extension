package chrome;

/**
指定哪些类型的来源应该受到影响
 - unprotectedWeb: 包括了用户访问网站、不进行特殊操作的一般情况。如果您没有指定 originTypes，该 API 默认情况下删除来自不受保护的网络来源的数据
 - protectedWeb: 包括了安装为托管应用的网络来源。例如，安装 Angry Birds 后来源 http://chrome.angrybirds.com 将受到保护，并将从 unprotectedWeb 分类中移除。在执行这些来源内的删除操作时请格外小心：确保您的用户知道这样做的结果，因为这可能会彻底删除他们的游戏数据。没有人愿意一次又一次地推倒小猪的屋子。
 - extension: 包括了 chrome-extensions: 协议下的来源。删除扩展程序数据同样是您应该格外小心的事情。
 
特别重要：使用 protectedWeb 与 extension 时必须格外小心，这些是毁灭性的操作，如果没有很好地告知用户您的扩展程序代表他们删除数据的后果，您会收到用户写来的愤怒的邮件。
*/
typedef OriginTypes = {
	@:optional var unprotectedWeb : Bool;
	@:optional var protectedWeb : Bool;
	@:optional var extension : Bool;
}

/**
确定删除哪些数据的选项
 - since: 删除从指定日期开始积累的所有数据，表示为从 1970 年 1 月 1 日午夜开始所经过的毫秒数。如果没有指定，则默认为 0（删除所有内容）。
 - originTypes: 指定哪些来源类型的数据应该被清除。如果没有指定该对象，默认情况下只清除 “unprotected” 来源
*/
typedef RemovalOptions = {
	@:optional var since : Float;
	var originTypes : OriginTypes;
}

/**
数据类型的集合，未指定的数据类型认为是 false
 - appcache: 网站的应用程序缓存
 - cache: 浏览器缓存。注意：删除数据时将清除所有缓存内容，并不仅限于您指定的范围
 - cookies: 浏览器的 Cookie
 - downloads: 浏览器的下载历史记录
 - fileSystems: 网站的文件系统数据
 - formData: 浏览器保存的表单数据
 - history: 浏览器的历史记录
 - indexedDB: 网站的 IndexedDB 数据
 - localStorage: 网站的本地存储数据
 - serverBoundCertificates: 服务器绑定的证书
 - pluginData: 插件数据
 - passwords: 保存的密码
 - webSQL: 网站的 WebSQL 数据
*/
typedef DataTypeSet = {
	@:optional var appcache : Bool;
	@:optional var cache : Bool;
	@:optional var cookies : Bool;
	@:optional var downloads : Bool;
	@:optional var fileSystems : Bool;
	@:optional var formData : Bool;
	@:optional var history : Bool;
	@:optional var indexedDB : Bool;
	@:optional var localStorage : Bool;
	@:optional var serverBoundCertificates : Bool;
	@:optional var pluginData : Bool;
	@:optional var passwords : Bool;
	@:optional var webSQL : Bool;
}

/**
从用户的本地配置文件删除浏览数据

可用版本: Chrome 19+

权限: "browsingData"

---

最简单的用法就是基于时间清理用户浏览数据。您的代码应该提供时间戳，指定应该删除的是在这一历史时刻之后的用户浏览数据。这一时间戳的格式为自 1970 年 1 月 1 日以来所经过的毫秒数（可以通过 JavaScript 中 Date 对象的 getTime 方法获得）

```js      
var millisecondsPerWeek = 1000 * 60 * 60 * 24 * 7;
var oneWeekAgo = (new Date()).getTime() - millisecondsPerWeek;
chrome.browsingData.remove({
	since: oneWeekAgo
	}, {
		appcache: true,
		cache: true,
		cookies: true,
		downloads: true,
		fileSystems: true,
		formData: true,
		history: true,
		indexedDB: true,
		localStorage: true,
		pluginData: true,
		passwords: true,
		webSQL: true
	}, function () {
		// 数据清除后可以在这里进行一些处理。      
	});
```

重要： 清除浏览数据涉及到后台大量的负荷，取决于用户配置文件，可能需要几十秒来完成。您应该使用回调机制通知用户清除状态。
*/
@:require(chrome_ext)
@:native("chrome.browsingData")
extern class BrowsingData {
	/**
	报告“清除浏览数据”用户界面中哪些类型的数据当前以选中。注意：该 API 中包含的某些数据类型不能在设置用户界面中访问，而某些用户界面设置控制这里列出的几种数据类型
	*/
	static function settings( f : {options:RemovalOptions,dataToRemove:DataTypeSet,dataRemovalPermitted:DataTypeSet}->Void ) : Void;
	
	/**
	清除储存在用户配置文件中的各种浏览数据 
	*/
	static function remove( options : RemovalOptions, dataToRemove : DataTypeSet, ?callback : Void->Void ) : Void;
	static function removeAppcache( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeCache( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeCookies( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeDownloads( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeFileSystems( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeFormData( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeHistory( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeIndexedDB( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeLocalStorage( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removePluginData( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removePasswords( options : RemovalOptions, ?callback : Void->Void ) : Void;
	static function removeWebSQL( options : RemovalOptions, ?callback : Void->Void ) : Void;
}
