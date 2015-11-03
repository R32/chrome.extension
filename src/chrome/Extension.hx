package chrome;

/**
tab: 浏览器标签页

popup: 弹出窗口页

notification: 通知
*/
@:enum abstract ViewType(String) from String to String {
	var tab = "tab";
	var notification = "notification";
	var popup = "popup";
}

/**
在任何页面都能使用, 包括在应用和内容脚本之间或者两个应用之间交换消息的支持。

可用版本: chrome 5+

内容脚本: 支持 getURL、inIncognitoContext、lastError [了解更多](http://chajian.baidu.com/developer/extensions/content_scripts.html)
*/
@:require(chrome_ext)
@:native("chrome.extension")
extern class Extension {
	/**
	如果异步应用 API 发生错误，将在回调函数的生命周期内设置该属性。如果没有错误发生，lastError 将为 undefined 
	*/
	static var lastError(default, never) : { message : String };
	
	/**
	如果内容脚本正在隐身标签页中运行，或者应用页面在隐身进程中运行，则为 true。后一种情况只适用于具有分离（"split"）隐身行为的应用。 
	*/
	static var inIncognitoContext(default, never) : Bool;
	
	/**
	将应用安装目录中的相对路径转换为完整的 URL. e.g:  getURL("index.html") `=>` ""chrome-extension://onialapnigmlgajbkajanegfgmojoehf/index.html""
	
	个人注: 也许使用 runtime.getURL 更好.
	*/
	static function getURL( path : String ) : String;
	
	/**
	返回一个数组，含有每一个在当前应用中运行的页面的JavaScript window 对象。
	
	如果 type 省略则返回所有 ViewType 类型,
	
	windowId 将搜索限制在指定窗口中, 如果省略，返回所有视图
	*/
	static function getViews( ?fetchProperties : { ?type : ViewType, ?windowId : Int } ) : Array<js.html.Window>;
	
	/**
	返回运行在当前应用中的 后台网页的 JavaScript window 对象。如果应用没有后台网页则返回 null。
	
	通过这个 window 对象共享后台的变量.
	*/
	static function getBackgroundPage() : js.html.Window;
	
	/**
	获取该应用能否在隐身模式中使用（由用户控制的“在隐身模式下启用”复选框决定）的状态。 
	*/
	static function isAllowedIncognitoAccess( callback : Bool->Void ) : Void;
	
	/**
	获取该应用能否访问 file:// 协议（由用户控制的“允许访问文件网址”复选框决定）的状态。 
	*/
	static function isAllowedFileSchemeAccess( callback : Bool->Void ) : Void;
	
	/**
	
	???设置ap CGI的参数值用于更新 extension的URL。 Chrome Extension Gallery上托管的扩展将会忽略该值 
	*/
	static function setUpdateUrlData( data : String ) : Void;
}
