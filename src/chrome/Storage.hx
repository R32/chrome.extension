package chrome;

import chrome.Events;
import haxe.extern.EitherType;
typedef StorageChange = {
	@:optional var oldValue : Dynamic;
	@:optional var newValue : Dynamic;
}

typedef StorageArea = {
	/**
	从存储中获得一个或多个值。
	
	key: String|Array<String>|Obj 要获得的单个键、多个键的列表或者指定默认值的词典（参见对象的描述），空的列表或对象将会返回空的结果对象。要获得存储的所有内容，请传递 null。 
	 - 当指定为 Obj 时, 其实只取 Obj 的 key 值,忽略对应的 value
	
	callback: 包含存储项目或者表示失败（这种情况下会设置 runtime.lastError）的回调函数。
	 - items: 包含按键-值映射的项目对象。
	*/
	@:overload(function(callback : Dynamic->Void ):Void{})
	function get(keys: Dynamic, ?callback : Dynamic->Void ) : Void;
	
	/**
	获得一个或多个项目正在使用的空间大小（以字节为单位）。
	
	key: 要获得总计使用空间的单个键或多个键的列表，空的列表或对象将会返回 0。要获得所有存储占用的总空间，请传递 null。
	
	callback: 回调函数，将传递存储占用的空间大小，或者指示失败（这种情况下将会设置 runtime.lastError）
	 - byteInUse: 正在使用的存储空间大小，以字节为单位。
	*/
	
	@:overload(function(callback : Int->Void ):Void{})
	@:overload(function( keys : Array<String>, callback : Int->Void ):Void{})
	function getBytesInUse( keys : String, callback : Int->Void ) : Void;
	
	/**
	设置多个项目。 
	
	```js
	.set({someKey:"anyvalue"},function(){console.log("done")});
	//.....
	.get("someKey",function(obj){console.log(obj)}) // output: {someKey: "anyValue"}
	```
	*/
	function set( items : Dynamic, ?callback : Void->Void ) : Void;
	
	/**
	从存储中移除一个或多个项目。 
	*/
	@:overload(function( keys : Array<String>, ?callback : Void->Void ):Void{})
	function remove( keys : String, ?callback : Void->Void ) : Void;
	
	/**
	从存储中删除 **所有** 值。 
	*/
	function clear( ?callback : Void->Void ) : Void;
}

/**
 
*/
@:enum abstract StorageAreaName(String) from String to String {
	var sync = "sync";
	var local = "local";
	var managed = "managed";
}

/**
使用 chrome.storage API 存储、获取用户数据，追踪用户数据的更改。 

可用版本: chrome 20+

权限: "storage"

内容脚本: 完全支持

这一 API 为应用的存储需要而特别优化，它提供了与 localStorage API 相同的能力，但是具有如下几个重要的区别：

 * 您的应用的内容脚本可以直接访问用户数据，而不需要后台页面。(可以一个页面监听而另一个页面值的改动也会触发改动)
 * 即使使用[分离式隐身行为](http://chajian.baidu.com/developer/extensions/manifest/incognito.html)，用户的应用设置也会保留。
 * 它是异步的，并且能够进行大量的读写操作，因此比阻塞和串行化的 localStorage API 更快。
 * 用户数据可以存储为对象（localStorage API 以字符串方式存储数据）。
 * 可以读取管理员为应用配置的企业策略（使用 storage.managed 和[架构](http://chajian.baidu.com/developer/extensions/manifest/storage.html)）。
 
**不应该储存机密的用户信息！存储区没有加密**

#### 存储空间与调用频率限制

chrome.storage 并不像一辆大卡车那样，而是像一系列的管道，如果您不理解这一点的话，这样的管道很容易被填满。如果当您存入消息时它们填满了，它将会变成细线，任何人向其中存入大量数据都有可能使操作产生延迟。

有关目前对存储 API 的限制以及超出限制的结果，请参见 [local](http://chajian.baidu.com/developer/extensions/storage.html#local-properties) 的配额信息。

[更多中文文档...](http://chajian.baidu.com/developer/extensions/storage.html)
*/
@requiresChromePermissions("storage")
@:require(chrome)
@:native("chrome.storage")
extern class Storage {

	/**
	一些机器可能不一致
	 - MAX_ITEMS: 512个
	 - QUOTA_BYTES: 100K
	 - QUOTA_BYTES_PER_ITEM: 8K
	
	*/
	static var sync(default,never) : StorageArea;
	
	/**
	位于 local（本机）存储区下的项目仅对每一台计算机有效。使用 "unlimitedStorage" 获得无限空间
	
	QUOTA_BYTES = 5,242,880
	*/
	static var local(default,never) : StorageArea;
	
	/**
	chrome 33+
	
	managed 存储区中的项目由域管理员设置，对应用来说只读，尝试修改这一命名空间会导致错误。 
	*/
	static var managed(default,never) : StorageArea;
	
	/**
	当一个或多个项目更改时产生
	 - changes: StorageChange 对象。
	 - areaName: StorageAreaName
	*/
	static var onChanged(default,never) : Event<Dynamic->String->Void>;
}
