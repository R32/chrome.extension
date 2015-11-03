package chrome.system;

/**
usage: 使用情况
 - user: 用户空间的程序在该处理器上总共使用的时间
 - kernel: 内核程序在该处理器上总共使用的时间
 - idle: 该处理器空闲的总计时间
 - total: 该处理器累计使用时间，等于 user + kernel + idle。
*/
private typedef Processor = {
	var usage : {
		user : Float,
		kernel : Float,
		idle : Float,
		total : Float
	};
}

/**
查询 CPU 元数据

可用版本: chrome 32+

权限: "system.cpu" 
*/
@:require(chrome)
@:native("chrome.system.cpu")
extern class Cpu {
	/**
	查询系统 CPU 的基本信息
	 - numOfProcessors: 逻辑处理器数目.
	 - archName: 处理器的模型名称. e.g: "x86"
	 - modelName: 处理器的模型名称 e.g: "AMD Athlon(tm) II X2 255 Processor"
	 - features: 表示处理器能力的特性代号，目前支持的代号有 "mmx"、"sse"、"sse2"、"sse3"、"ssse3"、"sse4_1"、"sse4_2" 和 "avx"。
	 - processors: 每个逻辑处理器的有关信息
	*/
	static function getInfo( callback : {numOfProcessors:Int,archName:String,modelName:String,features:Array<String>,processors:Array<Processor>}->Void ) : Void;

}
