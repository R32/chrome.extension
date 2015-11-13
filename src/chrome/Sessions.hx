package chrome;

import chrome.Events;
import chrome.Tabs;
import chrome.Windows;

/**
chrome.sessions Filter
 - maxResults: 在请求的列表中获取项目的最大数目，省略该参数获取最大数目的项目（sessions.MAX_SESSION_RESULTS）。
*/
typedef Filter = {
	@:optional var maxResults : Int;
}

/**
chrome.sessions Session
 - lastModified: 窗口或标签页关闭或修改的时间，表示为 1970 年 1 月 1 日以来经过的毫秒数。
 - tab: 
 - window: 
*/
typedef Session = {
	var lastModified : Int;
	@:optional var tab : Tab;
	@:optional var window : Window;
}

/**
chrome.sessions SessionDevice
 - deviceName: 
 - sessions: 
*/
typedef SessionDevice = {
	var deviceName : String;
	var sessions : Array<Session>;
}

/**
查询和恢复浏览器会话中的标签页和窗口

可用版本: chrome 37。警告目前为 Beta 分支.

权限: "sessions"
*/
@:require(chrome_ext)
@:native("chrome.sessions")
extern class Sessions {
	
	/**
	 请求的列表中获取项目的最大数目 
	*/
	static var MAX_SESSION_RESULTS(default, never) : Int;
	
	/**
	 获取最近关闭的标签页和/或窗口列表 
	*/
	static function getRecentlyClosed( ?filter : Filter, callback : Array<Session>->Void ) : Void;
	
	/**
	 获取包含已同步会话的所有设备
	*/
	static function getDevices( ?filter : Filter, callback : Array<SessionDevice>->Void ) : Void;
	
	/**
	 重新打开 windows.Window（窗口）或 tabs.Tab（标签页），可以传递一个可选的回调函数，在项目恢复后调用。
	*/
	static function restore( ?sessionId : String, ?callback : Session->Void ) : Void;
	
	/**
	 最近关闭的标签页和/或窗口更改时产生。不能使用该事件监控同步会话更改。 
	*/
	static var onChanged(default,never) : Event<Void->Void>;
}
