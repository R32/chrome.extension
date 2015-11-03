package chrome;

import chrome.Events;
import chrome.TTS;

typedef TTSEngineListenerOptions = {
	?voiceName : String,
	?lang : String,
	?gender : TtsGender,
	?rate : Float,
	?pitch : Float,
	?volume : Float
}

/**
在应用中实现文字语音转换（TTS）引擎。如果您的应用注册了该 API，当任何应用或浏览器应用使用 tts 模块朗读时，它会收到事件，包含要朗读的内容以及其他参数。您的应用可以使用任何可用的网络技术合成并输出语音，并向调用方发送事件报告状态。 

可用版本: chrome 14+

权限: "ttsEngine"

#### 概述

http://chajian.baidu.com/developer/extensions/ttsEngine.html

应用可以将自己注册为语音引擎，这样，它就能处理部分或所有诸如 tts.speak 和 tts.stop 的函数调用，提供替代的实现
*/
@:require(chrome)
@:native("chrome.ttsEngine")
extern class TTSEngine {
	static var onSpeak(default,never) : Event<String->TTSEngineListenerOptions->(TtsEvent->Void)->Void>;
	static var onStop(default,never) : Event<Void->Void>;
	static var onPause(default,never) : Event<Void->Void>;
	static var onResume(default,never) : Event<Void->Void>;
}
