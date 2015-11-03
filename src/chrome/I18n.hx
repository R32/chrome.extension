package chrome;

/**
[国际化支持](http://chajian.baidu.com/developer/extensions/i18n.html)

可用版本: chrome 5+

内容脚本: [完全支持](http://chajian.baidu.com/developer/extensions/content_scripts.html)
*/
@:require(chrome)
@:native("chrome.i18n")
extern class I18n {
	/**
	获取浏览器可接受的语言, e.g: `["zh-CN","zh","en"]`
	*/
	static function getAcceptLanguages( callback : Array<String>->Void ) : Void;
	
	/**
	获得指定消息的本地化字符串。如果消息不存在，该方法返回空字符串（""）。如果 getMessage() 的调用格式不正确，例如，messageName 不是字符串或者 substitutions 数组为空或包含的元素超过 9 个，该方法返回 undefined。 
	
	关于 substitutions 占位符需要先了解 http://chajian.baidu.com/developer/extensions/i18n-messages.html
	*/
	static function getMessage( messageName : String, ?substitutions : Dynamic ) : String;
	
	/**
	获取浏览器用户界面的语言。e.g: "zh-CN" 
	*/
	static function getUILanguage() : String;
}
