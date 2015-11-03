package chrome;

import chrome.Events;

/**
请求类型的列表 TODO: doc
 - main_frame: 
 - sub_frame: 
 - stylesheet: 
 - script: 
 - image: 
 - object: 
 - xmlhttprequest: 
 - other: 
*/
@:enum abstract ResourceType(String) from String to String {
	var main_frame = "main_frame";
	var sub_frame = "sub_frame";
	var stylesheet = "stylesheet";
	var script = "script";
	var image = "image";
	var object = "object";
	var xmlhttprequest = "xmlhttprequest";
	var other = "other";
}

@:enum abstract OnBeforeRequestOptions(String) from String to String {
	var blocking = "blocking";
	var requestBody = "requestBody";
}

@:enum abstract OnBeforeSendHeadersOptions(String) from String to String {
	var requestHeaders = "requestHeaders";
	var blocking = "blocking";
}

@:enum abstract OnSendHeadersOptions(String) from String to String {
	//TODO missing in documentation
	var requestHeaders = "requestHeaders";
}

@:enum abstract OnHeadersReceivedOptions(String) from String to String {
	var blocking = "blocking";
	var responseHeaders = "responseHeaders";
}

@:enum abstract OnAuthRequiredOptions(String) from String to String {
	var responseHeaders = "responseHeaders";
	var blocking = "blocking";
	var asyncBlocking = "asyncBlocking";
}

@:enum abstract OnResponseStartedOptions(String) from String to String {
	//TODO missing in documentation
	var responseHeaders = "responseHeaders";
}

@:enum abstract OnBeforeRedirectOptions(String) from String to String {
	//TODO missing in documentation
	var responseHeaders = "responseHeaders";
}

@:enum abstract OnCompletedOptions(String) from String to String {
	//TODO missing in documentation
	var responseHeaders = "responseHeaders";
}

/**
描述应用于网络请求事件的过滤器对象
 - urls URL 或 URL 匹配表达式列表，不匹配任何 URL 的请求会被过滤出去。
 - types ResourceType, 请求类型的列表，不匹配任何一种类型的请求会被过滤出去。
 - tabId
 - windowId
*/
typedef RequestFilter = {
	var urls : Array<String>;
	@:optional var types : Array<ResourceType>;
	@:optional var tabId : Int;
	@:optional var windowId : Int;
}

/**
包含 HTTP 标头的数组 
*/
typedef HttpHeaders = Array<Dynamic>;

/**
用于在 extraInfoSpec 参数中指定 "blocking" 的事件处理函数的返回值，允许事件处理函数修改网络请求

 - cancel: 如果为 true，则取消请求。在 onBeforeRequest 事件中使用，用来阻止请求的发送
 - redirectUrl: 仅用于 onBeforeRequest 和 onHeadersReceived 事件的返回值。如果设置了该属性，就会阻止原始请求的发送/完成，并重定向至指定的 URL。允许重定向至非 HTTP 协议的 URL，例如 data:。重定向操作产生的重定向通常使用原来的请求方法，以下情况例外：如果在 onHeadersReceived 阶段产生了重定向，重定向请求将使用 GET 方法发出
 - requestHeaders: 仅用于 onBeforeSendHeaders 事件的返回值。如果设置了这一属性，请求将改用这些标头发出。
 - responseHeaders: 仅用于 onHeadersReceived 事件的返回值。如果设置了这一属性，则假定服务器返回了这些响应标头。为了限制冲突数目（对于每一个请求，只有一个应用可以修改 responseHeaders），只有有当您确实需要修改标头时才应该返回 responseHeaders。
 - windauthCredentialsowId: 仅用于 onAuthRequired 事件的返回值。如果设置了这一属性，发出的请求将使用提供的凭据。
  - username
  - password
*/
typedef BlockingResponse = {
	@:optional var cancel : Bool;
	@:optional var redirectUrl : String;
	@:optional var requestHeaders : HttpHeaders;
	@:optional var responseHeaders : HttpHeaders;
	@:optional var windauthCredentialsowId : Dynamic;
}

/**
包含 URL 请求中上传的数据
 - bytes: 包含数据的一份拷贝的 ArrayBuffer
 - file: 包含文件路径与名称的字符串。
*/
typedef UploadData = {
	@:optional var bytes : Dynamic;
	@:optional var file : String;
}

/**
监控与分析流量，还可以实时地拦截、阻止或修改请求
 
可用版本: Chrome 17+ 
 
权限: "webRequest" + 主机权限, 您还需要另外请求 "webRequestBlocking" 权限

网络请求 API 保证对于每一个请求，onCompleted 或 onErrorOccurred 是最终产生的事件，除了如下例外：如果请求重定向至 data:// URL，onBeforeRedirect 将是最后报告的事件。

[更多内容...](http://chajian.baidu.com/developer/extensions/webRequest.html)
*/
@:require(chrome_ext)
@:native("chrome.webRequest")
extern class WebRequest {
	/**
	10 分钟内 handlerBehaviorChanged 能够被调用的次数。handlerBehaviorChanged 是一个昂贵的函数，不应该经常调用。 
	*/
	static var MAX_HANDLER_BEHAVIOR_CHANGED_CALLS_PER_10_MINUTES(default, never) : Int;
	
	/**
	当网络请求处理函数的行为发生更改时，为了避免缓存导致的不正确处理，需要调用这一函数。这一函数调用比较昂贵，不要经常调用。 
	*/
	static function handlerBehaviorChanged( callback : Void->Void ) : Void;
	
	/**
	(可以为同步).当请求即将发出前。这一事件在 TCP 连接建立前发送，可以用来取消或重定向请求。
	
	callback: `function(details:{}){}`
	 - requestId: 请求标识符。请求标识符在浏览器会话中保证唯一，所以，它们可以用来联系同一请求的不同事件。
	 - url: 
	 - method: 标准 HTTP 方法。
	 - frameId: 0 表示请求发生在主框架中，正数表示发出请求的子框架标识符.
	 - parentFrameId: 包含发送请求框架的框架（即父框架）标识符，如果不存在父框架则为 -1。
	 - requestBody: 包含 HTTP 请求正文数据，仅在 extraInfoSpec 包含 "requestBody" 时才会提供。
	 - tabId: 产生请求的标签页标识符。如果请求与标签页无关则为 -1。
	 - type: 
	 - timeStamp: 该信号触发的时间，以 1970 年 1 月 1 日午夜开始所经过的毫秒数表示。
	 
	filter: RequestFilter
	
	extraInfoSpec: OnBeforeRequestOptions
	 - "blocking" 如果指定了 "blocking", 那么回调函数将返回相应的 BlockingResponse 对象
	 - "requestBody"
	*/
	static var onBeforeRequest(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			?requestBody : {
				?error : String,
				?formData : Dynamic,
				?raw : Array<UploadData>,
			},
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
		}->BlockingResponse > ;
	
	/**
	(可以为同步).在发送 HTTP 请求前，一旦请求标头可用就产生这一事件。这一事件可能在与服务器的 TCP 连接建立后产生，但是确保在发送任何 HTTP 数据前产生。
	
	callback: `function(details:{}){}`
	 - requestHeaders: 将要与这一请求一同发送的 HTTP 请求标头。
	
	extraInfoSpec: OnBeforeSendHeadersOptions
	 - "blocking"
	 - "requestHeaders" 是否在回调参数中包含 requestHeaders 属性
	*/
	static var onBeforeSendHeaders(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			?requestHeaders : HttpHeaders
		}->BlockingResponse > ;
	
	/**
	当请求即将发送至服务器的前一刻产生（onBeforeSendHeaders 回调作出的修改可以在这一事件产生时体现）。 
	
	仅用于提供信息，并且以异步方式处理，不允许修改或取消请求。
	
	callback: `function(details:{}){}`
	
	extraInfoSpec: OnSendHeadersOptions
	 - "requestHeaders" 是否在回调参数中包含 requestHeaders 属性
	*/	
	static var onSendHeaders(default, never) : Event<{
			requestId: String,
			url:String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId:Int,
			type: ResourceType,
			timeStamp : Float,
			?requestHeaders : HttpHeaders
		} ->Void > ;
	/**
	(可以为同步).每当接收到 HTTP(S) 响应标头时产生。由于重定向以及认证请求，对于每次请求这一事件可以多次产生。这一事件是为了使应用能够添加、修改和删除响应标头，例如传入的 Set-Cookie 标头。缓存指示是在该事件触发前处理的，所以修改 Cache-Control 之类的标头不会影响浏览器的缓存。它还允许您重定向请求。 
	
	callback:
	 - responseHeaders: 应答头
	 - statusCode: 
	 
	extraInfoSpec: OnHeadersReceivedOptions
	 - "blocking"
	 - "responseHeaders": 
	*/
	static var onHeadersReceived(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			statusLine : String,
			?responseHeaders : HttpHeaders,
			statusCode : Int
		}->BlockingResponse > ;
	/**
	(可以为同步). 当接收到认证失败时产生。事件处理函数有三种选择：提供认证凭据，取消请求并显示错误页面，或者不采取任何行动。如果提供了错误的用户凭据，可能会为同一请求重复调用事件处理函数。
	
	callback: `function(details:{}, ?callb:BlockingResponse->Void):BlockingResponse{}`
	 - scheme: 认证方式，例如基本（"basic"）或摘要式（"digest"）。
	 - ?realm: 服务器提供的认证域（如果有的话）
	 - ?challenger: 请求认证的服务器。
	 - isProxy: 如果为 Proxy-Authenticate（代理服务器认证）则为 true，否则如果为 WWW-Authenticate 则为 false。
	
	extraInfoSpec OnAuthRequiredOptions
	 - "blocking"
	 - "asyncBlocking"
	 - "responseHeaders" 
	*/	
	static var onAuthRequired(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			scheme : String,
			?realm : String,
			?challenger : Dynamic,
			isProxy : Bool,
			?responseHeaders : HttpHeaders,
			statusLine : String,
			statusCode : Int
		}->?(BlockingResponse-> Void)->BlockingResponse > ;
	/**
	当接收到响应正文的第一个字节时产生。对于 HTTP 请求，这意味着状态行和响应标头已经可用。这一事件仅用于提供信息，并以异步方式处理，不允许修改或取消请求。 
	
	extraInfoSpec: OnResponseStartedOptions
	*/	
	static var onResponseStarted(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			?ip : String,
			?fromCache : Bool,
			statusCode : Int,
			?responseHeaders : HttpHeaders,
			statusLine : String
		}->Void > ;
	
	/**
	当重定向即将执行时产生，重定向可以由 HTTP 响应代码或应用触发。这一事件仅用于提供信息，并以异步方式处理，不允许修改或取消请求 
	
	extraInfoSpec: OnBeforeRedirectOptions
	*/	
	static var onBeforeRedirect(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			?ip : String,
			?fromCache : Bool,
			statusCode : Int,
			redirectUrl : String,
			?responseHeaders : HttpHeaders,
			statusLine : String
		}->Void > ;
	
	/**
	当请求成功处理后产生。 
	
	extraInfoSpec: OnCompletedOptions
	*/
	static var onCompleted(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			?ip : String,
			?fromCache : Bool,
			statusCode : Int,
			?responseHeaders : HttpHeaders,
			statusLine : String
		}->Void > ;
	
	/**
	当请求不能成功处理时产生。
	*/	
	static var onErrorOccurred(default,never) : Event<{
			requestId : String,
			url : String,
			method : String,
			frameId : Int,
			parentFrameId : Int,
			tabId : Int,
			type : ResourceType,
			timeStamp : Float,
			?ip : String,
			fromCache : Bool,
			error : String
		}->Void>;
}
