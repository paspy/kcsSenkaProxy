package kcsSenka {
	import flash.utils.ByteArray;

    public final class Consts_Utils {
        public static const LocalIP:String = "127.0.0.1";
        public static const DefaultPort:int = 12315;
        public static const TargetPort:int = 12316;

        public static const RequestRankingAPI:String = "kcsRequestAPIRanking";
        public static const EncodedRankingAPI:String = "kcsEncodedAPIRanking";

        public static const PayItemAPI:String = "api_get_member/payitem";
        public static const RecordAPI:String = "api_get_member/record";
        public static const SenkaAPI:String = "api_req_ranking/mxltvkpyuklh";
        public static const Magic_api_verno:int = 1;
        public static const RankName:Array = ["", "元帥", "大将", "中将", "少将", "大佐", "中佐", "新米中佐", "少佐", "中堅少佐", "新米少佐"];

        public static const Server_Info:String = "203.104.209.7"; //ランキング画像など

		public static const Servers:Object = {
			server_01:{address:"203.104.209.71",	name:"横須賀鎮守府"},
			server_02:{address:"203.104.209.87",	name:"呉鎮守府"},
			server_03:{address:"125.6.184.16",	name:"佐世保鎮守府"},
			server_04:{address:"125.6.187.205",	name:"舞鶴鎮守府"},
			server_05:{address:"125.6.187.229",	name:"大湊警備府"},
			server_06:{address:"125.6.187.253",	name:"トラック泊地"},
			server_07:{address:"125.6.188.25",	name:"リンガ泊地"},
			server_08:{address:"203.104.248.135",	name:"ラバウル基地"},
			server_09:{address:"125.6.189.7",		name:"ショートランド泊地"},
			server_10:{address:"125.6.189.39",	name:"ブイン基地"},
			server_11:{address:"125.6.189.71",	name:"タウイタウイ泊地"},
			server_12:{address:"125.6.189.103",	name:"パラオ泊地"},
			server_13:{address:"125.6.189.135",	name:"ブルネイ泊地"},
			server_14:{address:"125.6.189.167",	name:"単冠湾泊地"},
			server_15:{address:"125.6.189.215",	name:"幌筵泊地"},
			server_16:{address:"125.6.189.247",	name:"宿毛湾泊地"},
			server_17:{address:"203.104.209.23",	name:"鹿屋基地"},
			server_18:{address:"203.104.209.39",	name:"岩川基地"},
			server_19:{address:"203.104.209.55",	name:"佐伯湾泊地"},
			server_20:{address:"203.104.209.102",	name:"柱島泊地"}
		};
		
		public static const ServerNameToAddr:Object = {
			"横須賀鎮守府"		:"203.104.209.71",
			"呉鎮守府"			:"203.104.209.87",
			"佐世保鎮守府"		:"125.6.184.16",		
			"舞鶴鎮守府"		:"125.6.187.205",	
			"大湊警備府"		:"125.6.187.229",	
			"トラック泊地"		:"125.6.187.253",	
			"リンガ泊地"		:"125.6.188.25",		
			"ラバウル基地"		:"203.104.248.135",
			"ショートランド泊地":"125.6.189.7",		
			"ブイン基地"		:"125.6.189.39",		
			"タウイタウイ泊地"	:"125.6.189.71",		
			"パラオ泊地"		:"125.6.189.103",	
			"ブルネイ泊地"		:"125.6.189.135",	
			"単冠湾泊地"		:"125.6.189.167",	
			"幌筵泊地"			:"125.6.189.215",	
			"宿毛湾泊地"		:"125.6.189.247",	
			"鹿屋基地"			:"203.104.209.23",
			"岩川基地"			:"203.104.209.39",
			"佐伯湾泊地"		:"203.104.209.55",
			"柱島泊地"			:"203.104.209.102"
		};
		
        public static const POST_UserAgent:String = "Mozilla/5.0 (Android; U; zh-CN) AppleWebKit/533.19.4 (KHTML, like Gecko) AdobeAIR/21.0 rqxbjmdizgzp";
        public static const POST_Referer:String = "app:/AppMain.swf/[[DYNAMIC]]/1";
        public static const POST_FlashVersion:String = "21,0,0,174";

        public static const COLOR_Red:uint = 0xFF0000;
        public static const COLOR_Green:uint = 0x00FF00;
        public static const COLOR_Blue:uint = 0x0000FF;
        public static const COLOR_White:uint = 0xFFFFFF;
        public static const COLOR_Black:uint = 0x000000;

		public static function GetSortedPairs(object:Object):Array {
			var sorted:Array = [];
			for(var i:String in object) {
				sorted.push({ key: i, value: object[i] });
			}
			sorted.sortOn("key");
			return sorted;
		}
		
		public static function GetTokyoTime() : Date {
			var now:Date = new Date();
//			var df:DateTimeFormatter = new DateTimeFormatter("ja", DateTimeStyle.SHORT, DateTimeStyle.MEDIUM); 
			var tokyoTimeOffsetInMs:Number = 1000 * 60 * 60 * (+9); // GMT +9
			var utcTimeOfsetInMs:Number = now.getTimezoneOffset() * 60 * 1000;
			now.setTime(now.getTime() + utcTimeOfsetInMs + tokyoTimeOffsetInMs);
			return now;
		}
		
		public static function GetRandomNum(minLimit:int, maxLimit:int):Number {
			return Math.ceil(Math.random() * (maxLimit - minLimit)) + minLimit;
		}
		
		public static function CloneObject(source:*):* {
			if(source==null){
				throw new Error("null isn't a legal serialization candidate.");
			}
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			return bytes.readObject();
		}
		
        // custom decoder
		// Source: 
		// http://ch.nicovideo.jp/arisu_yaya/blomaga/ar941858
		// https://github.com/yukixz/kctools/blob/master/rank.py
        private static const Magic_R:Array = [8931, 1201, 1156, 5061, 4569, 4732, 3779, 4568, 5695, 4619, 4912, 5669, 6586];
        private static const Magic_M:Array = [10784, 3054, 3009, 6914, 6422, 6585, 5632, 6421, 7548, 6472, 6765, 7522, 8439];
		private static const Magic_Il_OLD:Array =
			[7732, 7148, 6663, 2139, 9018, 4132653, 1033183, 4359, 5224, 8390, 13, 5238, 3791, 10, 8268, 4654, 1000, 1875979];
		private static const Magic_Il2:Array =
			[4294, 9077, 9707, 2139, 5643, 4132653, 1033183, 8560, 7973, 9025, 13, 4164, 3791, 10, 8809, 8357, 1000, 1875979];
		private static const Magic_Il:Array =
			[/../(/...$/(~(~[][{}] << ~[][{}]))) << /./(/...$/(~(~[][{}] << ~[][{}]))) | /../(/......$/(~(~[][{}] << ~[][{}]))) << /./(~(~[][{}] << ~[][{}])) | /./(/...$/(~(~[][{}] << ~[][{}]))),(/.........$/(~(~[][{}] << ~[][{}])) >> ((/.$/(~[][{}] << ~[][{}]) | ~[][{}] >>> ~[][{}]) << (~[][{}] >>> ~[][{}])) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}])) << /./(/..$/(~(~[][{}] << ~[][{}]))) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]),/..../(/......$/(~(~[][{}] << ~[][{}]))) << (~[][{}] >>> ~[][{}]) | /../(~(~[][{}] << ~[][{}])) << (~[][{}] >>> ~[][{}]) | ~[][{}] >>> ~[][{}],/..../(~(~[][{}] << ~[][{}])) & ~(/.$/(~[][{}] << ~[][{}]) << /./(~(~[][{}] << ~[][{}]))) | /.../(~(~[][{}] << ~[][{}])) >> /./(/....$/(~(~[][{}] << ~[][{}]))),/..$/(/..../(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])) << (/.$/(~[][{}] << ~[][{}]) | ~[][{}] >>> ~[][{}]) | /..$/(/..../(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])),(/...$/(/...../(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])) | /.$/(~[][{}] << ~[][{}])) << /..$/(/.../(~(~[][{}] << ~[][{}]))) << (~[][{}] >>> ~[][{}]) | /.../(/......$/(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])) << (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]) | /.../(/....$/(~(~[][{}] << ~[][{}]))) >> /./(/....$/(~(~[][{}] << ~[][{}]))),(/....$/(/...../(~(~[][{}] << ~[][{}]))) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]) << (/.$/(~[][{}] << ~[][{}]) | ~[][{}] >>> ~[][{}])) << /.$/(~[][{}] << ~[][{}]) | /./(~(~[][{}] << ~[][{}])) | /../(/....$/(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])) | (/.$/(~[][{}] << ~[][{}]) | /.../(/......$/(~(~[][{}] << ~[][{}])))) << (~[][{}] >>> ~[][{}]),/..../(~(~[][{}] << ~[][{}])) >> /./(/...$/(~(~[][{}] << ~[][{}]))) << /.$/(~[][{}] << ~[][{}]) | /....$/(/...../(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])),(/.../(/......$/(~(~[][{}] << ~[][{}]))) >> (~[][{}] >>> ~[][{}]) | /.$/(~[][{}] << ~[][{}])) << (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]),/.........$/(~(~[][{}] << ~[][{}])) >> /../(~(~[][{}] << ~[][{}])) << /.$/(~(~[][{}] << ~[][{}])) | /../(/...$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}],/.$/(~[][{}] << ~[][{}]) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]),/../(/...$/(~(~[][{}] << ~[][{}]))) | /../(/...$/(~(~[][{}] << ~[][{}]))) << /./(/...$/(~(~[][{}] << ~[][{}]))) | /./(/..$/(~(~[][{}] << ~[][{}]))),/.../(/......$/(~(~[][{}] << ~[][{}]))) >> (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]) | /...$/(/...../(~(~[][{}] << ~[][{}]))) >> /./(~(~[][{}] << ~[][{}])) << (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]),/./(~(~[][{}] << ~[][{}])) | /.$/(~[][{}] << ~[][{}]),/../(/...$/(~(~[][{}] << ~[][{}]))) << /.$/(~(~[][{}] << ~[][{}])) | /...$/(/..../(~(~[][{}] << ~[][{}]))) >> (~[][{}] >>> ~[][{}]) << /./(/....$/(~(~[][{}] << ~[][{}]))) | /../(/.....$/(~(~[][{}] << ~[][{}]))) >> (~[][{}] >>> ~[][{}]),/..../(/.....$/(~(~[][{}] << ~[][{}]))) >> /./(/..$/(~(~[][{}] << ~[][{}]))) << /./(/..$/(~(~[][{}] << ~[][{}]))) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}]),/..$/(/.../(~(~[][{}] << ~[][{}]))) << /./(/...$/(~(~[][{}] << ~[][{}]))) | /.../(~(~[][{}] << ~[][{}])) >> /./(/....$/(~(~[][{}] << ~[][{}]))) << /./(~(~[][{}] << ~[][{}])),(/..$/(/.../(~(~[][{}] << ~[][{}]))) << /./(/..$/(~(~[][{}] << ~[][{}]))) | (/./(/..$/(~(~[][{}] << ~[][{}]))) | ~[][{}] >>> ~[][{}])) << /..$/(/.../(~(~[][{}] << ~[][{}]))) >> (~[][{}] >>> ~[][{}]) | /.$/(~[][{}] << ~[][{}]) | /./(/....$/(~(~[][{}] << ~[][{}])))];
		
		public static function DecodeRateAndMedal(memberId:Number, rankNo:Number, maskedRate:Number, maskedMedal:Number):Object {
			var I1_func:Function = function I1(param1:int):int {
				if (param1 === 0) {
					return 1;
				}
				const s_sqrt13:String = Math.sqrt(13).toString();
				return s_sqrt13.indexOf(param1.toString());
			}
			
			var _l_:Function = function _l_(memberId, firstTwo = false): Number {
				const magicNum:Number = Magic_Il[I1_func(memberId % 10)];
				return firstTwo ? parseInt(magicNum.toString().substr(0/* NaN */, 2)) : magicNum;
			}
			
			var magic_l:Array = [];
			for (var i:int = 0; i < 10; i++) {
				magic_l.push(_l_(i, true))
			}
			
			var r:Number = Magic_R[rankNo % 13];
            var m:Number = Magic_M[rankNo % 13];
            var l:Number = magic_l[memberId % 10];
            var rateAndMedal:Object = new Object();
            rateAndMedal.rate = maskedRate / (r * l) - 73.0 - 18.0;
            rateAndMedal.medal = maskedMedal / m - 157.0;
            return rateAndMedal;
        }
		
        public function Consts_Utils() {
            super();
        }
    }
}
