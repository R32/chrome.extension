package chrome;

import chrome.Events;

/**
代表书签树中的一个节点（书签或文件夹），子节点在它们的父文件夹中按顺序排列
 - id: 节点的唯一标识符。唯一标识符在当前用户配置文件中保证唯一，并且在浏览器重新启动后仍然有效
 - parentId: 父节点的标识符。根节点没有此属性
 - index: 该节点在父文件夹中的位置（从 0 开始）
 - url: 当用户单击书签时打开的URL。文件夹没有此属性
 - title: 该节点显示的文字
 - dateAdded: 该节点创建的时间，表示为自 1970 年 1 月 1 日午夜至今所经过的毫秒数
 - dateGroupModified: 该文件夹内容的上一次修改时间
 - children: 该节点的所有子节点（已排序）
*/
typedef BookmarkTreeNode = {
	var id : String;
	@:optional var parentId : Null<String>;
	@:optional var index : Int;
	@:optional var url :  String;
	var title : String;
	@:optional var dateAdded : Float;
	@:optional var dateGroupModified : Float;
	@:optional var children : Array<BookmarkTreeNode>;
}

typedef BookmarkDestination = {
	@:optional var parentId : String;
	@:optional var index : Null<Int>;
}

typedef BookmarkChanges = {
	@:optional var title : String;
	@:optional var url : String;
}

typedef BookmarkChangeInfo = {
	var title : String;
	@:optional var url : Null<String>;
}

/**
用于创建书签
 - parentId: 默认为“其他书签”文件夹
 - index: 
 - title: 
 - url: 如果 url 为 null 或者省略，则创建文件夹
*/
typedef Bookmark = {
	@:optional var parentId : String;
	@:optional var index : Int;
	@:optional var title : String;
	@:optional var url : String;
}

typedef BookmarkReorderInfo = {
	var childIds : Array<String>;
}

typedef BookmarkMoveInfo = {
	var parentId : String;
	var index : Int;
	var oldParentId : Int;
	var oldIndex  : Int;
}

typedef BookmarkRemoveInfo = {
	var parentId : String;
	var index : Int;
}

/**
创建、组织或通过其他方式操纵书签，另外请参见[替代页面](https://crxdoc-zh.appspot.com/extensions/override)，通过它您可以创建一个自定义的书签管理器页面

可用版本: chrome 5+

权限: "bookmarks"

---

书签以"树"的形式组织, "树"中的每个节点为一个书签或文件夹, 每一个节点使用 BookmarkTreeNode 表示.

注意：您不可以使用这API 在根文件夹中添加或删除项目，您也不能重命名、移动或删除特殊的“书签栏”和“其他书签”文件夹。
*/
@:require(chrome_ext)
@:native("chrome.bookmarks")
extern class Bookmarks {
	
	/**
	从 Chrome 38 开始弃用。Chrome 浏览器不再限制书签写入操作 
	*/
	static var MAX_WRITE_OPERATIONS_PER_HOUR(default, never) : Int;
	
	/**
	从 Chrome 38 开始弃用。Chrome 浏览器不再限制书签写入操作 
	*/
	static var MAX_SUSTAINED_WRITE_OPERATIONS_PER_MINUTE(default,never) : Int;
	
	/**
	获得指定的书签树节点. 
	*/
	@:overload(function( ?idList:Array<String>, callback : Array<BookmarkTreeNode>->Void ) : Void {} )
	static function get( id : String, callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	获取指定书签树节点的所有子节点 
	*/
	static function getChildren( id : String, callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	获取最近添加的几个书签 
	*/
	static function getRecent( numberOfItems : Int, callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	获取整个书签树 
	*/
	static function getTree( callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	获取从指定节点开始的部分书签树 
	*/
	static function getSubTree( id : String, callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	搜索书签树节点，找出匹配的结果。如果以"对象"方式指定查询，得到的 BookmarkTreeNodes 匹配所有指定的属性
	
	query: 可以指定字符串，包含单词和加上引号的短语，用于匹配书签 URL 和标题。也可以指定对象，其中可以指定 query、url 和 title 属性，返回匹配所有指定属性的书签
	*/
	@:overload(function(query:{?url:String,?title:String,?query:String}, callback : Array<BookmarkTreeNode>->Void):Void{})
	static function search( query : String, callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	在指定的上一级文件夹下创建新的书签或文件夹。如果 url 为 null 或者省略，则创建文件夹 
	*/
	static function create( bookmark : Bookmark, ?callback : BookmarkTreeNode->Void ) : Void;
	
	/**
	将指定的书签树节点移到指定位置 
	*/
	static function move( id : String, destination : BookmarkDestination, ?callback : BookmarkTreeNode-> Void ) : Void;
	
	/**
	更新书签或文件夹的属性。只需要指定您需要更改的属性，未指定的属性不会更改。注意：目前只支持“title”和“url”属性 
	*/
	static function update( id : String, changes : BookmarkChanges, ?callback : Array<BookmarkTreeNode>->Void ) : Void;
	
	/**
	删除书签或者空文件夹 
	*/
	static function remove( id : String, ?callback : Void->Void ) : Void;
	
	/**
	删除整个书签文件夹 
	*/
	static function removeTree( id : String, ?callback : Void->Void ) : Void;
	
	/**
	当书签或文件夹创建时产生 
	*/
	static var onCreated(default,never) : Event<String->BookmarkTreeNode->Void>;
	
	/**
	当删除书签或文件夹时产生。当删除整个文件夹（包括其中所有内容）时，仅为该文件夹发送通知，不为其中任何内容发送通知 
	*/
	static var onRemoved(default,never) : Event<String->BookmarkRemoveInfo->Void>;
	
	/**
	一个书签或文件夹更改时发生。注意：目前只有标题和URL更改时会触发这一事件 
	*/
	static var onChanged(default,never) : Event<String->BookmarkChangeInfo->Void>;
	
	/**
	当书签或文件夹移动到另一个父文件夹中时产生。 
	*/
	static var onMoved(default,never) : Event<String->BookmarkMoveInfo->Void>;
	
	/**
	文件夹中的子节点在用户界面中调整顺序时产生。调用 move() 不会触发该事件 
	*/
	static var onChildrenReordered(default, never) : Event<String->BookmarkReorderInfo->Void>;
	
	/**
	开始导入书签时产生。复杂的事件处理函数在这一事件产生后不应该再处理 onCreated 事件，直到 onImportEnded 事件产生，在此过程中其他事件仍然应该立即处理。 
	*/
	static var onImportEnded(default,never) : Event<Void->Void>;
	
	/**
	书签导入结束时产生 
	*/
	static var onImportBegan(default,never) : Event<Void->Void>;
}
