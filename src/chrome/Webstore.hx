package chrome;

import chrome.Events;

@:enum abstract InstallStage(String) from String to String {
	var installing = "installing";
	var downloading = "downloading";
}

@:enum abstract ErrorCode(String) from String to String {
	var otherError = "otherError";
	var aborted = "aborted";
	var installInProgress = "installInProgress";
	var notPermitted = "notPermitted";
	var invalidId = "invalidId";
	var webstoreRequestError = "webstoreRequestError";
	var invalidWebstoreResponse = "invalidWebstoreResponse";
	var invalidManifest = "invalidManifest";
	var iconError = "iconError";
	var userCanceled = "userCanceled";
	var blacklisted = "blacklisted";
	var missingDependencies = "missingDependencies";
	var requirementViolations = "requirementViolations";
	var blockedByPolicy = "blockedByPolicy";
	var launchFeatureDisabled = "launchFeatureDisabled";
	var launchUnsupportedExtensionType = "launchUnsupportedExtensionType";
	var launchInProgress = "launchInProgress";
}

/**
在您的网站上“内嵌”安装应用与扩展程序 , [内嵌安装...](https://developers.google.com/chrome/web-store/docs/inline_installation)
*/
@:require(chrome)
@:native("chrome.webstore")
extern class Webstore {
	/**
	
	url: 如果您的网页中包含多于一个关系为 chrome-webstore-item 的 `<link>` 标签，您可以在这里传递 URL 选择您希望安装的项目。如果省略的话，则使用第一个（或唯一一个）链接。如果传递的 URL 在页面中不存在则会引发异常
	 
	 - 1. 先要添加 link 标签放置于 head 内.`<link rel="chrome-webstore-item" href="https://chrome.google.com/webstore/detail/itemID" />`
	 
	 - 2. 再通过这个方法触发安装. 通过在页面中检测 `chrome.app.isInstalled` 的值
	
	successCallback: 当内嵌安装成功完成时,已经显示确认对话框并且用户同意将该项目添加至 Chrome 浏览器
	 
	failureCallback: 内嵌安装没有成功完成时调用此函数。可能的原因包括用户取消了确认对话框，链接的项目无法在网上应用店中找到，或者安装由未经过验证的站点进行。
	*/
	static function install( ?url : String, ?successCallback : Void->Void, ?failureCallback : String->?ErrorCode->Void ) : Void;
	static var onInstallStageChanged(default,never) : Event<InstallStage->Void>;
	static var onDownloadProgress(default,never) : Event<Float->Void>;
}
