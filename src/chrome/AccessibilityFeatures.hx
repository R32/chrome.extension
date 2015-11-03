package chrome;

import chrome.Types;

/**
管理 Chrome 浏览器的辅助功能

可用版本: chrome 37+, 警告: 目前为 Beta 分支

权限: "accessibilityFeatures.read","accessibilityFeatures.modify"
*/
@:require(chrome)
@:native("chrome.accessibilityFeatures")
extern class AcessibilityFeatures {
	static var spokenFeedback(default,never) : ChromeSetting;
	static var largeCursor(default,never) : ChromeSetting;
	static var stickyKeys(default,never) : ChromeSetting;
	static var highContrast(default,never) : ChromeSetting;
	static var screenMagnifier(default,never) : ChromeSetting;
	static var autoclick(default,never) : ChromeSetting;
	static var virtualKeyboard(default,never) : ChromeSetting;
}
