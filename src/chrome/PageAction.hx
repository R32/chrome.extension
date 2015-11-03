package chrome;

import haxe.extern.EitherType;
import js.html.ImageData;
import chrome.Events;
import chrome.Tabs;

/**
在地址栏中添加图标。页面按钮代表用于当前网页的操作

可用版本: chrome 5+

清单文件: "page_action":{...}

```js
{
	"name": "我的应用",
	...
	"page_action": {
		"default_icon": {                    // 可选
			"19": "images/icon19.png",           // 可选
			"38": "images/icon38.png"            // 可选
		},
		"default_title": "Google Mail",      // 可选，在工具提示中显示
		"default_popup": "popup.html"        // 可选
	},
        ...
}
```

详情: http://chajian.baidu.com/developer/extensions/pageAction.html

也许你应该同时参考一下 [声明式内容](http://chajian.baidu.com/developer/extensions/declarativeContent.html)
*/
@:require(chrome_ext)
@:native("chrome.pageAction")
extern class PageAction {
	/**
	显示页面按钮图标，页面按钮在指定的标签页选定时显示 
	*/
	static function show( tabId : Int ) : Void;
	static function hide( tabId : Int ) : Void;
	static function setTitle( details : { tabId : Int, title : String } ) : Void;
	static function getTitle( details : { tabId : Int }, callback : String->Void ) : Void;
	/**
	设置页面按钮的图标。图标既可以指定为图片文件的路径，也可以指定来自 canvas 元素的像素数据，或者这两者中任意一个的词典。path 或 imageData 属性中有且只有一个必须指定 
	
	
	*/
	static function setIcon( details : { tabId : Int, ?imageData: EitherType<ImageData,{}>, ?path: EitherType<String,{}>, ?iconIndex : Int }, ?callback : Void->Void ) : Void;
	
	/**
	显示在弹出内容中的 HTML 文件。如果设为空字符串（""），则不显示弹出内容。 
	*/
	static function setPopup( details : { tabId : Int, popup : String } ) : Void;
	
	static function getPopup( details : { tabId : Int }, callback : String->Void ) : Void;	
	/**
	页面按钮的图标单击时产生，如果页面按钮有弹出内容则不会触发该事件。 
	*/
	static var onClicked(default,never) : Event<Tab->Void>;

}
