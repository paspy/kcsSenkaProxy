package kcsRecordMain
{
	public class RankingData
	{
		private var _o:Object;
		
		private var _list:Vector.<RankData>;
		
		public function RankingData()
		{
			super();
		}
		
		public function get count() : int
		{
			return _getInt(_o,"api_count",0);
		}
		
		public function get pageCount() : int
		{
			return _getInt(_o,"api_page_count",0);
		}
		
		public function get pageNo() : int
		{
			return _getInt(_o,"api_disp_page",0);
		}
		
		public function get list() : Vector.<RankData>
		{
			return _list;
		}
		
		public function setData(memberId:int, param1:Object, param2:Function = null, param3:Function = null) : void
		{
			var _loc6_:int = 0;
			var _loc4_:* = null;
			_o = param1;
			_list = new Vector.<RankData>();
			var _loc5_:Array = _getArray(_o,"api_list",[]);
			_loc6_ = 0;
			while(_loc6_ < _loc5_.length)
			{
				_loc4_ = new RankData(memberId,_loc5_[_loc6_],param2,param3);
				_list.push(_loc4_);
				_loc6_++;
			}
		}
		
		 
		// below functions extract from BaseData
		protected function _getInt(param1:Object, param2:String, param3:int = 0) : int
		{
			return _getProp(param1,param2,param3);
		}
		
		protected function _getNumber(param1:Object, param2:String, param3:Number = 0.0) : Number
		{
			return _getProp(param1,param2,param3);
		}
		
		protected function _getString(param1:Object, param2:String, param3:String = "") : String
		{
			return _getProp(param1,param2,param3);
		}
		
		protected function _getBoolean(param1:Object, param2:String, param3:Boolean = false) : Boolean
		{
			return _getString(param1,param2,!!param3?"true":"false") == "true";
		}
		
		protected function _getArray(param1:Object, param2:String, param3:Array = null) : Array
		{
			var _loc4_:Array = _getProp(param1,param2,param3);
			return !!_loc4_?_loc4_:param3;
		}
		
		protected function _getObject(param1:Object, param2:String, param3:Object = null) : Object
		{
			return _getProp(param1,param2,param3);
		}
		
		protected function _getProp(param1:Object, param2:String, param3:*) : *
		{
			if(param1 && param1.hasOwnProperty(param2))
			{
				return param1[param2];
			}
//			Debug.log("[W] no property " + param2);
			return param3;
		}
	}
}