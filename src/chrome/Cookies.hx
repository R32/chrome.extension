package chrome;

import chrome.Events;

typedef Cookie = {
	var name : String;
	var value : String;
	var domain : String;
	var hostOnly : Bool;
	var path : String;
	var secure : Bool;
	var httpOnly : Bool;
	var session : Bool;
	@:optional var expirationDate : Float;
	var storeId : String;
}

/**
代表浏览器中的一个 Cookie 存储区。例如隐身窗口使用与非隐身窗口不同的单独的 Cookie 存储区 
*/
typedef CookieStore = {
	var id : String;
	var tabIds : Array<Int>;
}

/** 
 - evicted: 由于垃圾收集自动删除
 - expired: 过期
 - explicit: 添加 Cookie
 - expired_overwrite: 由于过期被自动删除
 - overwrite: 由于 cookies.set 方法的调用被覆盖而自动删除
*/
@:enum abstract OnChangedCause(String) from String to String {
	var evicted = "evicted";
	var expired = "expired";
	var explicit = "explicit";
	var expired_overwrite = "expired_overwrite";
	var overwrite = "overwrite";
}

/**
[chrome.cookies](http://chajian.baidu.com/developer/extensions/cookies.html#method-getAllCookieStores)

可用: chrome 6+

权限: "cookies" + 以及用于访问 cookie 的[主机权限](http://chajian.baidu.com/developer/extensions/declare_permissions.html)
*/
@:require(chrome_ext)
@:native("chrome.cookies")
extern class Cookies {
	/**
	获得单个 Cookie 的有关信息。如果给定的 URL 具有多个名称相同的 Cookie，将返回路径最长的一个。如果路径长度相同，将返回创建时间最早的一个 
	*/
	static function get( details : { url : String, name : String, ?storeId : String }, callback : ?Cookie->Void ) : Void;
	
	/**
	返回一个 Cookie 存储区中符合给定条件的所有 Cookie。返回的 Cookie 将按照路径长度从大到小排序，如果多个 Cookie 的路径长度相等，则创建时间最早的排在最前面。 
	*/
	static function getAll( details : { ?url : String, ?name : String, ?domain : String, ?path : String, ?secure : Bool, ?session : Bool, ?storeId : String }, callback : Array<Cookie>->Void ) : Void;
	
	/**
	用给定的数据设置 Cookie，如果同样的 Cookie 已存在则会覆盖。 
	*/
	static function set( details : { url : String, ?name : String, ?value : String, ?domain : String, ?path : String, ?secure : Bool, ?httpOnly : Bool, ?expirationDate : Float, ?storeId : String }, callback : ?Cookie->Void ) : Void;
	
	static function remove( details : { url : String, name : String, ?storeId : String }, callback : { url:String, name:String, storeId:String }->Void ) : Void;
	
	/**
	所有存在的 CookieStore 
	*/
	static function getAllCookieStores( callback : Array<CookieStore>->Void ) : Void;
	
	/**
	当 Cookie 设置或删除时产生。注意更新 Cookie 的属性为特殊情况，实现为两步的过程：首先将要更新的 Cookie 完全删除，产生 cause 属性为 "overwrite"（覆盖）的通知；然后，新的 Cookie 用更新后的值写入，产生 cause 属性为 "explicit" 的第二个通知。 
	*/
	static var onChanged(default,never) : Event<(Bool->Cookie->OnChangedCause)->Void>;
}
