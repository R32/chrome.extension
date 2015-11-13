package chrome;


import chrome.Events;

/**
app 或 theme 的图标的有关信息 
*/
typedef IconInfo = {
	/**
	代表图标宽度和高度的一个整数，可能的值包括（但不限于）128、48、24 和 16。
	*/
	var size : Int;
	
	/**
	该图标图像的 URL。要显示一个灰度版本的图标（例如表示应用已禁用），请在 URL 后附加 ?grayscale=true 
	*/
	var url : String;
}

@:enum abstract LaunchType(String) from String to String {
	var OPEN_AS_REGULAR_TAB = "OPEN_AS_REGULAR_TAB";
	var OPEN_AS_PINNED_TAB = "OPEN_AS_PINNED_TAB";
	var OPEN_AS_WINDOW = "OPEN_AS_WINDOW";
	var OPEN_FULL_SCREEN = "OPEN_FULL_SCREEN";
}

/**
应用被禁的原因枚举 
*/
@:enum abstract ExtensionDisabledReason(String) from String to String {
	var unknown = "unknown";
	var permissions_increase = "permissions_increase";
}

/**
应用所属类型

 - extension 扩展
 - hosted_app 以 http 的形式加载网络上的 app
 - packaged_app 打包的 app
 - legacy_packaged_app 旧的
 - theme 主题
*/
@:enum abstract ExtensionType(String) from String to String {
	var extension = "extension";
	var hosted_app = "hosted_app";
	var packaged_app = "packaged_app";
	var legacy_packaged_app = "legacy_packaged_app";
	var theme = "theme";
}

/**
应用是如何安装的:

 - admin: 表示应用由于管理策略而安装
 - development: 在开发者模式下加载
 - normal 由 .crx文件正常安装
 - sideload 由计算机上的其他软件安装
 - other: 其他方式安装
*/
@:enum abstract ExtensionInstallType(String) from String to String {
	var admin = "admin";
	var development = "development";
	var normal = "normal";
	var sideload = "sideload";
	var other = "other";
}

/**
app、extension 或 theme 的有关信息。 大多数都与 manifest.json 相对应  
*/
typedef ExtensionInfo = {
	/**
	唯一标识符 
	*/
	var id : String;

	var name : String;
	
	/**
	短名, 对应于 manifest 文件的 short_name属性 
	*/
	var shortName : String;
	
	var description : String;
	
	var version : String;
	
	/**
	用户是否能禁用或卸载该应用。 
	*/
	var mayDisable : Bool;
	
	/**
	该应用当前是否已启用 
	*/
	var enabled : Bool;
	
	/**
	被禁用的原因 
	*/
	@:optional var disabledReason : ExtensionDisabledReason;
	
	var isApp : Bool;
	
	var type : ExtensionType;
	
	@:optional var appLaunchUrl : String;
	
	/**
	对应 manifest 文件的 homepage_url 属性
	*/
	@:optional var homepageUrl : String;
	
	@:optional var updateUrl : String;
	
	/**
	是否具有离线支持 
	*/
	var offlineEnabled : Bool;
	
	/**
	选项页url, 对应 manifest 文件的 options_page 属性,但是以 chrome-extension:// 的协议
	*/
	var optionsUrl : String;
	
	@:optional var icons : Array<IconInfo>;
	
	var permissions : Array<String>;
	
	var hostPermissions : Array<String>;
	
	/**
	应用是如何安装的 
	*/
	var installType : ExtensionInstallType;
	
	@:optional var launchType : LaunchType;
	
	@:optional var availableLaunchTypes : Array<LaunchType>;
}

/**
用来管理已经安装并且正在运行的应用或应用

可用版本: chrome 8+

权限: "management", 但 getPermissionWarningsByManifest 和 uninstallSelf 不需要权限.
*/
@:require(chrome_ext)
@:native("chrome.management")
extern class Management {
	/**
	返回已安装所有应用信息。
	*/
	static function getAll( ?callback : Array<ExtensionInfo>->Void ) : Void;
	
	/**
	返回指定 id(应用标识符 chrome.runtime.id) 的应用信息 
	*/
	static function get( id : String, ?callback : ExtensionInfo->Void ) : Void;
	
	/**
	返回指定应用标识符所对应的[权限警告](http://chajian.baidu.com/developer/extensions/permission_warnings.html)列表。
	*/
	static function getPermissionWarningsById( id : String, ?callback : Array<String>->Void ) : Void;
	
	/**
	返回指定 manifest.json 文件对应的权限警告列表。注意，这一函数不需要在清单文件中请求 "management"（管理）权限就可以使用 
	*/
	static function getPermissionWarningsByManifest( manifestStr : String, ?callback : Array<String>->Void ) : Void;
	
	/**
	启用或禁用一个应用. 
	*/
	static function setEnabled( id : String, enabled : Bool, ?callback : Void->Void ) : Void;
	
	/**
	卸载当前已安装的应用。根据指定的 id, 

	showConfirmDialog 是否显示确认卸载对话框提示用户，如果是卸载自己则默认为 false，如果应用卸载其他应用，则忽略该参数，始终显示对话框
	*/
	static function uninstall( id : String, ?options : { ?showConfirmDialog : Bool }, ?callback : Void->Void ) : Void;
	
	/**
	卸载自已, 注意，这一函数不需要在清单文件中请求 "management" 权限就可以使用.
	*/
	static function uninstallSelf( ?options : { ?showConfirmDialog : Bool }, ?callback : Void->Void ) : Void;
	
	/**
	运行一个应用(仅限于App)。
	*/
	static function launchApp( id : String, ?callback : Void->Void ) : Void;
	
	static function createAppShortcut( id : String, ?callback : Void->Void ) : Void;
	static function setLaunchType( id : String, launchType : LaunchType, ?callback : Void->Void ) : Void;
	static function generateAppForLink( url : String, title : String, ?callback : ExtensionInfo->Void ) : Void;
	
	/**
	安装应用或扩展程序时产生。 
	*/
	static var onInstalled(default, never) : Event<ExtensionInfo->Void>;
	
	/**
	应用或扩展程序卸载时产生。 
	*/
	static var onUninstalled(default, never) : Event<String->Void>;
	
	/**
	应用或扩展程序启用时产生。 
	*/
	static var onEnabled(default,never) : Event<ExtensionInfo->Void>;
	
	/**
	应用或扩展程序禁用时产生。 
	*/
	static var onDisabled(default,never) : Event<ExtensionInfo->Void>;
}
