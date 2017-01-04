package
{
	import flash.display.Sprite;
	
	import kcsCore._APIBaseS_;
	
	import kcsRecordMain.RankData;
	import kcsRecordMain.RankingData;
	import kcsSenka.Consts;
	
	public class kcsSenkaTester extends Sprite
	{
		
		
		
		private var keyGen:_APIBaseS_;
		private var rankData:RankData;
		public function kcsSenkaTester()
		{
			var memberId:int = 9100297;
			var api_data:* = "";
			var raw:String = 
				"svdata={\"api_result\":1,\"api_result_msg\":\"\u6210\u529f\"," +
				"\"api_data\":{\"api_count\":1000,\"api_page_count\":100,\"api_disp_page\":16411," +
				"\"api_list\":" +
				"[{\"api_mxltvkpyuklh\":1," +
				"\"api_mtjmdcwtvhdr\":\"影\"," +
				"\"api_pbgkfylkbjuy\":0," +
				"\"api_pcumlrymlujh\":1," +
				"\"api_itbrdpdbkynm\":\"\"," +
				"\"api_itslcqtmrxtf\":479478," +
				"\"api_wuhnhojjxmke\":61786646}]}}";
			
			var jsonArr:Array = raw.match(/svdata=(.*)/);
			
			if(jsonArr && jsonArr.length > 1) {
				api_data = jsonArr[1];
				
			} else if(!jsonArr) {
				api_data = raw;
				
			} else {
				return;
			}
			
			var json:Object = JSON.parse(api_data);
			
			keyGen = new _APIBaseS_();
			var rankingData:RankingData = new RankingData();
//			rankingData.setData(memberId, api_data, keyGen._l_, keyGen._createKey);
			var data:Object = new Object();
			data['api_itbrdpdbkynm'] = "";
			data['api_itslcqtmrxtf'] = 496485;
			data['api_mtjmdcwtvhdr'] = "2";
			data['api_mxltvkpyuklh'] = 2;
			data['api_pbgkfylkbjuy'] = 0;
			data['api_pcumlrymlujh'] = 1;
			data['api_wuhnhojjxmke'] = 29880288;
			
			var rankd:* = new RankData(memberId, data,keyGen._l_,keyGen._createKey);
//			var r:* = keyGen._l_(memberId,keyGen._createKey(),true);
			
			var r:Object = Consts.DecodeRateAndMedal(memberId, data["api_mxltvkpyuklh"], data["api_wuhnhojjxmke"], data["api_itslcqtmrxtf"]);
			trace();
			
		}
	}
}