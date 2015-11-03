package chrome.system;

import chrome.Events;

/**
存储单元的媒体类型
 - fixed: 存储器是固定媒体，例如硬盘或 SSD。
 - removable: 存储器可移动，例如 USB 闪存盘。
 - unknown: 存储器类型未知。
*/
@:enum abstract StorageUnitType(String) from String to String {
	var fixed = "fixed";
	var removable = "removable";
	var unknown = "unknown";
}

/**

 - id: 唯一标识存储设备的暂存标识符，标识符在应用程序同一次运行中持久有效，但不会在同一应用程序两次运行或者不同应用程序之间持久保留。
 - name: 存储单元的名称
 - type: StorageUnitType
 - capacity: 存储空间的总共大小，以字节为单位。
*/
typedef StorageUnitInfo = {
	var id : String;
	var name : String;
	var type : StorageUnitType;
	var capacity : Float;
}

/**
弹出可移动存储设备
 - success: 弹出命令成功完成，应用程序可以提示用户拔出设备 
 - in_use: 另一个应用程序正在使用该设备，弹出命令没有成功，用户不应该拔出设备，而应该等另一个应用程序使用完该设备。
 - no_such_device: 指定设备不存在
 - failure: 弹出命令失败。
*/
@:enum abstract StorageEjectResult(String) from String to String {
	var success = "success";
	var in_use = "in_use";
	var no_such_device = "no_such_device";
	var failure = "failure";
}

/**
chrome 30+, 查询存储设备信息，并在连接或移除可移动存储设备时得到通知

权限: "system.storage"
*/
@:require(chrome)
@:native('chrome.system.storage')
extern class Storage {
	/**
	从系统获取存储信息，传递给回调函数的参数为 StorageUnitInfo 对象的数组。 
	*/
	static function getInfo( callback : Array<StorageUnitInfo>->Void ) : Void;
	
	/**
	弹出可移动存储设备。 
	*/
	static function ejectDevice( id : String, callback : StorageEjectResult->Void ) : Void;
	@:require(chrome_dev)
	static function getAvailableCapacity( id : String, callback : {id:String,availableCapacity:Float}->Void ) : Void;
	
	/**
	当可移动存储器连接到系统时产生。 
	*/
	static var onAttached(default,never) : Event<StorageUnitInfo->Void>;
	
	/**
	当可移动设备从系统移除时产生。 
	*/
	static var onDetached(default,never) : Event<String->Void>;
}
