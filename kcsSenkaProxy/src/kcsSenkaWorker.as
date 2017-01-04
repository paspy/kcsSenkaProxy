package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.LocaleID;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import Enums.SenkaWorkerStates;
	
	import kcsCore.UserRecordData;
	import kcsCore._APIBaseS_;
	
	import kcsRecordMain.RankingData;

	public class kcsSenkaWorker 
	{
		public static function GetRandomNum(minLimit:int, maxLimit:int):Number {
			return Math.ceil(Math.random()*(maxLimit - minLimit)) + minLimit;
		}
		
		private var _currWorkingState:int; // as3 does't have enum
		private var _workerProgress:Number;
		private var _keyGen:_APIBaseS_;
		private var _Log:Function;
		private var _timer:Timer; // for single post
		private var _cachePageTimers:Vector.<Timer>; // for launch a pile of delay timers at onece, so ugly lol
		
		private var _apiUrl:String;
		private var _token:String;
		private var _memberId:String;
		
		private var _maxCachePage:int;
		private var _curCachePage:int;
		
		private var _payItemRequest:URLRequest;
		private var _recordRequest:URLRequest;
		private var _senkaRequest:URLRequest;
		
		private var _payItemVar:URLVariables;
		private var _recordVar:URLVariables;
		private var _senkaVar:URLVariables;
		
		private var _setDataFunc:Function;
		
		private var _urlLoader:URLLoader; // for post and download data
		
		private var _resultJson:Object; // downloaded JSON data
		
		private var _userRecordData:UserRecordData;	 // contains user record data
		private var _rankDataList:Vector.<RankingData>; // contains a list of Senka data (1000 MAX)

		public function kcsSenkaWorker(server:String, token:String, LogFunc:Function, maxPage:uint = 5) {
			_workerProgress = 0;
			_keyGen = new _APIBaseS_();
			_userRecordData = new UserRecordData();
			_rankDataList = new Vector.<RankingData>();
			_cachePageTimers = new Vector.<Timer>();
			_timer = null;
			_memberId = "";
			_apiUrl = "http://" + server + "/kcsapi/";
			_token = token;
			_Log = LogFunc;
			_maxCachePage = maxPage;
			_curCachePage = 0;
			PostRequestSetup();
			_currWorkingState = SenkaWorkerStates.eIdle;
		}
		
		public function StartWorker():void {
			if (_currWorkingState == SenkaWorkerStates.eIdle) {
				_currWorkingState = SenkaWorkerStates.eRunning;
				// stage 1 simulate click on Pay Item page
				_timer = new Timer(GetRandomNum(100, 2000));
				_timer.addEventListener(TimerEvent.TIMER, PostPayItemRequest);
				_timer.start();
			}
		}
		
		public function GetProgress():Number {
			return _workerProgress>100? 100:_workerProgress;
		}

		public function ExportToFile(filename:String):void {
			if (_currWorkingState != SenkaWorkerStates.eFinished) return;
			
			try {
				var file:File = File.applicationStorageDirectory;
				file = file.resolvePath(filename);
				var stream:FileStream = new FileStream();
				var date:Date = new Date();
				var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT, DateTimeStyle.LONG, DateTimeStyle.LONG);
				
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(df.format(date) + "\n");
				for(var i:int = 1; i<=_maxCachePage; i++) {
					for(var j:int = 0; j<_rankDataList[i].list.length; j++) {
						var s:String = 
							_rankDataList[i].list[j].rankNo + "," +
							_rankDataList[i].list[j].nickName + "," +
							Consts.RankName[_rankDataList[i].list[j].rank]+ "," +
							_rankDataList[i].list[j].comment + "," +
							_rankDataList[i].list[j].medalNum + "," +
							_rankDataList[i].list[j].rate + "\n";
						stream.writeUTFBytes(s);
					}
				}
				stream.close();
				_Log("ExportToFile completed, file: " + filename );
				
			} catch (e:Error) {
				_Log("ExportToFile error:" + e.message );
			}
		}
		
		private function PostRequestSetup():void {
			var customHeader:Array =[
				new URLRequestHeader("Referer",Consts.POST_Referer), 
				new URLRequestHeader("x-flash-version",Consts.POST_FlashVersion)
			];
			_payItemRequest = new URLRequest(_apiUrl+Consts.PayItemAPI);
			_recordRequest = new URLRequest(_apiUrl+Consts.RecordAPI);
			_senkaRequest = new URLRequest(_apiUrl+Consts.SenkaAPI);
			_payItemVar = new URLVariables();
			_recordVar = new URLVariables();
			_senkaVar = new URLVariables();
			
			_payItemVar.api_token = _token;
			_payItemVar.api_verno = Consts.Magic_api_verno;
			
			_recordVar.api_token = _token;
			_recordVar.api_verno = Consts.Magic_api_verno;
			
			// add api ranking and pageNo on load function
			_senkaVar.api_token = _token;
			_senkaVar.api_verno = Consts.Magic_api_verno;
			// add api ranking and pageNo on load function
			
			_payItemRequest.method = URLRequestMethod.POST
			_recordRequest.method = URLRequestMethod.POST;
			_senkaRequest.method = URLRequestMethod.POST;
			_payItemRequest.userAgent = Consts.POST_UserAgent;
			_recordRequest.userAgent = Consts.POST_UserAgent;
			_senkaRequest.userAgent = Consts.POST_UserAgent;
			_payItemRequest.requestHeaders = customHeader;
			_recordRequest.requestHeaders = customHeader;
			_senkaRequest.requestHeaders = customHeader;
			_Log("PostRequestSetup completed.");
		}
		
		private function PostPayItemRequest(event:TimerEvent):void {
			// reset timer for futuer use
			_timer.removeEventListener(TimerEvent.TIMER, PostPayItemRequest);
			_timer = null;
			// reset timer for futuer use
			_payItemRequest.data = _payItemVar;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener("complete",PostCompleteHandler);
			_urlLoader.addEventListener("ioError",PostIOErrorHandler);
			_urlLoader.addEventListener("securityError",PostSecurityErrorHandler);
			_setDataFunc = SetPayItemData;
			try {
				_urlLoader.load(_payItemRequest); // send request to download data
				_Log("PostPayItemRequest has been posted.");
			} catch(e:Error) {
				_Log("Exception occured at PostPayItemRequest: " + e.message);
			}
		}
		
		private function PostRecordRequest(event:TimerEvent):void {
			// reset timer for futuer use
			_timer.removeEventListener(TimerEvent.TIMER, PostRecordRequest);
			_timer = null;
			// reset timer for futuer use
			_recordRequest.data = _recordVar;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener("complete",PostCompleteHandler);
			_urlLoader.addEventListener("ioError",PostIOErrorHandler);
			_urlLoader.addEventListener("securityError",PostSecurityErrorHandler);
			_setDataFunc = SetRecordData;
			try {
				_urlLoader.load(_recordRequest); // send request to download data
				_Log("PostRecordRequest has been posted.");
				
			} catch(e:Error) {
				_Log("Exception occured at PostRecordRequest: " + e.message);
			}
		}
		
		private function PostSenkaRequest(event:TimerEvent/*, pageNo:int = -1*/):void {
		
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener("complete",PostCompleteHandler);
			_urlLoader.addEventListener("ioError",PostIOErrorHandler);
			_urlLoader.addEventListener("securityError",PostSecurityErrorHandler);
			_setDataFunc = SetSenkaData;
			try {
				if(_curCachePage > 0 && _curCachePage < 100) _senkaVar["api_pageno"] = _curCachePage;
				if (_curCachePage > 100) throw ArgumentError;
				var kenGenFunc:Object = _keyGen._createKey();
				var memberId:int = parseInt(_memberId);
				if (isNaN(memberId)) throw ArgumentError;
				_senkaVar.api_ranking = _keyGen.__(memberId, _keyGen._createKey());
				_Log("api_ranking: " + _senkaVar["api_ranking"]);
				_senkaRequest.data = _senkaVar;
				_urlLoader.load(_senkaRequest); // send request to download data
				_Log("PostSenkaRequest has been posted.");
				
			} catch(e:Error) {
				_Log("Exception occured at PostSenkaRequest, page: " + _curCachePage +" - "+ e.message);
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, PostSenkaRequest);
				
			}
		}
		
		// dummy result for simulation purpose, api data should be null
		private function SetPayItemData(api_data:Object):void {
			if(api_data != null) {
				_Log("PayItem's api_data should be null: " + api_data);
				return;
			}
			_Log("SetPayItemData Completed.");
			_workerProgress += 5;
			
			// Stage 1 completed and start stage 2 for simulate click on player record
			_timer = new Timer(GetRandomNum(2000, 5000));
			_timer.addEventListener(TimerEvent.TIMER, PostRecordRequest);
			_timer.start();
		}
		
		// save record data (get player member ID)
		private function SetRecordData(api_data:Object):void {
			_userRecordData.setData(api_data);
			_memberId = _userRecordData.getMemberID();
			_Log("SetRecordData Completed.");
			_workerProgress += 5;
			
			// Stage 2 completed and start stage 3 for simulate click on ranking page 
			// default to player's ranking page
			_timer = new Timer(GetRandomNum(1500, 5000), _maxCachePage + 1/*plus player ranking page*/); // repeat max page need to cache
			_timer.addEventListener(TimerEvent.TIMER, PostSenkaRequest);
			_timer.start();
		}
		
		// save ranking data
		private function SetSenkaData(api_data:Object):void {
			var rankingData:RankingData = new RankingData();
			var memberId:int = parseInt(_memberId);
			rankingData.setData(memberId, api_data, _keyGen._l_, _keyGen._createKey); // decode here
			_rankDataList.push(rankingData); // sub 0 can be dropped, page start at sub 1
			_Log("SetSenkaData Completed. Page: " + (_curCachePage>0?_curCachePage:"player page"));
			_workerProgress += (90 / _maxCachePage);
			// increase page number here
			if (_curCachePage++ >= _maxCachePage) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, PostSenkaRequest);
				_timer = null;
				_currWorkingState = SenkaWorkerStates.eFinished;
				
				// todo remove later
				ExportToFile("senka.csv");
			}
		}
		
		private function PostCompleteHandler(event:Event):void {
			_urlLoader.removeEventListener("complete",PostCompleteHandler);
			_urlLoader.removeEventListener("ioError",PostIOErrorHandler);
			_urlLoader.removeEventListener("securityError",PostSecurityErrorHandler);
			var postResult:String = String(event.target.data);
			var jsonArr:Array = postResult.match(/svdata=(.*)/);
			var api_data:* = "";
			if(jsonArr && jsonArr.length > 1) {
				api_data = jsonArr[1];
				
			} else if(!jsonArr) {
				api_data = postResult;
				
			} else {
				_Log("API result parse error - " + event);
				return;
			}
			_resultJson = null;
			try {
				_resultJson = JSON.parse(api_data);
			} catch(e:Error) {
				_Log("JSON result parse error - " + e.message);
				return;
			}
			if(_resultJson.api_result != 1) {
				_Log("API returned failed. Error code: " + _resultJson.api_result);
			}
			_setDataFunc(_resultJson.api_data);
		}
		
		private function PostIOErrorHandler(event:IOErrorEvent):void {
			_Log("Error! PostIOErrorHandler: " + event);
			_urlLoader.removeEventListener("complete",PostCompleteHandler);
			_urlLoader.removeEventListener("ioError",PostIOErrorHandler);
			_urlLoader.removeEventListener("securityError",PostSecurityErrorHandler);
		}
		
		private function PostSecurityErrorHandler(event:SecurityErrorEvent):void {
			_Log("Error! PostSecurityErrorHandler: " + event);
			_urlLoader.removeEventListener("complete",PostCompleteHandler);
			_urlLoader.removeEventListener("ioError",PostIOErrorHandler);
			_urlLoader.removeEventListener("securityError",PostSecurityErrorHandler);
		}
		
	}
}