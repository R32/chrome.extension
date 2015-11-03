package chrome;

/**
使用资源标识符的内容类型只有 contentSettings.plugins（插件）。有关更多信息，请参见[资源标识符](https://crxdoc-zh.appspot.com/extensions/contentSettings#resource-identifiers)。
 - id: 给定内容类型的资源标识符
 - description: 可读性较好的资源描述
*/
typedef ResourceIdentifier = {
	var id : String;
	@:optional var description : String;
}

/**
哪些范围:
 - regular: 用于普通配置文件的设置（如果没有另外覆盖的话也将由隐身配置文件继承）
 - incognito_session_only: （仅用于隐身会话）：用于隐身配置文件的设置，只能在隐身会话中设置，并且在隐身会话结束时删除（覆盖普通设置）
*/
@:enum abstract Scope(String) from String to String{
	var regular = "regular";
	var incognito_session_only = "incognito_session_only";
}

/**
API 更改设置，控制网站能否使用 Cookie、JavaScript 和插件之类的特性。大体上说，内容设置允许您针对不同的站点（而不是全局地）自定义 Chrome 浏览器的行为。 

可用版本: chrome 16+

权限: "contentSettings"

### 内容设置的匹配表达式

您可以使用匹配表达式来指定每一项内容设置将会影响哪些网站。例如，http://*.youtube.com/* 指定 youtube.com 以及所有子域名。用于内容设置的匹配表达式语法与一般的匹配表达式类似，但有如下几个区别：

 - 对于http、https 以及 ftp 协议的 URL，路径必须是通配符（/*）。对于 file 协议的 URL，必须指定完整路径，不能包含通配符。
 
 - 与一般的匹配表达式相反，内容设置的匹配表达式可以指定端口。如果指定了端口，表达式将只匹配指定端口的网站。如果没有指定端口，表达式将匹配所有端口。
 
#### 匹配表达式的优先顺序

当不止一个内容设置规则应用于同一个站点时，规则的匹配表达式更具体则优先。
例如，匹配表达式按照优先顺序排列如下

 1. `http://www.example.com/*`
 
 2. `http://*.example.com/*` 匹配 example.com 以及所有子域名
 
 3. `<all_urls>` 匹配所有 URL
 
三种类型的通配符影响匹配表达式的具体程度: 

 - 端口号中的通配符（例如:(注意清除后边多出来的空格) `http://www.example.com:* /*`）
 - 协议中的通配符（例如 *://www.example.com:123/*）
 - 主机名中的通配符（例如 http://*.example.com:123/*）

如果某个匹配表达式中的某一部分比另一个更具体，但是另一部分却不太具体，将按照以下顺序检查不同的部分：主机名、协议、端口。例如，匹配表达式按照优先顺序排列如下：

 - `http://www.example.com:* /*` 指定主机名与协议(注意清除空格)。

 - `*:/www.example.com:123/*` 不如第一个优先级高，因为尽管它指定了主机名，但是没有指定协议。

 - `http://*.example.com:123/*` 优先级更低，因为尽管它指定了端口和协议，但是主机名中包含通配符。

### 主要和辅助匹配表达式

当决定应用哪些内容设置时考虑的 URL 取决于内容类型。例如，对于 contentSettings.notifications（通知）来说，设置基于多功能框中显示的 URL，这一 URL 称为“主要”URL。

某些内容类型会考虑额外的 URL。例如，某一站点是否允许设置 Cookie 取决于 HTTP 请求的 URL（在这种情况下为主要 URL）以及多功能框中显示的 URL（称为“辅助”URL）。

如果多个规则包含主要和辅助匹配表达式，规则的主要匹配表达式更具体则优先。如果多个规则包含同样的主要匹配表达式，规则的辅助匹配表达式更具体则优先。例如，主要/辅助匹配表达式对按照优先顺序排列如下：

优先级  | 主要匹配表达式 | 辅助匹配表达式
:-----: | :------------: | :------------:
1 | `http://www.moose.com/*` | `http://www.wombat.com/*`
2 | `http://www.moose.com/*` | `<all_urls>`
3 | `<all_urls>` | `http://www.wombat.com/*`
4 | `<all_urls>` | `<all_urls>`

### 资源标识符

资源标识符允许您为某种内容类型特定的子类型指定内容设置。当前，支持资源标识符的内容类型只有 pcontentSettings.plugins（插件），其中资源标识符标识某个插件。当应用内容设置时，首先检查用于特定插件的设置。如果没有找到用于插件的设置，将检查用于所有插件的通用设置。

例如，如果一项内容设置规则的资源标识符为 adobe-flash-player，匹配表达式为 <all_urls>，则它的优先级高于没有资源标识符、只有匹配表达式 http://www.example.com/* 的规则，即使后者的匹配表达式更加具体。

您可以通过调用 contentSettings.ContentSetting.getResourceIdentifiers 方法获得某一内容类型的所有资源标识符。返回的列表可能会随着用户计算机上安装的插件而变化，但是 Chrome 浏览器会尽可能保持标识符在插件更新前后的稳定。
 
[更多内容...](https://crxdoc-zh.appspot.com/extensions/contentSettings)
*/
@:require(chrome_ext)
@:native("chrome.contentSetting")
extern class ContentSetting {
	
	/**
	是否允许网站设置 Cookie 以及其他本地数据。以下值之一
	 - "allow": 接受 Cookie
	 - "block": 阻止 Cookie
	 - "session_only": 接受仅在当前会话有效的 Cookie
	
	默认值为 "allow", 主要 URL 为代表 Cookie 来源的 URL，辅助 URL 为顶层框架的 URL 
	*/
	static var cookies(default, never) : ContentSetting;
	
	/**
	是否显示图片
	 - "allow": 
	 - "block": 
	
	默认值为 "allow",主要 URL 为主框架 URL，辅助 URL 为图片 URL。
	*/
	static var images(default, never) : ContentSetting;
	
	/**
	是否运行 JavaScript
	 - "allow": 
	 - "block": 
	 
	默认值为 "allow",主要 URL 为顶层框架 URL，辅助 URL 未使用
	*/
	static var javascript(default, never) : ContentSetting;
	
	/**
	是否运行插件
	 - "allow": 
	 - "block": 
	 
	默认值为 "allow",主要 URL 为顶层框架 URL，辅助 URL 未使用
	*/
	static var plugins(default, never) : ContentSetting;
	
	/**
	是否允许站点显示弹出式窗口
	 - "allow": 
	 - "block": 
	 
	默认值为 "block",主要 URL 为顶层框架 URL，辅助 URL 未使用 
	*/
	static var popups(default, never) : ContentSetting;
	
	/**
 	是否允许站点显示桌面通知
	 - "allow": 
	 - "block": 
	 - "ask" 要显示桌面通知时询问用户
	
	默认值为 "ask",主要 URL 为顶层框架 URL，辅助 URL 未使用
	*/
	static var notifications(default,never) : ContentSetting;
	
	/**
	清除当前扩展程序设置的所有内容设置规则。 
	*/
	function clear( details : { ?scope : Scope }, ?callback : Void->Void ) : Void;
	
	/**
	获得指定主要/辅助 URL 对当前对应的内容设置。
	
	details:
	 - primaryUrl: 要获得当前内容设置的主要 URL，注意主要 URL 的意义取决于内容类型
	 - secondaryUrl: 要获得当前内容设置的辅助 URL，默认为主要 URL。注意辅助 URL 的意义取决于内容类型，并且不是所有的内容类型都使用辅助 URL。
	 - resourceIdentifier: 有关要获取设置的更具体的内容类型标识符。
	 - incognito: 是否为隐身会话检查内容设置。（默认为 false）
	*/
	function get( details : { primaryUrl : String, ?secondaryUrl : String, ?resourceIdentifier : ResourceIdentifier, ?incognito : Bool }, callback : Dynamic->Void ) : Void;
	
	/**
	应用新的内容设置规则 
	
	details:
	 - primaryPattern: 主要 URL 的匹配表达式。有关匹配表达式的格式细节
	 - secondaryPattern: 辅助 URL 的匹配表达式，默认匹配所有 URL。有关匹配表达式的格式详情
	 - resourceIdentifier: 内容类型的资源标识符
	 - setting: 这一规则应用的设置
	 - scope: 在哪些范围内应用这些设置
	*/
	function set( details : { primaryPattern : String, ?secondaryPattern : String, ?resourceIdentifier : ResourceIdentifier, setting : Dynamic, ?scope : Scope }, callback : Dynamic->Void ) : Void;
	
	function getResourceIdentifiers( callback : Array<ResourceIdentifier>->Void ) : Void;
}
