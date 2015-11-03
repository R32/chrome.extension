package chrome;

import haxe.extern.EitherType;
import chrome.Events;
import chrome.Tabs;

@:enum abstract ItemType(String) from String to String {
	var normal = "normal";
	var checkbox = "checkbox";
	var radio = "radio";
	var separator = "separator";
}

/**
菜单项将会出现在哪些上下文中, 默认为 page

 - all: 全部, 不包括 app 加载页面.
 - page: 页面
 - frame: 框架
 - selection: 选定内容
 - link: 链接
 - editable: 可编辑区域
 - image: 图片
 - video: 视频
 - audio: 音频
*/
@:enum abstract ContextType(String) from String to String {
	var all = "all";
	var page = "page";
	var frame = "frame";
	var selection = "selection";
	var link = "link";
	var editable = "editable";
	var image = "image";
	var video = "video";
	var audio = "audio";
	var launcher = "launcher";
}

/**
[右键菜单](http://chajian.baidu.com/developer/extensions/contextMenus.html)

可用版本: chrome 6+

权限: "contextMenus"
*/
@:require(chrome)
@:native("chrome.contextMenus")
extern class ContextMenus {

	static var ACTION_MENU_TOP_LEVEL_LIMIT(default,never) : Int;

	static function create(
		createProperties : {
			?type : ItemType,
			?id : String,
			?title : String,
			?checked : Bool,
			?contexts: Array<ContextType>,
			?onclick : {
				menuItemId : EitherType<Int,String>,
				?parentMenuItemId : EitherType<Int,String>,
				?mediaType : String,
				?linkUrl : String,
				?srcUrl : String,
				?pageUrl : String,
				?frameUrl : String,
				?selectionText : String,
				editable : Bool,
				?wasChecked : Bool,
				?checked : Bool,
			}->Tab->Void,
			?parentId : Int,
			?documentUrlPatterns : Array<String>,
			?targetUrlPatterns : Array<String>,
			?enabled : Bool
		},
		?callback : Void->Void ) : Void;
	
	/**
	更新以前创建的菜单项 
	*/
	static function update(
		id : EitherType<Int,String>,
		updateProperties : {
			?type : ItemType,
			?title : String,
			?checked : Bool,
			?contexts : Array<ContextType>,
			?onclick : {
					menuItemId : EitherType<Int,String>,
					?parentMenuItemId : EitherType<Int,String>,
					?mediaType : String,
					?linkUrl : String,
					?srcUrl : String,
					?pageUrl : String,
					?frameUrl : String,
					?selectionText : String,
					editable : Bool,
					?wasChecked : Bool,
					?checked : Bool
				}->Tab->Void,
			?parentId : Int,
			?documentUrlPatterns : Array<String>,
			?targetUrlPatterns : Array<String>,
			?enabled : Bool
		},
		?callback : Void->Void ) : Void;

	static function remove( menuItemId : EitherType<Int,String>, ?callback : Void->Void ) : Void;
	static function removeAll( ?callback : Void->Void ) : Void;

	static var onClicked(default,never) : Event<{
			menuItemId : EitherType<Int,String>,
			?parentMenuItemId : EitherType<Int,String>,
			?mediaType : String,
			?linkUrl : String,
			?srcUrl : String,
			?pageUrl : String,
			?frameUrl : String,
			?selectionText : String,
			editable : Bool,
			?wasChecked : Bool,
			?checked : Bool
		}->?Tab->Void>;
}
