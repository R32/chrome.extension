package chrome;

import chrome.Events;

/**
notifications(通知)类型

 - basic:
 - image: "通知选项" 需要包含有 imageUrl 属性
 - list: "通知选项"需要包含有 items 属性	
	```js
	items: [
		{title: "Item1", message: "这是项目一"},
		{title: "Item2", message: "这是项目二"}
	]
	```	
 - progress: 更新 "通知选项" 的 progress 属性
*/
@:enum abstract TemplateType(String) from String to String {
	var basic = "basic";
	var image = "image";
	var list = "list";
	var progress = "progress";
}

/**
notifications(通知) 许可级别

 - granted: 允许
 - denied: 拒绝
*/
@:enum abstract PermissionLevel(String) from String to String {
	var granted = "granted";
	var denied = "denied";
}

/**
通知选项设置
*/
typedef NotificationOptions = {
	var type : TemplateType;
	
	/**
	弹出通知时, 窗口左侧的图标URL。URL 可以为 data URL、blob URL 或相对于应用 .crx 文件中的资源的 URL。
	*/
	var iconUrl : String;
	
	@:optional var appIconMaskUrl : String;
	
	/**
	通知的标题 
	*/
	var title : String;
	
	/**
	通知的主要内容 
	*/
	var message : String;
	
	/**
	这个消息将显示在 message 的下方
	*/
	@:optional var contextMessage : String;
	
	/**
	 
	*/
	@:optional var priority : Int;
	
	/**
	(TODO: 形为未知???) 使用时间戳值为参数. e.g: `Date.now() + n` 
	*/
	@:optional var eventTime : Float;
	
	/**
	自定义按钮
	*/
	@:optional var buttons : Array<{title:String,?iconUrl:String}>;
	
	/**
	用于 image 类型通知 
	*/
	@:optional var imageUrl : String;
	
	/**
	用于 list 类型的通知 
	*/
	@:optional var items : Array<{title:String,message:String}>;
	
	/**
	用于 progress 类型通知, 值限定为 0~100， 
	*/
	@:optional var progress : Int;
	
	/**
	 
	*/
	@:optional var isClickable : Bool;
}
/*
typedef NotificationButton = {
	var title : String;
	@:optional var iconUrl : String;
}

typedef NotificationItem = {
	var title : String;
	var message : String;
}
*/

/**
通过模板创建多样通知,并在系统托盘中向用户显示这些通知, 对于同一个通知(id值相同)如果用户未理会仅以 update 的形式出现.而不会再次弹出打扰用户

(个人感觉)通知形式过于单调，也无法做出太多美化. 基本上 basic 类型就够用了

可用版本: chrome 28+

权限: "notifications"
*/
@:require(chrome)
@:native("chrome.notifications")
extern class Notifications {
	
	/**
	* 创建并显示通知。
	* 
	* @param notificationId 通知的标识符,可自已随意起个名字, 如果为空, 则会生成一个. 如果匹配到已有的标识符, 该方法在创建操作之前会首先清除这一通知
	* @param options 通知选项设置
	* @param callback 提供 notificationId 作为回调函数的参数 
	*/
	static function create( notificationId : String, options : NotificationOptions, callback : String->Void ) : Void;
	
	/**
	更新已有的通知, 回调函数的参数将显示是否更新成功
	*/
	static function update( notificationId : String, options : NotificationOptions, callback : Bool->Void ) : Void;
	
	/**
	清除指定的通知 
	*/
	static function clear( notificationId : String, callback : Bool->Void ) : Void;
	
	/**
	获取所有通知, chrome 29+
	*/
	static function getAll( callback : Dynamic->Void ) : Void;
	
	/**
	获取用户是否为当前应用启用通知。chrome 32+ 
	*/
	static function getPermissionLevel( callback : PermissionLevel->Void ) : Void;
	
	/**
	当通知关闭时, 回调函数 callback(notificationId, byUser) ,byUser: 表示为是否为用户关闭
	*/
	static var onClosed(default, never) : Event<String->Bool->Void>;
	
	/**
	用户单击了通知中的非按钮区域 
	*/
	static var onClicked(default, never) : Event<String->Void>;
	
	/**
	自定义的按钮 
	*/
	static var onButtonClicked(default,never) : Event<String->Int->Void>;
	static var onPermissionLevelChanged(default,never) : Event<PermissionLevel->Void>;
	static var onShowSettings(default,never) : Event<Void->Void>;
}
