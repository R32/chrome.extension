package chrome;

import chrome.Events;

@:enum abstract ChromeSettingScope(String) from String to String {
	/**
	用于普通用户配置文件（如果没有被其他地方的设置覆盖，也将由隐身窗口继承）；
	*/
	var regular = "regular";
	/**
	仅用于普通用户配置文件（不被隐身配置文件继承）；
	*/	
	var regular_only = "regular_only";
	/**
	用于隐身配置文件的设置，并且在浏览器重启后仍保留（覆盖 "regular" 设置）；
	*/	
	var incognito_persistent = "incognito_persistent";
	/**
	用于隐身配置文件的设置，并且只能在隐身会话中设置，在隐身会话结束时删除（覆盖 "regular" 和 "incognito_persistent" 设置）。
	*/	
	var incognito_session_only = "incognito_session_only";
}

@:enum abstract LevelOfControl(String) from String to String {
	/**
	无法由任何应用控制 
	*/	
	var not_controllable = "not_controllable";
	/**
	由优先级更高的应用控制 
	*/	
	var controlled_by_other_extensions = "controlled_by_other_extensions";
	/**
	可以由该应用控制 
	*/	
	var controllable_by_this_extension = "controllable_by_this_extension";
	/**
	由该应用控制 
	*/	
	var controlled_by_this_extension = "controlled_by_this_extension";
}

/**
http://chajian.baidu.com/developer/extensions/types.html 
*/
@:require(chrome)
@:native("chrome.types.chromeSetting")
extern class ChromeSetting {
	/**
	获得设置的值
	
	details: 
	 - incognito: 返回是否用于隐身会话的值（默认为 false）
	*/	
	function get( details : {?incognito:Bool}, callback : {value:Dynamic,levelOfControl:LevelOfControl,?incognitoSpecific:Bool}->Void ) : Void;
	
	/**
	修改设置的值 
	*/
	function set( details : { value:Dynamic, ?scope:ChromeSettingScope }, ?callback : Void->Void ) : Void;
	
	/**
	清除设置，恢复默认值 
	*/
	function clear( details : {?scope:ChromeSettingScope}, ?callback : Void->Void ) : Void;
	
	/**
	设置更改后产生 
	*/
	var onChange : Event<{value:Dynamic,levelOfControl:LevelOfControl,?incognitoSpecific:Bool}->Void>;
}
