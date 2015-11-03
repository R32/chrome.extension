package chrome.system;

/**
获取内存信息, chrome 32+

权限: "system.memory"  
*/
@:require(chrome)
@:native("chrome.system.memory")
extern class Memory {
	/**
	获取物理内存信息
	 - capacity: 物理内存容量的总计大小，以字节为单位 
	 - availableCapacity: 可用容量的大小，以字节为单位
	*/
	static function getInfo( callback : {capacity:Float,availableCapacity:Float}->Void ) : Void;

}
