package chrome;

/**

 - start: 引擎开始朗读
 - end: 引擎已完成朗读。
 - word: 遇到单词边界。使用 event.charIndex 确定当前朗读位置
 - sentence: 遇到句子边界。使用 event.charIndex 确定当前朗读位置。
 - marker: 遇到 SSML 标记。使用 event.charIndex 确定当前朗读位置。
 - interrupted: 中断,本次朗读由于另一个 speak() 调用或 stop() 调用而中断，并且没有完成。
 - cancelled: 朗读已放入队列，但后来由于另一个 speak() 调用或 stop() 调用中断，而从未开始朗读。
 - error: 发生了引擎特定的错误，无法开始朗读。有关详情请检查 event.errorMessage
 - pause: 
 - resume: 

这些事件类型中有四个——'end'、'interrupted'、'cancelled' 和 'error' 表示最终结果。发生这些事件中的某一个后，不会再朗读，也不会再收到其他事件。 

某些语音可能不支持所有事件类型，某些语音甚至可能不发送任何事件。如果您需要语音发送某些事件，将您需要的事件放在选项对象的 requiredEventTypes 属性中，或者使用 getVoices() 选择符合您要求的语音。
*/
@:enum abstract TtsEventType(String) from String to String {
	var start = "start";
	var end = "end";
	var word = "word";
	var sentence = "sentence";
	var marker = "marker";
	var interrupted = "interrupted";
	var cancelled = "cancelled";
	var error = "error";
	var pause = "pause";
	var resume = "resume";
}

typedef TtsEvent = {
	var type : TtsEventType;
	@:optional var charIndex : Float;
	@:optional var errorMessage : String;
}

@:enum abstract TtsGender(String) from String to String {
	var male = "male";
	var female = "female";
}

/**
可用语音
 - voiceName: 语音名称
 - lang: 语音支持的语言，以语言-区域的形式表示。例如：'zh-CN'、'en'、'en-US'、'en-GB'。
 - gender: 语音的性别，"male" 表示男性，"female" 表示女性。
 - remote: 如果为 true，综合引擎是远程网络资源，可能有较高的延迟并且会增加带宽的开销。
 - extensionId: 提供语音的应用的标识符。
 - eventTypes: 语音能够发送的所有回调事件类型。
*/
typedef TtsVoice = {
	@:optional var voiceName : String;
	@:optional var lang : String;
	@:optional var gender : TtsGender;
	@:optional var remote : Bool;
	@:optional var extensionId : String;
	@:optional var eventTypes : Array<String>;
}

/**
播放合成的文字语音转换（TTS），同时请您参见相关的 ttsEngine API，允许应用实现语音引擎

可用版本: chrome 14+, 

权限: "tts"

http://chajian.baidu.com/developer/extensions/tts.html
*/
@:require(chrome)
@:native("chrome.tts")
extern class Tts {
	/**
	朗读文本。
	
	 - utterance: 要朗读的文本，既可以是纯文本，也可以是完整的、形式正确的 SSML 文档。不支持 SSML 的语音引擎会忽略标签只朗读文本。这一文本的最大长度为 32 768 个字符。
	 - options: 
	  - enqueue: 如果为 true，若当前 TTS 正在朗读则将这一次朗读放入队列。如果为 false（默认值），则中断当前的朗读，清理语音队列，然后朗读新的文本。
	  - voiceName: 合成的语音名称。如果为空，使用任何可用的语音。
	  - extensionId: 要使用的语音引擎应用的标识符，如果已知的话
	  - lang: 用于合成的语言，以语言-区域的形式。例如：'zh-CN'、'en'、'en-US'、'en-GB'。
	  - gender: 语音合成所使用的性别，"male" 表示男性，"female" 表示女性。
	  - rate: 朗读速率，相对于这一语音的默认速率。1.0 表示默认速率，通常为每分钟 180 至 220 个单词。2.0 表示快一倍，而 0.5 是默认速率的一半。不允许 0.1 以下的值或者 10.0 以上的值，并且许多语音会进一步限制最低和最高速率，例如某种语音也许不可能朗读地比默认速率快三倍，即使您指定了大于 3.0 的值。
	  - pitch: 指定 0 到 2 之间（包括 0 和 2）的声调，0 表示最低，2 表示最高，1.0 对应于语音的默认声调。
	  - volume: 0 到 1 之间（包括 0 和 1）的朗读音量，0 为最低，1 为最高，默认为 1.0。
	  - requiredEventTypes: 语音必须支持的 TTS 事件类型。
	  - desiredEventTypes: 您需要处理的 TTS 事件类型。如果省略，会发送所有事件。
	  - onEvent: 该函数将在朗读过程中发生事件时调用。
	 - callback: 在朗读完成前立即调用。检查 runtime.lastError 确保没有错误发生。使用 options.onEvent 获得更详细的反馈
	*/
	static function speak(
		utterance : String,
		?options : {
			?enqueue : Bool,
			?voiceName : String,
			?extensionId : String,
			?lang : String,
			?gender : TtsGender,
			?rate : Float,
			?pitch : Float,
			?volume : Float,
			?requiredEventTypes : Array<String>,
			?desiredEventTypes : Array<String>,
			?onEvent : TtsEvent->Void
		},
		?callback : Void->Void
	) : Void;
	
	/**
	停止当前的朗读，并清空未完成朗读的队列。此外，如果朗读暂停了，则会取消暂停，以便下一次调用时朗读。 
	*/
	static function stop() : Void;
	
	/**
	暂停语音合成，可能正处于一次朗读的中间。调用 resume 或 stop 会取消暂停朗读。 
	*/
	static function pause() : Void;
	
	/**
	如果朗读暂停了，从暂停的位置恢复朗读。 
	*/
	static function resume() : Void;
	
	/**
	检查引擎当前是否正在朗读。在 Mac OS X 中，只要系统的语音引擎正在朗读，即使此次朗读并不是由chrome 浏览器发起的，结果也是 true。 
	*/
	static function isSpeaking( ?callback : Bool->Void ) : Void;
	
	/**
	获得包含所有可用语音的数组。 
	*/
	static function getVoices( ?callback : Array<TtsVoice>->Void ) : Void;
}
