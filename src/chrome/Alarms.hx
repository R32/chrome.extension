package chrome;

import chrome.Events;

/**
单个定时器实例
*/
typedef Alarm = {
	var name : String;
	
	/**
	定时器计划触发时间, 以纪元以来所经过的毫秒数为单位。e.g: `Date.now() + ms`
	由于性能问题，定时器可能会有所延迟
	*/
	var scheduledTime : Float;
	
	/**
	每隔 periodInMinutes 分钟触发，如果不为 null 的话。
	*/
	@:optional var periodInMinutes : Float;
}

/**
描述定时器(Alarm)触发时刻， 初使时刻必须由 when 或者 delayInMinutes 中的某一个(但不能同时)指定。

如果设置了 periodInMinutes，定时器(Alarm)将在初始事件后每隔 periodInMinutes 分钟重复。定义了 periodInMinutes 值的定时器后继将称之为 "重复定时器"

如果"重复定时器"的 when 或 delayInMinutes 都没有设置, 则 periodInMinutes 将作为 delayInMinutes 的默认值。
*/
typedef AlarmCreateInfo = {
	/**
	定时器未来触发时刻，以毫秒为单位。e.g: `Date.now() + ms`
	*/
	@:optional var when : Float;
	
	/**
	以分钟为单位的延迟。
	*/
	@:optional var delayInMinutes : Float;
	
	/**
	如果设置了该属性, 定时器将在由 when 或者 delayInMinutes 指定的初始时间后每隔 periodInMinutes 分钟触发。
	如果没有设置，定时器只会触发一次。
	*/
	@:optional var periodInMinutes : Float;
}

/**
定时器(Alarms)，周期性的运行或在将来的指定时间运行。注意: 所有方法都是以回调的形式处理。

可用版本: chrome 22+

权限: "alarms"
*/
@:require(chrome)
@:native("chrome.alarms")
extern class Alarms {
	/**
	创建定时器, when 或 delayInMinutes 的值将触发 onAlarm
	*/
	static function create( ?name : String, alarmInfo : AlarmCreateInfo ) : Void;
	static function get( ?name : String, callback : Alarm->Void ) : Void;
	static function getAll( callback : Array<Alarm>->Void ) : Void;
	static function clear( ?name : String, ?callback : Bool->Void ) : Void;
	static function clearAll( ?callback : Bool->Void ) : Void;
	
	/**
	当定时器到达时间时产生 
	*/
	static var onAlarm(default,never) : Event<Alarm->Void>;
}
