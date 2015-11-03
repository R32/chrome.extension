package chrome;

import js.html.ImageData;
import haxe.extern.EitherType;
import chrome.Events;

/**
条件.通过各种条件匹配网页的状态
*/
@:native("chrome.declarativeContent.PageStateMatcher")
extern class PageStateMatcher {	
	public var pageUrl:UrlFilter;
	public var css:Array<String>;
	public function new(?conf: {
		?pageUrl:UrlFilter, 
		?css:Array<String>
	});
}

/**
动作，当相应的条件满足时显示应用的页面按钮。使用该操作不需要主机权限，但是应用必须要有页面按钮。如果应用拥有 activeTab 权限，单击页面按钮就会授予对活动标签页的访问权限。
*/
@:native("chrome.declarativeContent.ShowPageAction")
extern class ShowPageAction {
	public function new();
}

/**
动作
*/
@:native("chrome.declarativeContent.SetIcon")
extern class SetIcon {
	public var imageData : {};	
	/**
	imageData 或 path 必须指定其中的一个, path 除了指定为相应类型还可以用 `{19: "imageData|String"}` 的方式指定
	*/
	public function new(conf: {
		?imageData:EitherType<ImageData,{}>,
		?path:EitherType<String,{}>
	});
}

/**
动作
*/
@:native("chrome.declarativeContent.RequestContentScript")
extern class RequestContentScript {
	public var css : Array<String>;
	public var js : Array<String>;
	public var allFrames : Bool;
	public var matchAboutBlank : Bool;
	
	public function new( ?conf:{
		?css:Array<String>,
		?js : Array<String>,
		?allFrames : Bool,
		?matchAboutBlank : Bool
	});
}

/**
根据网页内容进行某些操作，而不需要读取网页内容的权限。 

可用版本: chrome 33+

权限: "declarativeContent"

了解更多 [声明事件](http://chajian.baidu.com/developer/extensions/events.html), [activeTab](http://chajian.baidu.com/developer/extensions/activeTab.html)

### 用法

声明式内容 API 允许您根据网页的 URL 和它的内容匹配的 CSS 选择器来显示您的应用的页面按钮，而不需要拥有主机权限或插入内容脚本。为了在用户单击您的页面按钮后能够与网页交互，请使用 activeTab 权限。

[更多内容...](http://chajian.baidu.com/developer/extensions/declarativeContent.html)
*/
@:require(chrome_ext)
@:native("chrome.declerativeContent")
extern class DeclerativeContent {
	/**
	提供声明式事件 API，包括 addRules、removeRules 和 getRules。 
	*/
	static var onPageChanged(default,never) : Event<Dynamic>; //TODO
}
