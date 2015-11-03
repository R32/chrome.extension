package chrome;

import chrome.Events;
import chrome.Tabs;

/**
窗口类型:
 - normal: 正常
 - popup: 像 BrowsePage 的"弹出"页面一样,像一个 DIV 层一样 如:没有浏览器地址栏这些
 - panel: 
 - app: TODO: 估计只能用于 chrome app
 - devtools: 
*/
@:enum abstract WindowType(String) from String to String {
	var normal = "normal";
	var popup = "popup";
	var panel = "panel";
	var app = "app";
	var devtools = "devtools";
}

/**
窗口状态: 
 - normal: 正常
 - minimized: 最小
 - maximized: 最大
 - fullscreen: 全屏,按下F11那样
 - docked: TODO: ???停靠
*/
@:enum abstract WindowState(String) from String to String {
	var normal = "normal";
	var minimized = "minimized";
	var maximized = "maximized";
	var fullscreen = "fullscreen";
	var docked = "docked";
}

/**
窗口实例: 参看 Windows.create 函数参数
 - id: 窗口标识符，窗口标识符在浏览器会话中唯一。在某些情况下，例如当您使用 sessions API 查询窗口时，窗口可能没有标识符，此时存在会话标识符。
 - focused: 是否具有焦点。
 - top: 
 - left: 
 - width: 
 - height: 
 - tabs: 表示窗口中所有标签页的 tabs.Tab 对象数组。
 - incognito: 
 - type: 
 - state: 
 - alwaysOnTop: 窗口是否设置为前端显示
 - sessionId: 会话标识符，由 sessions-API 获取的窗口
*/
typedef Window = {
	@:optional var id : Int;
	var focused : Bool;
	@:optional var top : Int;
	@:optional var left : Int;
	@:optional var width : Int;
	@:optional var height : Int;
	@:optional var tabs : Array<Tab>;
	var incognito : Bool;
	@:optional var type : WindowType;
	@:optional var state : WindowState;
	var alwaysOnTop : Bool;
	@:optional var sessionId : String;
}

/**
chrome.windows.create 的 type 对应的枚举
*/
@:enum abstract CreateType(String) from String to String {
	var normal = "normal";
	var popup = "popup";
	var panel = "panel";
	var detached_panel = "detached_panel";
}

/**
与浏览器窗口交互。您可以使用该模块创建、修改和重新排列浏览器中的窗口

权限: 不需要任何权限就能使用。但是， Tab 的 url、title 和 favIconUrl 属性需要有 "tabs" 权限后才会给出。windows.Window 对象会包含 tabs.Tab 对象数组。如果您需要访问 tabs.Tab 的 url、title 或 favIconUrl 属性，您必须在清单文件中声明 "tabs" 权限。例如：

[更多文档...](http://chajian.baidu.com/developer/extensions/windows.html)
*/
@:require(chrome_ext)
@:native("chrome.windows")
extern class Windows {
	/**
	-1, 表示不存在windowId值 
	*/
	static var WINDOW_ID_NONE(default, never) : Int;
	
	/**
	-2, 代表当前窗口的windowId值 
	*/
	static var WINDOW_ID_CURRENT(default,never) : Int;
	
	/**
	获取一个窗口的有关详情 
	 - windowId: 
	 - getInfo:  populate 如果为 true，windows.Window 对象会有 tabs 属性，包含所有 tabs.Tab 对象的列表。只有当应用清单文件中包含 "tabs" 权限时，Tab 对象才会包含 url、title 和 favIconUrl 属性。
	 - callback: 
	*/
	static function get(
		windowId : Int,
		?getInfo : { ?populate : Bool, ?windowTypes : Array<WindowType> },
		callback : Window->Void
	) : Void;
	
	/**
	获得当前"窗口" 
	*/
	static function getCurrent( ?getInfo : { ?populate : Bool, ?windowTypes : Array<WindowType> }, callback : Window->Void ) : Void;
	
	/**
	获得最近获得焦点的窗口，通常为顶层窗口
	*/
	static function getLastFocused( ?getInfo : { ?populate : Bool, ?windowTypes : Array<WindowType> }, callback : Window->Void ) : Void;
	
	/**
	获取所有"窗口" 
	*/
	static function getAll( ?getInfo : { ?populate : Bool, ?windowTypes : Array<WindowType> }, callback : Array<Window>->Void ) : Void;
	
	/**
	创建（打开）一个新的浏览器"窗口"，可以提供大小、位置或默认 URL 等可选参数。 
	createData:
	 - url: 要在窗口中打开的一个 URL 或 URL 数组。完整的 URL 必须包含协议（即 "http://www.google.com"，而不是 "www.google.com"），而相对 URL 相对于应用中的当前页面。默认为“打开新的标签页”页面。
	 - tabId: 需要移动至新窗口的标签页标识符
	 - left: 新窗口与屏幕左侧的距离，以像素为单位。如果未指定，新窗口将自然地与最后一个活动窗口偏离一定的距离。对于面板将忽略这一值。
	 - top: 新窗口与屏幕顶部的距离，以像素为单位。如果未指定，新窗口将自然地与最后一个活动窗口偏离一定的距离。对于面板将忽略这一值。
	 - width: 新窗口的宽度（包含边框），以像素为单位，如果未指定则默认为自然宽度。
	 - height: 新窗口的高度（包含边框），以像素为单位，如果未指定则默认为自然高度。
	 - focused: 如果为true，则打开一个活动窗口；如果为false，则打开一个不活动窗口。
	 - incognito: 新窗口是否为隐身窗口
	 - type: CreateType,浏览器窗口类型,除非设置了“--enable-panels”标志，"panel" 与 "detatched_panel" 类型都会创建弹出窗口。
	 - state: 浏览器窗口状态
	*/
	static function create(
		?createData : {
			?url : String,
			?tabId : Int,
			?left : Int,
			?top : Int,
			?width : Int,
			?height : Int,
			?focused : Bool,
			?incognito : Bool,
			?type : CreateType,
			?state : WindowState,
		},
		?callback : ?Window->Void
	) : Void;
	
	/**
	更新窗口属性。仅指定您需要更改的属性，未指定的属性不会更改。
	
	updateInfo:
	 - drawAttention: 如果为true，使窗口以吸引用户注意的方式显示，而不更改活动窗口，这一效果将一直持续到用户将焦点移至这一窗口。如果窗口已经获得焦点则该选项无效，将这一属性设置为false可以取消上一次的突出显示请求。
	*/
	static function update(
		windowId : Int,
		updateInfo : {
			?left : Int,
			?top : Int,
			?width : Int,
			?height : Int,
			?focused : Bool,
			?drawAttention : Bool,
			?state : WindowState
		},
		?callback : Window->Void
	) : Void;
	
	/**
	移除（关闭）一个"窗口"以及其中的所有"标签"页。 
	*/
	static function remove( windowId : Int, ?callback : Void->Void ) : Void;
	static var onCreated(default,never) : Event<Window->Void>;
	static var onRemoved(default,never) : Event<Int->Void>;
	
	/**
	如果所有浏览器窗口都没有焦点则为 windows.WINDOW_ID_NONE,注意：在某些 Linux 窗口管理器中，从一个浏览器窗口切换到另一个之前总是会发送 windows.WINDOW_ID_NONE 的该事件。
	*/
	static var onFocusChanged(default,never) : Event<Int->Void>;
}
