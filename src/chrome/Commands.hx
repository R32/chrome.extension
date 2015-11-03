package chrome;

import chrome.Events;

/**
通过 getAll 获得的单个"命令"
*/
typedef Command = {
	@:optional var name : String;
	@:optional var description : String;
	@:optional var shortcut : String;
}

/**
添加快捷键，以便触发应用中的操作。通过在 manifest.json 中指定 `"commands":{}`, 并且 manifest_version 至少设置为 2

可用版本: Chrome 35+ 

命令 API 允许您定义特定的命令，并为它们绑定默认的组合键。您的应用接受的每一个命令都必须在 manifest.json 文件中列出，作为 'commands' 键的属性。应用可以包含很多命令，但是只能指定四个推荐的按键。用户可以在 chrome://extensions/configureCommands 对话框中手动添加更多的快捷键。

支持的按键包括：A～Z、0～9、逗号、句号、Home、End、PageUp、PageDown、Insert、Delete、方向键（上、下、左、右）和多媒体键（上一曲（MediaPrevTrack）、下一曲（MediaNextTrack）、播放/暂停（MediaPlayPause）、停止（MediaStop））。

注意：所有组合键必须包含 Ctrl 或 Alt 中的一个，不允许使用涉及到 Ctrl+Alt 的组合键，以免与 AltGr 键冲突。除了 Alt 或 Ctrl 外还可以使用 Shift 键，但不是必须使用。组合键（例如 Ctrl）不能与多媒体按键一起使用。出于辅助功能的原因，从 Chrome 33 开始不支持 Tab 键。

 - 另外请注意，在 Mac 中 Ctrl 会自动转换为 Command 键。如果您希望使用 Ctrl，请指定“MacCtrl”。

 
 - 此外，在 Chrome OS 中您还可以指定“搜索”组合键

浏览器的某些快捷键(例如窗口管理)优先级始终比应用命令的快捷键高，不能被覆盖。example:


```js
{
	"name": "我的应用",

	......
	
	"commands": {
		"toggle-feature-foo": {
			"suggested_key": {
				"default": "Ctrl+Shift+Y",
				"mac": "Command+Shift+Y"
			},
			"description": "切换 foo 特性"
		},

		"_execute_browser_action": {
			"suggested_key": {
				"windows": "Ctrl+Shift+Y",
				"mac": "Command+Shift+Y",
				"chromeos": "Ctrl+Shift+U",
				"linux": "Ctrl+Shift+J"
			}
		},
		
		"_execute_page_action": {
			"suggested_key": {
				"default": "Ctrl+Shift+E",
				"windows": "Alt+Shift+P",
				"mac": "Alt+Shift+P"
			}
		},
		
		"cmdNew": {
			"suggested_key": {
				"default": "Ctrl+Shift+1"
			},
			"global": true,
			"description": "Create new window"
		}		
	}
}
```

在页面中可以通过 onCommand.addListener 为 manifest.json 文件中定义的每个命令绑定函数(除了_execute_browser_action 和 _execute_page_action)

```js
chrome.Commands.onCommand.addListener(function(cmd){
	trace("Command: " + cmd);
});
```

'_execute_browser_action'（执行浏览器按钮）与 '_execute_page_action'（执行页面按钮）命令为打开您的应用的弹出内容而保留，它们通常不会产生您可以处理的事件。如果您需要在弹出内容打开时进行处理，考虑在弹出内容的代码中监听 'onDomReady' 事件。

"global", 默认(值为 false)情况下当浏览器没有焦点时, 快捷键将不活动。

用户可以在 chrome://extensions > 快捷键用户界面中使用任意快捷键作为全局快捷键，但是应用开发者在全局快捷键中只能指定 Ctrl+Shift+[0..9]。这样是为了尽可能避免与其他应用程序中的快捷键重复，例如，如果允许将 Alt+P 作为全局快捷键，其他应用程序中的打印快捷键就不能正常使用。

*/
@:require(chrome)
@:native("chrome.commands")
extern class Commands {
	/**
	返回当前应用注册的所有应用命令以及它们的快捷键（如果处于活动状态的话） 
	*/
	static function getAll( ?callback : Array<Command>->Void ) : Void;
	
	/**
	当注册的命令通过快捷键激活时产生 
	*/
	static var onCommand(default,never) : Event<String->Void>;
}
