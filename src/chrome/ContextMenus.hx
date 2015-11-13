package chrome;

import haxe.extern.EitherType;
import chrome.Events;
import chrome.Tabs;

/**
菜单项的类型,如果没有指定则默认为 normal
 - normal: 普通
 - checkbox: 选中或不选
 - radio: 在几个选项中至少选一个
 - separator: 分隔线
*/
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
	
	/**
	
	createProperties:
	 - type: ItemType
	 - id: chrome 21,指派给该菜单项的唯一标志符，对于事件页面来说必须存在，不能与同一应用中的其他标志符相同
	 - title: 显示在菜单项中的文字，除非 type（类型）是 'separator'（分隔符），该参数是必选的。当上下文为 'selection'（选定内容）时，您可以在字符串中使用 %s 来显示选中的文本。例如，如果参数值是“将‘%s’翻译为儿童黑话”，当用户选择一个词语“酷”时，对于选中内容的右键菜单项为“将‘酷’翻译为儿童黑话”。
	 - checked: 单选或复选菜单项的初始状态：选定为 true，未选定为 false。在一组单选菜单项中，一次只能有一项选定。
	 - contexts: ContextType
	 - onclick: 当菜单项单击时的回调函数。事件页面不能使用该属性，相反，它们应该为 chrome.contextMenus.onClicked 注册事件处理函数
	  - info: 有关单击发生时的菜单项和上下文的信息。
	  - tab: 单击发生的标签页详情
	 - parentId: 父菜单项标识符，指定这一参数使新添加的菜单项成为原先添加菜单项的子菜单项。
	 - documentUrlPatterns: 让您将该菜单项限制在 URL 匹配给定表达式的文档中显示。（也适用于框架。）有关表达式的格式的详情，请参见匹配表达式。
	 - targetUrlPatterns: 类似于 documentUrlPatterns，但是允许您基于 /
	 - enabled: 该右键菜单项是启用还是禁用，默认为 true。
	
	callback: 当菜单项已经在浏览器中创建后调用。如果创建过程中出现任何错误，详情可从 runtime.lastError 获得
	*/
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
		?callback : Void->Void ) : EitherType<Int,String>;
	
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
