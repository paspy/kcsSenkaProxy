package kcsCore
{
	public class UserRecordData
	{

		private var _obj:Object;
		
		public function UserRecordData()
		{
			_obj = {};
			super();
		}
		
		public function setData(param1:Object) : void
		{
			_obj = param1;
		}
		
		public function getMemberID() : String
		{
			return Util.getString(_obj,"api_member_id");
		}

//		public function getComment() : String
//		{
//			return Util.getString(_obj,"api_cmt","");
//		}
//		
//		public function getExperienceNext() : int
//		{
//			return Util.getArray(_obj,"api_experience",[0,0])[1];
//		}
//		
//		public function getSallyWin() : int
//		{
//			return Util.getInt(_getSallyData(),"api_win",0);
//		}
//		
//		public function getSallyLose() : int
//		{
//			return Util.getInt(_getSallyData(),"api_lose",0);
//		}
//		
//		public function getSallyRate() : int
//		{
//			var _loc2_:String = Util.getString(_getSallyData(),"api_rate","0.00");
//			var _loc1_:Number = parseFloat(_loc2_);
//			return !!isNaN(_loc1_)?0:Number(Math.round(_loc1_ * 100));
//		}
//		
//		public function getPracticeWin() : int
//		{
//			return Util.getInt(_getPracticeData(),"api_win",0);
//		}
//		
//		public function getPraceticeLose() : int
//		{
//			return Util.getInt(_getPracticeData(),"api_lose",0);
//		}
//		
//		public function getPracticeRate() : int
//		{
//			var _loc2_:String = Util.getString(_getPracticeData(),"api_rate","0.00");
//			var _loc1_:Number = parseFloat(_loc2_);
//			return !!isNaN(_loc1_)?0:Number(Math.round(_loc1_));
//		}
//		
//		public function getMissionCount() : int
//		{
//			return Util.getInt(_getMissionData(),"api_count",0);
//		}
//		
//		public function getMissionSuccess() : int
//		{
//			return Util.getInt(_getMissionData(),"api_success",0);
//		}
//		
//		public function getMissionRate() : int
//		{
//			var _loc2_:String = Util.getString(_getMissionData(),"api_rate","0.00");
//			var _loc1_:Number = parseFloat(_loc2_);
//			return !!isNaN(_loc1_)?0:Number(Math.round(_loc1_));
//		}
//		
//		public function getMaterialMaxCount() : int
//		{
//			return Util.getInt(_obj,"api_material_max",0);
//		}
//		
//		private function _getSallyData() : Object
//		{
//			return Util.getObject(_obj,"api_war",{});
//		}
//		
//		private function _getPracticeData() : Object
//		{
//			return Util.getObject(_obj,"api_practice",{});
//		}
//		
//		private function _getMissionData() : Object
//		{
//			return Util.getObject(_obj,"api_mission",{});
//		}
	}
}