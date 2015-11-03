package chrome;

import chrome.Events;

/**

*/
typedef PermissionsData = {
	/**
	权限名称列表（不包括主机权限）。此处列出的所有权限都必须在清单文件的 optional_permissions 列表中出现。  
	*/
	@:optional var permissions : Array<String>;
	
	/**
	主机权限列表。此处列出的所有权限都必须为清单文件 optional_permissions 列表中出现的主机子集。例如，如果 `http://*.example.com/` 或 `http://* /` 包含在 optional_permissions 中，您可以请求 `http://help.example.com/` 来源。路径部分忽略。 
	*/
	@:optional var origins : Array<String>;
}

/**
在运行时而不是安装时请求声明的可选权限,这样用户可以理解为什么需要这些权限，并且仅在必要时授予这些权限。 

可用版本: chrome 16+

[声明权限](http://chajian.baidu.com/developer/extensions/declare_permissions.html)

详细: http://chajian.baidu.com/developer/extensions/permissions.html

 - 确定哪些权限是必选的，哪些是可选的
 - 在清单文件中声明可选权限
	```js
	{
		"name": "我的应用",
		...
		"optional_permissions": [ "tabs", "http://www.google.com/" ],
		...
	}	
	```
 - 请求可选权限, 使用 permissions.request
 - 检查应用的当前权限, permission.contains
 - 移除权限,permission.remove 当移除之后财次请求可选权限将不会再次通知用户确认
*/
@:require(chrome)
@:native("chrome.permissions")
extern class Permissions {
	/**
	获得应用当前拥有的所有权限。 
	*/
	static function getAll( callback : PermissionsData->Void ) : Void;
	
	/**
	检查应用是否拥有指定权限。 
	*/
	static function contains( permissions : PermissionsData, callback : Bool->Void ) : Void;
	
	/**
	请求访问指定的权限，这些权限必须已在清单文件中的 optional_permissions 字段中定义。如果请求权限过程中发生任何问题，将会设置 runtime.lastError。 
	*/
	static function request( permissions : PermissionsData, ?callback : Bool->Void ) : Void;
	
	/**
	移除指定权限的访问。如果移除权限过程中发生任何问题，将会设置 runtime.lastError。 
	*/
	static function remove( permissions : PermissionsData, ?callback : Bool->Void ) : Void;
	
	/**
	应用获得新权限时产生 
	*/
	static var onAdded(default, never) : Event<PermissionsData->Void>;
	
	/**
	对权限的访问从应用移除时产生 
	*/
	static var onRemoved(default,never) : Event<PermissionsData->Void>;
}
