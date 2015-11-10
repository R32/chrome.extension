package chrome;

import chrome.Types;

private typedef Services = {
	alternateErrorPagesEnabled : ChromeSetting<Bool>,
	autofillEnabled : ChromeSetting<Bool>,
	safeBrowsingEnabled : ChromeSetting<Bool>,
	searchSuggestEnabled : ChromeSetting<Bool>,
	spellingServiceEnabled : ChromeSetting<Bool>,
	translationServiceEnabled : ChromeSetting<Bool>
}

private typedef Websites = {
	thirdPartyCookiesAllowed : ChromeSetting<Bool>,
	hyperlinkAuditingEnabled : ChromeSetting<Bool>,
	referrersEnabled : ChromeSetting<Bool>,
	protectedContentEnabled : ChromeSetting<Bool>
}

@:require(chrome_ext)
@:native("chrome.privacy")
extern class Privacy {
	static var network(default,never) : { networkPredictionEnabled : ChromeSetting<Bool>, webRTCMultipleRoutesEnabled : ChromeSetting<Bool> };
	static var services(default,never) : Services;
	static var websites(default,never) : Websites;
}
