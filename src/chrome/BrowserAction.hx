package chrome;

import haxe.extern.EitherType;
import js.html.ImageData;
import chrome.Events;
import chrome.Tabs;

typedef ColorArray = Array<Int>;

/**
browserAction

可用版本: Chrome 5+

manifest.json: `"browser_action":{}`

如果您想创建一个不是永远可见的图标，请使用 "PageAction"，而不是 "browserAction"。

```json
{
	"browser_action": {
		"default_icon": {					// optional
			"19": "images/icon19.png",			// optional
			"38": "images/icon38.png",			// optional
		},
		"default_title": "Google Mail",		// optional
		"default_popup": "popup.html"		// optional
	}
}
```

browserAction 可以包括: 更多细节查看 http://chajian.baidu.com/developer/extensions/browserAction.html#badge

 - icon: "default_icon" 
 - tooltip 即 "default_title" 所对应的字符。
 - badge 显上在 icon 上的一小段文字, 它不应该超过 4 个字符。
 - popup: 点击 icon 时弹出 "default_popup" 所指定的页面。

*/
@:require(chrome_ext)
@:native("chrome.browserAction")
extern class BrowserAction {
	/**
	更改 default_title
 
	title: 当鼠标移到浏览器按钮上时应显示的字符串
	
	tabId: 将更改限制在当某一特定标签页选中时应用，当该标签页关闭时，更改的内容自动恢复
	*/
	static function setTitle( details : { title : String, ?tabId : Int } ) : Void;
	
	/**
	tabId: 指定要获取 title 的标签页(tab)。如果没有指定标签页，则返回用于所有标签页的标题
	
	callback: 第一个参数为返回的 title
	*/
	static function getTitle( details : { ?tabId : Int  }, callback : String->Void ) : Void;
	
	/**
	path : {"19" : "images/icons/green.png"} or `path: "images/icons/green19.png"`
	*/
	static function setIcon( details : { ?imageData : EitherType<ImageData,{}>, ?path : EitherType<String,{}>, ?tabId : Int }, ?callback : Void->Void ) : Void;
	
	/**
	显示在弹出内容中的 HTML 文件，如果设置为空字符串（""）则不显示弹出内容 
	*/
	static function setPopup( details : { ?tabId : Int, popup : String } ) : Void;
	static function getPopup( details : { ?tabId : Int  }, callback : String->Void ) : Void;
	
	static function setBadgeText( details : { text : String, ?tabId : Int } ) : Void;
	static function getBadgeText( details : { ?tabId : Int  }, callback : String->Void ) : Void;
	
	/**
	设置徽章的背景颜色。 RGBA 。e.g: [255, 0, 0, 255]
	*/
	static function setBadgeBackgroundColor( details : { color : ColorArray, ?tabId : Int } ) : Void;
	static function getBadgeBackgroundColor( details : { ?tabId : Int  }, callback : ColorArray->Void ) : Void;
	
	/**
	为某一标签页启用浏览器按钮。默认情况下，浏览器按钮是启用的。 chrome 22+ 
	*/
	static function enable( ?tabId : Int ) : Void;
	
	/**
	为某一标签页禁用浏览器按钮。 chrome 22+ 
	*/
	static function disable( ?tabId : Int ) : Void;

	/**
	浏览器按钮的图标单击时产生，如果浏览器按钮有弹出内容则不会触发该事件。 
	*/
	static var onClicked(default,never) : Event<Tab->Void>;

}
