package chrome;

import chrome.Events;
import chrome.Tabs;
import haxe.Constraints.Function;

/**
有关发送消息或请求的脚本上下文信息的对象. chrome 26+
*/
typedef MessageSender = {
	/**
	打开连接的 tabs.Tab（标签页），如果有的话。只有当连接从标签页或内容脚本中打开，并且接收方是应用而不是应用时才会存在这一属性。 
	*/
	@:optional var tab : Tab;
	@:optional var frameId : Int;
	
	/**
	打开连接的应用或应用的标识符（如果有的话） 
	*/
	@:optional var id : String;
	
	/**
	chrome 28+, 打开连接的页面或框架 URL（如果有的话），只有当连接从标签页或内容脚本打开时才会存在这一属性 
	*/
	@:optional var url : String;
	
	/**
	chrome 32+, 如果应用请求该属性并且可用，则为打开连接的网页的 TLS 通道标识符。 
	*/
	@:optional var tlsChannelId : String;
}

/**
端口, 允许与其他页面双向通信的对象. chrome 26+
*/
typedef Port = {
	/**
	connect 所传递的名字标识 
	*/
	var name : String;
	var disconnect : Void->Void;
	var onDisconnect : Event<Port->Void>;
	var onMessage : Event<Dynamic->Port->Void>;
	var postMessage : Dynamic->Void;
	
	/**
	调用 connect 方将会把这个属性发送给"监听者", 即只有"监听者"才能获得这个.
	*/
	@:optional var sender : MessageSender;
}

@:enum abstract PlatformOs(String) from String to String {
	var mac = "mac";
	var win = "win";
	var android = "android";
	var cros = "cros";
	var linux = "linux";
	var openbsd = "openbsd";
}

@:enum abstract PlatformArch(String) from String to String {
	var arm = "arm";
	var x86_32 = "x86-32";
	var x86_64 = "x86-64";
}

@:enum abstract PlatformNaclArch(String) from String to String {
	var arm = "arm";
	var x86_32 = "x86-32";
	var x86_64 = "x86-64";
}

typedef PlatformInfo = {
	var os : PlatformOs;
	var arch : PlatformArch;
	var nacl_arch : PlatformNaclArch;
}

@:enum abstract RequestUpdateCheckStatus(String) from String to String {
	var throttled = "throttled";
	var no_update = "no_update";
	var update_available = "update_available";
}

@:enum abstract OnInstalledReason(String) from String to String {
	var install = "install";
	var update = "update";
	var shared_module_update = "shared_module_update";
}

@:enum abstract OnRestartRequiredReason(String) from String to String {
	var app_update = "app_update";
	var os_update = "os_update";
	var periodic = "periodic";
}

typedef DirectoryEntry = Dynamic; //TODO

/**
获取后台网页、返回清单文件详情、监听并响应 app 生命周期内的事件，您还可以使用该 API 将相对路径的 URL 转换为完全限定的 URL。

可用版本: chrome 22+

内容脚本: 支持 connect、getManifest、getURL、id、onConnect、onMessage 和 sendMessage。[了解更多](http://chajian.baidu.com/developer/extensions/content_scripts.html) 

http://chajian.baidu.com/developer/apps/runtime.html
*/
@:require(chrome)
@:native("chrome.runtime")
extern class Runtime {
	/**
	如果发生错误，在各方法的回调函数执行的过程中将会定义该属性。 (只能在回调函数中访问这个属性, 如果发生错误)
	*/
	static var lastError : { ?message:String };
	
	/**
	当前应用标识符。 
	*/
	static var id : String;
	
	/**
	获得当前应用的"后台网页"的 window 对象, 如果"后台网页" 是 "事件页面",系统会确保在调用回调函数前它已经加载。如果没有后台网页，将会设置错误信息
	
	和 chrome.extension 下的同名方法不一样的是这个方法是异步的,不太好控制. 这是因为 chrome.app 下...
	*/
	static function getBackgroundPage( callback : js.html.Window->Void ) : Void;
	
	/**
	打开选项页面, 如果有的话. 否则设置 lastError
	*/
	static function openOptionsPage( ?callback : Void->Void ) : Void;
	
	/**
	从清单文件中返回有关应用或应用的详情
	*/
	static function getManifest( ) : Dynamic;
	//static function getManifest( callback : Dynamic->Void ) : Void;		// TODO: diff
	
	/**
	将指定的 path 转换为基于 APP_ID 的绝对路径 
	*/
	static function getURL( path : String ) : String;
	
	/**
	设置卸载时访问的 URL，可以用来清理服务器上的数据、进行分析以及实现调查。最多不能超过 255 个字符, 设置成功时将调用回调函数,而不是卸载时调用
	*/
	static function setUninstallURL( url : String, ?callback : Void->Void ) : Void;
	
	/**
	重新加载应用
	*/
	static function reload() : Void;
	
	/**
	检查应用是否有更新, TODO: 只用于 app, 而非 extension
	*/
	@:require(chrome_app)
	static function requestUpdateCheck( callback : RequestUpdateCheckStatus->? { version:String }->Void ) : Void;
	
	/**
	chrome 32+, 重新启动 Chrome OS 设备. 仅用于 ChromeOS kiosk 模式 
	*/
	@:require(chrome_os)
	static function restart() : Void;
	
	/**
	尝试连接到应用中的连接监听者（例如"后台网页"）或其他应用, 该方法可用于"内容脚本"连接到所属应用进程、应用之间的通信以及[与网页通信](http://chajian.baidu.com/developer/apps/messaging.html#external-webpage)。注意，该方法不能连接到"内容脚本"中的监听者，但应用可以通过 tabs.connect 连接到嵌入至标签页中的"内容脚本"。
	
	extensionId: 如果省略，则会尝试连接到当前应用
	
	connectInfo
	 - name: 将会传递给 onConnect 事件的回调函数，可以用来区分
	 - includeTlsChannelId: TLS 通道标识符,是否会传递至 onConnectExternal 事件. chrome 32+
	*/
	@:overload(function(connectInfo : { ?name:String, ?includeTlsChannelId:Bool } ):Port { } )	
	static function connect( extensionId : String, connectInfo : {?name:String,?includeTlsChannelId:Bool} ) : Port;
	
	/**
	chrome 28+, TODO: 仅用于 app. 连接到计算机上的原生应用程序
	
	@param application 要连接的已注册应用程序名称
	*/
	static function connectNative( application : String ) : Port;
	
	/**
	向您的应用或另一个应用中的其他事件监听者发送单个消息。与 runtime.connect 类似，但是只发送单个消息（可以有响应）。如果向您自己的应用发送消息，每个网页中都会产生 runtime.onMessage 事件；如果发送至另一个应用则产生 runtime.onMessageExternal 事件。注意，应用不能使用该方法向内容脚本发送消息。要向内容脚本发送消息，请使用 tabs.sendMessage。 
	*/
	@:overload(function(message : Dynamic, ?callback : Function):Void { } )	
	static function sendMessage( extensionId : String, message : Dynamic, ?options : {?includeTlsChannelId:Bool}, ?callback : Function ) : Void;
	
	/**
	向原生应用程序发送单个消息。 
	*/
	@:overload(function(message : Dynamic, ?callback : Function):Void { } )	
	static function sendNativeMessage( application : String, message : Dynamic, ?callback : Function ) : Void;
	
	/**
	返回有关当前平台的信息 
	*/
	static function getPlatformInfo( callback : PlatformInfo->Void ) : Void;
	//static function getPlatformInfo( callback : PlatformInfo->Void ) : Port;		// TODO: diff
	
	/**
	返回包目录对应的 DirectoryEntry（目录项） 
	*/
	static function getPackageDirectoryEntry( callback : DirectoryEntry->Void ) : Void;
	//static function getPackageDirectoryEntry( callback : DirectoryEntry->Void ) : Port;		// TODO: diff
	
	/**
	chrome 23+, 当安装了该应用的配置文件第一次启动时产生。即使应用以“分离式”隐身模式运行，启动隐身配置文件时也不会产生该事件。 
	*/
	static var onStartup(default,never) : Event<Void->Void>;
	
	/**
	当应用第一次安装、更新至新版本或浏览器更新至新版本时产生。 
	*/
	static var onInstalled(default,never) : Event<{reason:OnInstalledReason,?previousVersion:String,?id:String}->Void>;
	
	/**
	only app. 在事件页面即将卸载前发送，这样应用就有机会进行清理。注意，由于页面即将卸载，处理该事件时开始的任何异步操作都不能保证完成。如果卸载前事件页面产生了更多活动，将产生 onSuspendCanceled 事件，并且事件页面不会卸载。 
	*/
	@:require(chrome_app)
	static var onSuspend(default,never) : Event<Void->Void>;
	
	/**
	在 onSuspend 之后发送，表示应用最终不会被卸载。 
	*/
	static var onSuspendCanceled(default, never) : Event<Void->Void>;
	
	/**
	chrome 25+, 当更新可用时产生，然而由于应用当前还在运行，不能立即安装。如果您什么都不做，更新将在后台网页下一次卸载时安装。如果您希望快点安装，您可以显式调用 runtime.reload。如果您的应用使用的是持久存在的后台网页，后台网页始终不会卸载，所以除非您响应该事件并调用 chrome.runtime.reload()，否则只有等到浏览器下一次重新启动时更新才会安装。如果没有处理程序监听该事件，并且您的应用使用持久的后台网页，那么实际行为就和您调用 chrome.runtime.reload() 响应该事件一样。 
	*/
	static var onUpdateAvailable(default,never) : Event<{version:String}->Void>;

	//static var onBrowserUpdateAvailable(default,never) : Event<Void->Void>;
	
	/**
	chrome 26, 当从应用进程或内容脚本中发起时产生
	*/
	static var onConnect(default, never) : Event<Port->Void>;
	
	/**
	当从另一个应用发起时产生。 
	*/
	static var onConnectExternal(default,never) : Event<Port->Void>;
	static var onMessage(default,never) : Event<Dynamic->MessageSender->Function->Void>;
	static var onMessageExternal(default,never) : Event<Dynamic->MessageSender->Function->Void>;
	
	/**
	chrome 29+app, 应用或者运行它的设备需要重新启动时产生，应用应该尽早关闭所有窗口，以便开始重新启动。如果应用什么都不做，超过 24 小时的宽限期后会强制重新启动。目前，只有 Chrome OS 的 Kiosk 应用会产生该事件。 
	*/
	@:require(chrome_os)
	static var onRestartRequired(default,never) : Event<OnRestartRequiredReason->Void>;
}
