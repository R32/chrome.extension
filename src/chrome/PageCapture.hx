package chrome;

/**
将标签页保存为 MHTML。MHTML 是大部分浏览器支持的一种标准格式，它将页面以及所有资源（CSS 文件，图片……）包装在单个文件中。

注意，出于安全考虑，MHTML 文件只能从文件系统中加载，并且只能在主框架中加载。

可用版本: chrome 18+

权限: "pageCapture"
*/
@:require(chrome_ext)
@:native("chrome.pageCapture")
extern class PageCapture {
	/**
	将指定标识符对应标签页中的内容保存为 MHTML 格式。
	
	callback 将在 MHTML内容生成后调用.
	*/
	static function saveAsMHTML( details : {tabId:Int}, f : js.html.Blob->Void ) : Void;
}
