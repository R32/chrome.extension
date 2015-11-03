package chrome;

/**
"system"（系统）级别使系统保持活动状态，但是允许屏幕变暗或关闭。例如，通信应用在屏幕关闭时还可以继续接收消息

"display"（显示器）级别使屏幕和系统保持活动状态。例如，电子书和演示文稿应用可以在用户阅读时使屏幕和系统保持活动状态。
*/
@:enum abstract Level(String) from String to String {
	var system = "system";
	var display = "display";
}

/**
修改系统的电源管理特性

可用版本: chrome 27+

权限: "power"

默认情况下，当用户处于不活动状态时操作系统会使屏幕变暗，最后使系统待机。通过电源管理 API，应用或应用可以使系统保持唤醒状态。

当用户有不止一个应用或应用活动，并且有各自的电源级别时，优先级最高的级别优先，"display"（显示器）总是优先于"system"（系统）。例如，如果应用 A 请求 "system"（系统）级电源管理，应用 B 请求 "display（显示器），则会使用 "display（显示器），直到应用 B 卸载或释放它的请求。如果应用 A 仍处于活动状态，则使用 "system"（系统）。
*/
@:require(chrome)
@:native("chrome.power")
extern class Power {
	/**
	请求临时禁用电源管理。level 描述了禁用电源管理的程度。如果同一应用之前发出的请求仍然有效，它会被新的请求取代。 
	*/
	static function requestKeepAwake( level : Level ) : Void;
	
	/**
	释放之前通过 requestKeepAwake() 发出的请求。 
	*/
	static function releaseKeepAwake() : Void;
}
