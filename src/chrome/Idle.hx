package chrome;

import chrome.Events;

/**
active: 活动

idle: 如果用户在指定时间（以秒为单位）内没有任何输入

locked: 系统已锁定
*/
@:enum abstract IdleState(String) from String to String {
	var active = "active";
	var idle = "idle";
	var locked = "locked";
}

/**
检测计算机空闲状态的更改

可用版本: chrome 6+
 
权限: "idle" 
*/
@:require(chrome)
@:native("chrome.idle")
extern class Idle {
	/**
	如果系统已锁定则返回 "locked"，如果用户在指定时间（以秒为单位）内没有任何输入则返回 "idle"，否则返回 "active" 
	*/
	static function queryState( detectionIntervalInSeconds : Int, callback : IdleState-> Void ) : Void;
	
	/**
	设置以秒为单位的间隔，用来确定 onStateChanged 事件中系统是否处于空闲状态，默认间隔为 60 秒。
	*/
	static function setDetectionInterval( intervalInSeconds : Int ) : Void;
	
	/**
	当系统状态变为活动、空闲或已锁定时产生。如果屏幕锁定或屏幕保护程序启动则产生该事件并传递 "locked"，如果系统未锁定并且用户在以秒为单位的指定时间内没有任何输入则产生该事件并传递 "idle"，如果用户系统空闲时产生输入则传递 "active"。 
	*/
	static var onStateChanged(default,never) : Event<IdleState->Void>;
}
