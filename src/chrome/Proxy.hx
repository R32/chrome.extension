package chrome;

import chrome.Events;
import chrome.Types;

/**
如果没有指定端口将使用各自默认的端口号: http:80, https:443, socks4:1080 socks5:1080
*/
@:enum abstract ProxyServerScheme(String) from String to String {
	var http = "http";
	var https = "https";
	var quic = "quic";
	var socks4 = "socks4";
	var socks5 = "socks5";
}

/**
单个代理服务器信息的对象
*/
typedef ProxyServer = {
	/**
	代理服务器自己的协议，默认为 "http"
	*/
	@:optional var scheme : ProxyServerScheme;
	
	/**
	代理服务器的 URL，必须为 ASCII 主机名（以 Punycode 的格式），暂时还不支持 IDNA
	*/
	var host : String;
	
	/**
	代理服务器的端口，默认值与协议相关。
	*/
	@:optional var port : Int;
}

/**
代理配置-规则, 当指定为 fixed_servers 模式时

 - singleProxy 用于所有 URL 请求（即 HTTP、HTTPS 和 FTP）的代理服务器，其他流量则直接连接
 - proxyForHttp: 用于 HTTP 请求的代理服务器
 - proxyForHttps: 用于 HTTPS 请求的代理服务器。
 - proxyForFtp: 用于 FTP 请求的代理服务器。
 - fallbackProxy 用于其他协议或者未指定 proxyForXXXX 的协议的代理服务器
 - bypassList 不通过代理服务器连接的服务器列表

[bypassList](http://chajian.baidu.com/developer/extensions/proxy.html#bypass_list) 
*/
typedef ProxyRules = {
	@:optional var singleProxy : ProxyServer;
	@:optional var proxyForHttp : ProxyServer;
	@:optional var proxyForHttps : ProxyServer;
	@:optional var proxyForFtp : ProxyServer;
	@:optional var fallbackProxy : ProxyServer;
	@:optional var bypassList : Array<String>;
}

/**
Pac脚本,当指定为 pac_script 模式时, [更多细节](http://myhat.blog.51cto.com/391263/420501/)
*/
typedef PacScript = {
	/**
	要使用的 PAC 文件 URL 
	*/
	@:optional var url : String;
	/**
	PAC 脚本内容 
	*/
	@:optional var data : String;
	/**
	如果为 true，无效的 PAC 脚本将不会使网络回退到直接连接方式。默认为 false。 
	*/
	@:optional var mandatory : Bool;
}

/**
代理配置-模式:

 - direct 所有连接都直接建立，即不使用代理服务器。使用这一模式时不允许 ProxyConfig 对象中包含其他任何参数
 - auto_detect 配置通过下载自 http://wpad/wpad.dat 的一个 PAC 脚本确定。使用这一模式时不允许 ProxyConfig 对象中包含其他任何参数。
 - pac_script 配置由一个 PacScript 指定(除此之外不接受任何其它参数)，它既可以从 PacScript 对象中指定的 URL 获取，也可以直接来自 PacScript 对象中的 data 属性。
 - fixed_servers 手动指定代理服务器, 配置由一个 ProxyRules 指定(除此之外不接受任何其它参数)。它的结构将在代理服务器规则部分描述。
 - system 使用系统的代理服务器设置，使用这一模式时不允许 ProxyConfig 对象中包含其他任何参数。注意 system 模式与不设置代理服务器配置不同，在后一种情况下，浏览器只有在没有任何命令行选项影响代理服务器配置的情况下才会使用系统设置。
 
chrome 的各种翻墙插件使用的是 pac_script 模式. 
*/
@:enum abstract ProxyConfigMode(String) from String to String {
	var direct = "direct";
	var auto_detect = "auto_detect";
	var pac_script = "pac_script";
	var fixed_servers = "fixed_servers";
	var system = "system";
}

/**
代理配置 
*/
typedef ProxyConfig = {
	/**
	描述该配置的代理规则。请在 "fixed_servers" 模式下使用该属性。 
	*/
	@:optional var rules : ProxyRules;
	
	/**
	该配置下的代理服务器自动配置（PAC）脚本。请在 "pac_script" 模式下使用该属性。 
	*/
	@:optional var pacScript : PacScript;
	
	var mode : ProxyConfigMode;
}

/**
管理浏览器的代理服务器设置。该模块依赖于类型 API 中的 ChromeSetting 原型，用于获取和设置代理服务器配置。 

可用版本: chrome 13+

权限: "proxy"

http://chajian.baidu.com/developer/extensions/proxy.html
*/
@:require(chrome_ext)
@:native("chrome.proxy")
extern class Proxy {

	static var settings(default,never) : ChromeSetting<ProxyConfig>;

	/**
	 - fatal: 如果为 true，该错误是致命的，网络连接将终止。否则，将改用直接连接
	 - error: 错误描述
	 - details: 有关错误的其他详情
	*/
	static var onProxyError(default,never) : Event<{fatal:Bool,error:String,details:String}->Void>;
}
