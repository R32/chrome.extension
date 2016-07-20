package chrome;

import chrome.Runtime;
import chrome.Types;
import chrome.Windows;
import chrome.Events;
import chrome.ExtensionTypes;

@:enum abstract MutedInfoReason(String) from String to String {
	var user = "user";
	var capture = "capture";
	var extension = "extension";
}

/**
 
*/
typedef Tab = {
	/**
	标签页的标识符。标签页的标识符在浏览器会话中唯一。在某些情况下，标签页可能没有标识符，例如使用 sessions API 查询外来标签页时，此时可能存在会话标识符。 
	*/
	@:optional var id : Int;
	
	/**
	标签页在所在窗口中的索引，从 0 开始。
	*/
	var index : Int;
	
	/**
	标签页所在窗口的标识符。 
	*/
	var windowId : Int;
	
	/**	
	chrome 18+, 打开这一标签页的标签页标识符（如果存在的话），只有该标签页仍然存在时才会有这一属性。 
	*/
	@:optional var openerTabId : Int;
	
	/**
	chrome 16+, 标签页是否高亮突出。 
	*/
	@:optional var highlighted : Bool;
	
	/**
	标签页是否是窗口中的活动标签页。（窗口不一定有焦点。） 
	*/
	var active : Bool;
	
	/**
	标签页是否固定。 
	*/
	var pinned : Bool;
	
	@:optional var audible : Bool;
	
	/**
	标签页中显示的 URL，只有当应用拥有 "tabs" 权限时该属性才会存在。 
	*/
	@:optional var url : String;
	
	/**
	标签页的标题，只有当应用拥有 "tabs" 权限时该属性才会存在，如果标签页正在加载它也可能是空字符串。 
	*/
	@:optional var title : String;
	
	/**
	标签页的收藏夹图标 URL，只有当应用拥有 "tabs" 权限时该属性才会存在，如果标签页正在加载它也可能是空字符串。
	*/
	@:optional var favIconUrl : String;
	
	/**
	"loading"（正在加载）或 "complete"（完成）。 
	*/
	@:optional var status : TabStatus;
	
	/**
	标签页是否在隐身窗口中。
	*/
	@:optional var incognito : Bool;
	
	/**
	chrome 31+, 标签页高度，以像素为单位。 
	*/
	@:optional var width : Int;
	
	/**
	chrome 31+, 标签页高度，以像素为单位。 
	*/
	@:optional var height : Int;
	
	/**
	会话标识符，用于唯一标识由 sessions API 获取的标签页。 
	*/
	@:optional var sessionId : String;
}

/**
定义缩放设置更改的处理方式，即哪一方负责网页的实际缩放，默认为 automatic 
*/
@:enum abstract ZoomSettingsMode(String) from String to String {
	/**
	缩放设置的更改由浏览器自动处理 
	*/
	var automatic = "automatic";
	
	/**
	替换缩放更改的自动处理。onZoomChange 事件还是会分发，并且应用需要监听该事件，手动缩放网页。该模式下不支持 per-origin（不同来源独立缩放），因此忽略 scope（范围）缩放设置，始终为 per-tab（仅在当前标签页中生效） 
	*/
	var manual = "manual";
	
	/**
	禁用标签页中的所有缩放，标签页恢复为默认（100%）的缩放比例，所有缩放更改都会忽略。 
	*/
	var disabled = "disabled";
}

/**
定义缩放更改是根据网页来源保存，还是仅在当前标签页中生效。automatic（自动）模式下默认为 per-origin，其他模式下则为 per-tab。 
*/
@:enum abstract ZoomSettingsScope(String) from String to String {
	/**
	缩放更改保存在经过缩放的网页来源中，即导航到同一来源的其他标签页也同样会缩放。此外，per-origin 缩放更改与来源一起保存，也就是说导航到同一来源的其他网页时，也同样会缩放至相同的比例。per-origin 范围只能在 automatic 模式下使用。 
	*/
	var per_origin = "per-origin";
	
	/**
	缩放更改仅在当前标签页中生效，其他标签页中的缩放更改也不会影响当前标签页。此外，per-tab 缩放更改导航时重置，导航标签页时始终以 per-origin 缩放比例加载网页。 
	*/
	var per_tab = "per-tab";
}

/**
chrome 38+, 定义标签页中缩放设置更改的处理方式与范围。

*/
typedef ZoomSettings = {
	/**
	定义缩放设置更改的处理方式 
	*/
	@:optional var mode : ZoomSettingsMode;
	
	/**
	定义缩放更改是根据网页来源保存，还是仅在当前标签页中生效 
	*/
	@:optional var scope : ZoomSettingsScope;
	
	/**
	快速设置. 默认值为 1.0 即 100% 
	*/
	@:optional var defaultZoomFactor : Float;
}

/**
 - loading: 正在加载
 - complete: 完成.
*/
@:enum abstract TabStatus(String) from String to String {
	var loading = "loading";
	var complete = "complete";
}

/**
浏览器"标签页"交互。您可以使用该 API 创建、修改或重新排列浏览器中的标签页。 

可用版本: chrome 5+

权限: 大部分 chrome.tabs API 不需要任何权限就能使用。然而， Tab 的 url、title 和 favIconUrl 属性需要有 "tabs" 权限后才会给出tabs.captureVisibleTab 需要 "<all_urls>" 或 "activeTab" 权限才能使用。

http://chajian.baidu.com/developer/apps/tabs.html
*/
@:require(chrome_ext)
@:native("chrome.tabs")
extern class Tabs {
	/**
	获得指定标签页的有关详情。
	*/
	static function get( tabId : Int, callback : Tab->Void ) : Void;
	
	/**
	获得当前调用脚本所在的标签页，如果在非标签页环境下调用则可能返回 undefined（例如，后台页面或弹出视图）。
	*/
	static function getCurrent( callback : Tab->Void ) : Void;
	
	/**
	连接到指定标签页中的内容脚本，这样当前应用在指定标签页中运行的每一个内容脚本都会产生 runtime.onConnect 事件。有关更多详情，请参见内容脚本的消息传递。 
	*/
	static function connect( tabId : Int, connectInfo : {?name:String} ) : chrome.Port;
	
	/**
	chrome 20+, 向指定标签页中的内容脚本发送一个消息，当发回响应时执行一个可选的回调函数。当前应用在指定标签页中的每一个内容脚本都会收到 runtime.onMessage 事件。 
	*/
	static function sendMessage( tabId : Int, message : Dynamic, callback : Dynamic->Void ) : Void;
	
	/**
	创建一个新标签页。
	
	createProperties:
	 - windowId: 创建新标签页的窗口，默认为当前窗口。
	 - index: 标签页在窗口中的位置，提供的值如果超过0与窗口中标签页数目之间的范围，将会自动限定在这一范围。
	 - url: 标签页中一开始打开的 URL。完整的 URL 必须包括协议（即 "http://www.google.com"，而不能是 "www.google.com"），相对 URL 相对于应用中的当前页面。默认为“打开新的标签页”页面。
	 - active: 标签页是否应该成为窗口中的活动标签页，不影响窗口是否有焦点（参见 windows.update），默认为 true。
	 - pinned: 标签页是否应该固定，默认为 false。
	 - openerTabId: 打开这一标签页的标签页标识符。如果指定的话，该标签页必须与新创建的标签页在同一个窗口中。
	*/
	static function create( createProperties : {?windowId:Int,?index:Int,?url:String,?active:Bool,?pinned:Bool, ?openerTabId:Int}, callback : Tab->Void ) : Void;
	
	/**
	复制标签页。
	
	 - tabId: 要复制的标签页的标识符。
	*/
	static function duplicate( tabId : Int, ?callback : Tab->Void ) : Void;
	
	/**
	获取具有指定属性的所有标签页，如果没有指定任何属性的话则获取所有标签页 
	
	queryInfo:
	 - active: 标签页在窗口中是否为活动标签页。
	 - pinned: 标签页是否固定。
	 - audible: 
	 - muted: 
	 - highlighted: 标签页是否高亮突出。
	 - lastFocusedWindow: 标签页是否在前一个具有焦点的窗口中。
	 - currentWindow: 标签页是否在当前窗口中。
	 - status: 标签页是否已经加载完成。
	 - title: 匹配页面标题的表达式。
	 - url: 匹配标签页的 URL 表达式。注意：片段标识符不会匹配。
	 - windowId: 父窗口标识符，或者为 windows.WINDOW_ID_CURRENT，表示当前窗口。
	 - windowType: 标签页所在窗口的类型。enum of {"normal", "popup", "panel", or "app"}
	 - index: 标签页在窗口中的位置。
	*/
	static function query( queryInfo : {?active:Bool,?pinned:Bool,?audible:Bool,?muted:Bool,?highlighted:Bool,?lastFocusedWindow:Bool,?currentWindow:Bool,?status:TabStatus,?title:String,?url:String,?windowId:Int,?windowType:WindowType,?index:Int}, callback : Array<Tab>->Void ) : Void;
	
	/**
	同时选中多个"标签页", 在 chrome 中, 用户可以按住 shift或Ctrol 点击选中多个 标签页面,然后右键执行多个操作.
	*/
	static function highlight( highlightInfo : {?windowId:Int,tabs:Array<Int>}, ?callback : Window->Void ) : Void;
	
	/**
	修改标签页属性，updateProperties 中未指定的属性保持不变。 
	
	updateProperties:
	 - url: 标签页打开的 URL。
	 - active: 标签页是否为活动标签页，不影响窗口是否有焦点（参见 windows.update）。
	 - highlighted: 从当前选定项目中添加或删除标签页。
	 - pinned: 标签页是否固定。
	 - muted: 
	 - openerTabId: 打开这一标签页的标签页标识符。如果指定的话，该标签页必须与新创建的标签页在同一个窗口中。
	*/
	static function update( ?tabId : Int, updateProperties : {?url:String,?active:Bool,?highlighted:Bool,?pinned:Bool,?muted:Bool,?openerTabId:Int}, ?callback : Tab->Void ) : Void;
	
	/**
	将一个或多个标签页移动至所在窗口中的新位置，或者移动到新窗口中。注意，标签页只能在普通窗口（window.type === "normal"）间移动。 
	*/
	@:overload(function( ?tabId : Int, moveProperties : {?windowId:Int,?index:Int}, ?callback : Array<Tab>->Void ) : Void {})
	static function move( ?tabId : Int, moveProperties : {?windowId:Int,?index:Int}, ?callback : Tab->Void ) : Void;
	
	/**
	重新加载标签页。 
	*/
	static function reload( ?tabId : Int, reloadProperties : {?bypassCache:Bool}, ?callback : Void->Void ) : Void;
	
	/**
	关闭一个或多个标签页。 
	*/
	@:overload(function( ?tabId : Array<Int>, ?callback : Void->Void ) : Void {})
	static function remove( ?tabId : Int, ?callback : Void->Void ) : Void;
	
	/**
	检测某个标签页中内容的主要语言。 语言参见: https://src.chromium.org/viewvc/chrome/trunk/src/third_party/cld/languages/internal/languages.cc
	*/
	static function detectLanguage( ?tabId : Int, callback : String->Void ) : Void;
	
	/**
	捕捉指定窗口中当前活动标签页的可见区域，您必须拥有 "<all_urls>" 或当前活动标签页的 "activeTab" 权限才能使用该方法。 
	*/
	static function captureVisibleTab( ?windowId : Int, ?options : {?format:ImageDetails,?auality:Int}, callback : String->Void ) : Void;
	
	/**
	在页面中插入 JavaScript 代码。 [更多细节参看](http://chajian.baidu.com/developer/extensions/content_scripts.html#pi)
	
	details: 参看 insertCSS 的文档注释
	*/
	static function executeScript( ?tabId : Int, details : {?code:String,?file:String,?allFrames:Bool,?matchAboutBlank:Bool,?runAt:String}, ?callback : Array<Dynamic>->Void ) : Void;
	
	/**
	向一个页面中插入CSS。有关更多详情. 
	
	details: 要插入的脚本或 CSS 的详情。必须设置 code 和 file 属性中的某一个，而且不能同时设置。
	
	 - code: 要插入的 JavaScript 或 CSS 代码。
	 - file: 要插入的 JavaScript 或 CSS 文件。
	 - allFrames: 如果 allFrames 为 true，则意味着当前页面中的所有框架都要插入 JavaScript 或 CSS。默认情况下为 false，只在顶层主框架中插入。
	 - matchAboutBlank: 如果 matchAboutBlank 为 true，代码同时也会插入 about:blank 和 about:srcdoc 框架（如果您的应用有权限访问所属文档）。不能在顶层 about: 框架中插入代码。默认情况下为 false。
	 - runAt: JavaScript 或 CSS 插入标签页的最早时间，默认为 "document_idle"。enum of "document_start", "document_end", or "document_idle"
	*/
	static function insertCSS( ?tabId : Int, details : {?code:String,?file:String,?allFrames:Bool,?matchAboutBlank:Bool,?runAt:String}, ?callback : Void->Void ) : Void;
	
	/**
	缩放指定的标签页。 
	*/
	static function setZoom( ?tabId : Int, zoomFactor : Float, ?callback : Void->Void ) : Void;
	static function getZoom( ?tabId : Int, callback : Float->Void ) : Void;
	
	/**
	设置指定标签页的缩放选项，定义缩放更改的处理方式。标签页导航时重置这些设置。 
	*/
	static function setZoomSettings( ?tabId : Int, zoomSettings : ZoomSettings, ?callback : Void->Void ) : Void;
	static function getZoomSettings( ?tabId : Int, callback : ZoomSettings->Void ) : Void;
	
	/**
	当标签页创建时产生。注意，当该事件发生时标签页的 URL 可能还没有设置，但是您可以监听 onUpdated 事件，当设置 URL 时. 
	*/
	static var onCreated(default,never) : Event<Tab->Void>;
	
	/**
	当标签页更新时产生。后二个顺序可变,即 favicon 有时发生在 loading 后,有时会在 completa 之后.
	 - loading: `{status: "loading", url:"chrome://newtab/"}`
	 - [favicon 可选]: `{favIconUrl: "https://...../"}`
	 - complete: `{status: "complete"}`
	*/
	static var onUpdated(default,never) : Event<Int->{?status:String,?url:String,?pinned:Bool,?audible:Bool,?favIconUrl:String}->Tab->Void>;
	
	/**
	当"标签页"在窗口内移动时触发, 仅产生一次移动事件。 而移动到新窗口或从新窗口中移入都不会触发(窗口之间移动参看 onDetached).
	*/
	static var onMoved(default,never) : Event<Int->{windowId:Int,fromIndex:Int,toIndex:Int}->Void>;
	
	/**
	当窗口的活动"标签页"发生变化时。注意，当该事件发生时标签页的 URL 可能还没有设置，但是您可以监听 onUpdated 事件，当设置 URL 时.
	*/
	static var onActivated(default,never) : Event<{tabId:Int,windowId:Int}->Void>;
	
	/**
	当高亮标签页时,(用户按住 shift 或 ctrl 点击多个标签页) 
	*/
	static var onHighlighted(default, never) : Event<{windowId:Int,tabIds:Array<Int>}->Void>;
	
	/**
	当"标签页"从窗口中分离, 分离的"标签页"可以成为新的窗口或移动到新的窗口中去.
	*/
	static var onDetached(default,never) : Event<{oldWindowId:Int,oldPosition:Int}->Void>;
	
	/**
	与 onDetached 形为相反. 当标签页附加到一个窗口时产生
	*/
	static var onAttached(default,never) : Event<{newWindowId:Int,newPosition:Int}->Void>;
	
	/**
	当标签页关闭时产生。 
	*/
	static var onRemoved(default, never) :  Event<Int->{windowId:Int,isWindowClosing:Bool}->Void>;
	
	/**
	当标签页由于"预呈现(prerender)"或"即搜即得"而被另一个标签页替换时产生.
	 - addedTabId: 新的TabId
	 - removedTabId: 被替换掉了的TabId
	如果你也碰上内容脚本动态注入失败的情况，不妨检查下标签页的id值。说不定已经被替换掉了. 
	*/
	static var onReplaced(default,never) :  Event<Int->Int->Void>;
	static var onZoomChange(default,never) :  Event<{tabId:Int,oldZoomFactor:Float,newZoomFactor:Float,zoomSettings:ZoomSettings}->Void>;

}
