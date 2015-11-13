package chrome;

import chrome.Events;

/**
chrome.downloads FilenameConflictAction:
 - uniquify: 为了避免重复，filename 可能会更改，在文件扩展名前包含一个计数器。
 - overwrite: 现有文件会被新文件覆盖。
 - prompt: 显示文件选择对话框提示用户。

*/
@:enum abstract FilenameConflictAction(String) from String to String {
	var uniquify = "uniquify";
	var overwrite = "overwrite";
	var prompt = "prompt";
}


@:enum abstract InterruptReason(String) from String to String {
	var FILE_FAILED = "FILE_FAILED";
	var FILE_ACCESS_DENIED = "FILE_ACCESS_DENIED";
	var FILE_NO_SPACE = "FILE_NO_SPACE";
	var FILE_NAME_TOO_LONG = "FILE_NAME_TOO_LONG";
	var FILE_TOO_LARGE = "FILE_TOO_LARGE";
	var FILE_VIRUS_INFECTED = "FILE_VIRUS_INFECTED";
	var FILE_TRANSIENT_ERROR = "FILE_TRANSIENT_ERROR";
	var FILE_BLOCKED = "FILE_BLOCKED";
	var FILE_SECURITY_CHECK_FAILED = "FILE_SECURITY_CHECK_FAILED";
	var FILE_TOO_SHORT = "FILE_TOO_SHORT";
	var NETWORK_FAILED = "NETWORK_FAILED";
	var NETWORK_TIMEOUT = "NETWORK_TIMEOUT";
	var NETWORK_DISCONNECTED = "NETWORK_DISCONNECTED";
	var NETWORK_SERVER_DOWN = "NETWORK_SERVER_DOWN";
	var NETWORK_INVALID_REQUEST = "NETWORK_INVALID_REQUEST";
	var SERVER_FAILED = "SERVER_FAILED";
	var SERVER_NO_RANGE = "SERVER_NO_RANGE";
	var SERVER_PRECONDITION = "SERVER_PRECONDITION";
	var SERVER_BAD_CONTENT = "SERVER_BAD_CONTENT";
	var USER_CANCELED = "USER_CANCELED";
	var USER_SHUTDOWN = "USER_SHUTDOWN";
	var CRASH = "CRASH";
}

@:enum abstract Method(String) from String to String {
	var GET = "GET";
	var POST = "POST";
}

/**
chrome.downloads DangerType
 - file: 下载项的文件名可疑
 - url: 下载项的 URL 已知是恶意的。
 - content: 已下载的文件已知是恶意的
 - uncommon: 下载项的 URL 不常见，可能有风险。
 - host: 下载项来自已知发布恶意软件的主机，可能有风险。
 - unwanted: 下载项可能不是所需要的或者不安全，例如它可能会更改浏览器或计算机设置
 - safe: 下载项对用户的计算机没有已知风险。
 - accepted: 用户已经接受了有风险的下载。
*/
@:enum abstract DangerType(String) from String to String {
	var file = "file";
	var url = "url";
	var content = "content";
	var uncommon = "uncommon";
	var host = "host";
	var unwanted = "unwanted";
	var safe = "safe";
	var accepted = "accepted";
}

/**
chrome.downloads State:
 - in_progress: 下载项当前正在从服务器接收数据。
 - interrupted: 错误中断了与文件主机之间的连接。
 - complete: 下载成功完成。
*/
@:enum abstract State(String) from String to String {
	var in_progress = "in_progress";
	var interrupted = "interrupted";
	var complete = "complete";
}

/**
chrome.downloads DownloadItem:
 - id: 在不同浏览器会话间持久存在的标识符。
 - url: 绝对 URL。
 - referrer: 绝对 URL。
 - filename: 绝对本地路径。
 - incognito: 如果该下载项记录在历史记录中则为 false，没有记录则为 true。
 - danger: 表示该下载项是否被识别为安全的或者已知是可疑的。
 - mime: 文件的 MIME 类型。
 - startTime: 下载开始的时间，以 ISO 8601 格式表示，可以直接传递给 Date 的构造函数: `chrome.downloads.search({}, function(items){items.forEach(function(item){console.log(new Date(item.startTime))})})`
 - endTime: 下载结束的时间，以 ISO 8601 格式表示，可以直接传递给 Date 的构造函数: `chrome.downloads.search({}, function(items){items.forEach(function(item){console.log(new Date(item.endTime))})})`
 - estimatedEndTime: 下载项完成的估计时间，以 ISO 8601 格式表示，可以直接传递给 Date 的构造函数: `chrome.downloads.search({}, function(items){items.forEach(function(item){if (item.estimatedEndTime) console.log(new Date(item.estimatedEndTime))})})`
 - state: 表示下载项处于正在进行、已中断还是已完成的状态。
 - paused: 如果下载项已停止从主机读取数据，但是连接仍然保持打开状态则为 true。
 - canResume: 如果下载项还在进行中并且已暂停，或者如果中断了但是可以从中断的位置恢复则为 true。
 - error: 下载项中断的原因。各种 HTTP 错误可能会归为以 SERVER_ 开头的几种错误之一，与网络相关的错误以 NETWORK_ 开头，将文件写入文件系统的过程中发生的有关错误以 FILE_ 开头，由用户进行的中断由 USER_开头。
 - bytesReceived: 目前为止从主机接收到的字节数，不考虑文件压缩。
 - totalBytes: 整个文件的字节数，不考虑压缩，如果未知则为 -1。
 - fileSize: 整个文件解压缩后包含的字节数，如果未知则为 -1。
 - exists: 下载的文件是否还存在，该信息可能不是最新的，因为 Chrome 浏览器不会自动检测文件的删除。要检查文件是否存在，请调用 search()。存在性检查完后，如果文件已删除，会产生 onChanged 事件。注意 search() 不会等到存在性检查完成后再返回，所以 search() 的结果不一定能准确地反映文件系统的情况。此外，尽管可以频繁调用 search()，但是检查文件存在性的频率不会高于每 10 秒一次。
 - byExtensionId: 如果下载项由扩展程序发起，则为开始本次下载的扩展程序标识符，一旦设置后就不会更改。
 - byExtensionName: 如果下载项由扩展程序发起，则为开始本次下载的扩展程序本地化名称，如果扩展程序的名称更改或者用户更改了区域设置则该属性也会更改。
*/
typedef DownloadItem = {
	var id : String;
	var url : String;
	var referrer : String;
	var filename : String;
	var incognito : Bool;
	var danger : DangerType;
	var mime : String;
	var startTime : String;
	@:optional var endTime : String;
	@:optional var estimatedEndTime : String;
	var state : State;
	var paused : Bool;
	var canResume : Bool;
	@:optional var error : InterruptReason;
	var bytesReceived : Float;
	var totalBytes : Float;
	var fileSize : Float;
	var exists : Int;
	@:optional var byExtensionId : String;
	@:optional var byExtensionName : String;
}

/**
chrome.downloads Query:
 - query: 这一搜索条目数组将结果限制为文件名（filename）或 URL 包含所有不以减号（'-'）开始的搜索条目并且不包含所有以减号（'-'）开始的搜索条目。
 - startedBefore: 将结果限制为下载开始时间在给定时间（以 1970 年 1 月 1 日午夜以来所经过的毫秒数表示）之前的 DownloadItem
 - startedAfter: 将结果限制为下载开始时间在给定时间（以 1970 年 1 月 1 日午夜以来所经过的毫秒数表示）之后的 DownloadItem。
 - endedBefore: 将结果限制为下载结束时间在给定时间（以 1970 年 1 月 1 日午夜以来所经过的毫秒数表示）之前的 DownloadItem。
 - endedAfter: 将结果限制为下载结束时间在给定时间（以 1970 年 1 月 1 日午夜以来所经过的毫秒数表示）之后的 DownloadItem。
 - totalBytesGreater: 将结果限制为 totalBytes 大于指定整数的 DownloadItem。
 - totalBytesLess: 将结果限制为 totalBytes 小于指定整数的 DownloadItem。
 - filenameRegex: 将结果限制为 filename 匹配指定正则表达式的 DownloadItem。
 - urlRegex: 将结果限制为 url 匹配指定正则表达式的 DownloadItem。
 - limit: 返回匹配 DownloadItem（下载项）的最大数目，默认为 1000，设置为 0 则返回所有匹配的 DownloadItem（下载项）。有关如何为结果分页，请参见 search。
 - orderBy: 将该数组的元素设置为 DownloadItem 的属性，为搜索结果排序。例如，设置 orderBy: ['startTime'] 将使下载项按开始时间升序排列。如果要降序排列，请在前面使用连字符：'-startTime'。
 - ...其它参考 DownloadItem
*/
typedef DownloadQuery = {
	@:optional var query : Array<String>;
	@:optional var startedBefore : String;
	@:optional var startedAfter : String;
	@:optional var endedBefore : String;
	@:optional var endedAfter : String;
	@:optional var totalBytesGreater : Float;
	@:optional var totalBytesLess : Float;
	@:optional var filenameRegex : String;
	@:optional var urlRegex : String;
	@:optional var limit : Int;
	@:optional var orderBy : Array<String>;
	@:optional var id : Int;
	@:optional var url : String;
	@:optional var filename : String;
	@:optional var danger : DangerType;
	@:optional var mime : String;
	@:optional var startTime : String;
	@:optional var endTime : String;
	@:optional var state : State;
	@:optional var paused : Bool;
	@:optional var error : InterruptReason;
	var bytesReceived : Float;
	var totalBytes : Float;
	var fileSize : Float;
	var exists : Bool;
	@:optional var byExtensionId : String;
	@:optional var byExtensionName : String;
}

typedef StringDelta = {
	@:optional var previous : String;
	@:optional var current : String;
}

typedef DoubleDelta = {
	@:optional var previous : Float;
	@:optional var current : Float;
}

typedef BooleanDelta = {
	@:optional var previous : Bool;
	@:optional var current : Bool;
}

typedef DownloadDelta = {
	var id : Int;
	@:optional var url : StringDelta;
	@:optional var filename : StringDelta;
	@:optional var danger : StringDelta;
	@:optional var mime : StringDelta;
	@:optional var startTime : StringDelta;
	@:optional var endTime : StringDelta;
	@:optional var state : StringDelta;
	@:optional var canResume : BooleanDelta;
	@:optional var paused : BooleanDelta;
	@:optional var error : StringDelta;
	@:optional var totalBytes : DoubleDelta;
	@:optional var fileSize : DoubleDelta;
	@:optional var exists : BooleanDelta;
}

/**
以编程方式开始下载，监视、操纵、搜索下载的文件。

可用版本: chrome 31

权限: "downloads"

[更多细节...](http://api.gjcq176.com/chromeplugin/api%20zh/extensions/downloads.html)
*/
@:require(chrome_ext)
@:native("chrome.downloads")
extern class Downloads {
	/**
	 
	options:
	 - url: 要下载的 URL
	 - filename: 相对于下载文件夹(本地)的路径，包含下载得到的文件，可以包含子目录。绝对路径、空路径以及包含向前引用“..”的路径会导致错误。onDeterminingFilename 允许在文件 MIME 类型和待定文件名确定后推荐文件名。
	 - conflictAction: 如果 filename 已经存在时进行的操作。
	 - saveAs: 使用选择文件对话框，允许用户选择文件名（无论 filename 是否设置或已经存在）。
	 - method: 如果 URL 使用 HTTP[S] 协议，则为使用的 HTTP 方法。
	 - headers: 如果 URL 使用 HTTP[S] 协议，则包含要与请求一起发送的附加 HTTP 头信息。每一条头信息都由词典表示，包含键 name 以及 value 或 binaryValue 中的某一个，仅限于 XMLHttpRequest 中允许的头信息。
	  - name: HTTP 头信息的名称。
	  - value: HTTP 头信息的值。
	 - body: POST 方法的正文。
	 
	callback: 调用时传递新的 DownloadItem 的标识符。
	*/
	static function download(
		options : {
			url:String,
			?filename:String,
			?conflictAction:FilenameConflictAction,
			?saveAs:Bool,
			?method:Method,
			?headers:Array<{name:String,value:String}>,
			?body:String
		},
		?callback : Int->Void ) : Void;
		
	/**
	寻找 DownloadItem（下载项）。将 query 设置为空对象可以获取所有下载项。要获得某个特定的下载项，只要设置 id 字段。要为大量项目分页，请设置 orderBy: ['-startTime']，将 limit 设置为每一页的项目数目，并将 startedAfter 设置为上一页最后一个项目的 startTime 属性。 
	
	query: 参见 DownloadQuery 描述
	*/
	static function search( query : {
			?query : Array<String>,
			?startedBefore : String,
			?startedAfter : String,
			?endedBefore : String,
			?endedAfter : String,
			?totalBytesGreater : Float,
			?totalBytesLess : Float,
			?filenameRegex : String,
			?urlRegex : String,
			?limit : Int,
			?orderBy : Array<String>,
			?id : Int,
			?url : String,
			?filename : String,
			?danger : DangerType,
			?mime : String,
			?startTime : String,
			?endTime : String,
			?state : State,
			?paused : Bool,
			?error : InterruptReason,
			?bytesReceived : Float,
			?totalBytes : Float,
			?fileSize : Float,
			?exists : Bool
		}, callback : Array<DownloadItem>->Void ) : Void;
		
	/**
	暂停下载。如果请求成功，下载项将进入暂停状态。否则，runtime.lastError 将包含错误消息。如果下载项不处于活动状态，该调用会失败。 
	*/
	static function pause( downloadId : Int, ?callback : Void->Void ) : Void;
	
	/**
	恢复已暂停的下载。如果请求成功，下载项将继续进行，不再处于暂停状态。否则，runtime.lastError 将包含错误消息。如果下载项不处于活动状态，该调用会失败。 
	*/
	static function resume( downloadId : Int, ?callback : Void->Void ) : Void;
	
	/**
	取消下载。回调函数运行时，下载已取消、已完成、已中断或者不再存在。 
	*/
	static function cancel( downloadId : Int, ?callback : Void->Void ) : Void;
	
	/**
	获取指定下载项的图标。对于新的下载项，文件图标将在 onCreated 事件收到后才可用。在下载进行时该函数返回的图像可能与下载完成后返回的图像不同。获取图标的方式取决于平台，通过查询下层操作系统或工具包的方式进行。因此，返回的图标取决于各种因素，包括下载状态、平台、已注册的文件类型以及视觉主题。如果无法确定文件图标，runtime.lastError 将会包含错误消息。 
	*/
	static function getFileIcon( downloadId : Int, options : {?size:Int}, ?callback : String->Void ) : Void;
	
	/**
	如果 DownloadItem（下载项）已完成则立即打开下载的文件，否则通过 runtime.lastError 返回错误。该方法除了需要 "downloads" 权限外还需要 "downloads.open" 权限。项目第一次打开时将产生 onChanged 事件。 
	*/
	static function open( downloadId : Int ) : Void;
	
	/**
	在文件管理器中，打开已下载文件所在的文件夹并显示它。 
	*/
	static function show( downloadId : Int ) : Void;
	
	/**
	在文件管理器中显示默认的下载文件夹。 
	*/
	static function showDefaultFolder() : Void;
	
	/**
	从历史记录中删除匹配的 DownloadItem（下载项），但不会删除已下载的文件，匹配 query 的每一个 DownloadItem 都会产生一次 onErased 事件，然后调用 callback。 
	*/
	static function erase( query : {
			?query : Array<String>,
			?startedBefore : String,
			?startedAfter : String,
			?endedBefore : String,
			?endedAfter : String,
			?totalBytesGreater : Float,
			?totalBytesLess : Float,
			?filenameRegex : String,
			?urlRegex : String,
			?limit : Int,
			?orderBy : Array<String>,
			?id : Int,
			?url : String,
			?filename : String,
			?danger : DangerType,
			?mime : String,
			?startTime : String,
			?endTime : String,
			?state : State,
			?paused : Bool,
			?error : InterruptReason,
			?bytesReceived : Float,
			?totalBytes : Float,
			?fileSize : Float,
			?exists : Bool
		}, ?callback : Array<Int> ) : Void;
	
	/**
	如果文件存在并且i DownloadItem（下载项）已完成，则删除已下载的文件，否则通过 runtime.lastError 返回错误。 
	*/
	static function removeFile( downloadId : Int, ?callback : Void->Void ) : Void;
	
	/**
	提示用户接受有风险的下载，不会自动接受有风险的下载。如果下载项被接受，将产生 onChanged 事件，否则什么都不会发生。当所有数据都获取至临时文件后，如果下载项没有风险或者已被接受，该临时文件将被重命名为目标文件名，state 更改为 'complete'，并产生 onChanged 事件。 
	*/
	static function acceptDanger( downloadId : Int, ?callback : Void->Void ) : Void;
	
	/**
	开始将已下载的文件拖动到另一个应用程序，在 JavaScript 的 ondragstart 事件处理程序中调用。 
	*/
	static function drag( downloadId : Int ) : Void;
	
	/**
	启用或禁用窗口底部与当前浏览器的用户配置文件相关联的灰色下载框，只要有至少一个扩展程序禁用它则下载框就会被禁用，在其他扩展程序禁用下载框时启用它会导致错误，通过 runtime.lastError 返回。除了 "downloads" 权限以外还需要 "downloads.shelf" 权限。 
	*/
	static function setShelfEnabled( enabled : Bool ) : Void;
	
	/**
	下载开始时产生该事件，并传递 DownloadItem 对象。 
	*/
	static var onCreated(default, never) : Event<DownloadItem->Void>;
	
	/**
	当下载项从历史记录中删除时产生，并传递 downloadId。
	*/
	static var onErased(default, never) : Event<Int->Void>;
	
	/**
	除 bytesReceived 和 estimatedEndTime 以外，当某个 DownloadItem（下载项）的任何属性更改时，会产生该事件，并传递 downloadId 以及描述属性更改的对象 
	*/
	static var onChanged(default,never) : Event<{
			?url : StringDelta,
			?filename : StringDelta,
			?danger : StringDelta,
			?mime : StringDelta,
			?startTime : StringDelta,
			?endTime : StringDelta,
			?state : StringDelta,
			?canResume : BooleanDelta,
			?paused : BooleanDelta,
			?error : StringDelta,
			?totalBytes : DoubleDelta,
			?fileSize : DoubleDelta,
			?exists : BooleanDelta
		}->Void > ;
	
	/**
	在确定文件名的过程中，扩展程序有机会修改目标 DownloadItem.filename（文件名）。每一个扩展程序不能为该事件注册一个以上的监听器，每个监听器必须恰好调用一次 suggest，既可以是同步地，也可以是异步地。如果监听器异步地调用 suggest，它必须返回 true。如果监听器既没有同步地调用 suggest，也没有返回 true，则会自动调用 suggest。在所有监听器调用 suggest 前，DownloadItem（下载项）不会完成。监听器应该不传递任何参数调用 suggest，允许下载项使用 downloadItem.filename 作为它的文件名，或者向 suggest 传递一个 suggestion 对象，修改目标文件名。如果不止一个扩展程序修改文件名，最后安装并且向 suggest 传递 suggestion 对象的扩展程序优先。为了避免哪个扩展程序优先造成的混淆，用户不应该安装可能会导致冲突的扩展程序。如果下载由 download 发起，并且在 MIME 类型和待定文件名确定前就指定了文件名，请将 filename 传递给 download。 
	*/
	static var onDeterminingFilename(default,never) : Event<DownloadItem->(?{filename:String,?conflictAction:FilenameConflictAction}->Void)->Void>;
}
