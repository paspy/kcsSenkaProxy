package kcsCore
{
	public class Util
	{
		public function Util()
		{
			super();
		}
		
		public static function getInt(param1:Object, param2:String, param3:int = 0) : int
		{
			return _getProp(param1,param2,param3);
		}
		
		public static function getNumber(param1:Object, param2:String, param3:Number = 0.0) : Number
		{
			return _getProp(param1,param2,param3);
		}
		
		public static function getString(param1:Object, param2:String, param3:String = "") : String
		{
			var _loc4_:* = _getProp(param1,param2,param3);
			if(_loc4_ == null && param3 != null)
			{
				_loc4_ = param3;
			}
			return _loc4_;
		}
		
		public static function getBooleanFromInt(param1:Object, param2:String, param3:Boolean = false) : Boolean
		{
			return getInt(param1,param2,!!param3?1:0) == 1;
		}
		
		public static function getArray(param1:Object, param2:String, param3:Array = null) : Array
		{
			var _loc4_:Array = _getProp(param1,param2,param3);
			return !!_loc4_?_loc4_:param3;
		}
		
		public static function getObject(param1:Object, param2:String, param3:Object = null) : Object
		{
			var _loc4_:* = _getProp(param1,param2,param3);
			if(_loc4_ == null && param3 != null)
			{
				_loc4_ = param3;
			}
			return _loc4_;
		}
		
		private static function _getProp(param1:Object, param2:String, param3:*) : *
		{
			if(param1 && param1.hasOwnProperty(param2))
			{
				return param1[param2];
			}
			return param3;
		}
		
		public static function overWrite(param1:Object, param2:Object) : void
		{
			var _loc4_:* = undefined;
			var _loc5_:int = 0;
			var _loc7_:int = 0;
			var _loc6_:* = param2;
			for(var _loc3_:* in param2)
			{
				_loc5_++;
				_loc4_ = param2[_loc3_];
				if(_loc4_ is Boolean || _loc4_ is int || _loc4_ is Number || _loc4_ is String || _loc4_ is uint)
				{
					param1[_loc3_] = _loc4_;
				}
				else if(_loc4_ is Array)
				{
					param1[_loc3_] = _loc4_;
				}
				else if(_loc4_.constructor == Object)
				{
					if(param1[_loc3_] == null)
					{
						param1[_loc3_] = {};
					}
					Util.overWrite(param1[_loc3_],param2[_loc3_]);
				}
				else
				{
					param1[_loc3_] = _loc4_;
				}
			}
		}
		
		public static function toArrayFromVector(param1:*) : Array
		{
			var _loc3_:int = 0;
			var _loc2_:Array = [];
			_loc3_ = 0;
			while(_loc3_ < param1.length)
			{
				_loc2_.push(param1[_loc3_]);
				_loc3_++;
			}
			return _loc2_;
		}
		
		public static function formatNewLine(param1:String) : String
		{
			var _loc2_:Array = param1.split("<br>");
			return _loc2_.join("\n");
		}
		
		public static function f(param1:int, param2:int = 0) : String
		{
			var _loc5_:Object = cO(0);
			var _loc4_:* = arguments;
			_loc5_[{}] = 1;
			_loc5_[_loc4_] = _loc5_[_loc5_[_loc5_]][_loc5_[_loc5_[_loc5_] >> _loc5_[_loc5_]][_loc5_[_loc5_] >> _loc5_[_loc5_]](_loc5_[_loc5_],_loc5_[_loc5_])];
			return _loc5_[_loc5_[_loc5_]][_loc5_[_loc4_]([])](_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])](_loc4_[_loc5_[_loc4_]([])]),_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_[_loc5_]][_loc5_[_loc4_]([])](_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](!{})[_loc5_[_loc4_]([])],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](!!{})[_loc5_[_loc5_]],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](_loc5_)[_loc5_[_loc5_]],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc4_]([])])[_loc5_[_loc4_]([][{}])],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_]))])[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc4_](!{}),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_]))],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_]])[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])](_loc5_[_loc4_](!{}),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_]))],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](!{})[_loc5_[_loc5_]],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](!!{})[_loc5_[_loc5_]],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_]))])[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc4_](!!{}),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_](!!{})](_loc5_[_loc4_](_loc5_),_loc5_[_loc4_](!!{})))],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_]](_loc5_)[_loc5_[_loc5_]],_loc5_[_loc5_[_loc5_]][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_]))](_loc5_[_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])]([][{}]),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_]),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])))](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_](!!{})](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])](_loc4_[_loc5_[_loc4_]([])],_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](s(_loc4_[_loc5_[_loc4_]([])]),_loc5_[_loc5_])),!!_loc4_[_loc5_[_loc5_]]?_loc4_[_loc5_[_loc5_]]:_loc5_[_loc4_]([])),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc4_](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])]),_loc5_[_loc4_](!!{}))),_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])](_loc5_[_loc5_],_loc5_[_loc5_])](_loc5_[_loc4_](_loc5_[_loc5_[_loc4_]([])][_loc5_[_loc4_]([])]),_loc5_[_loc4_](!!{})),_loc5_[_loc4_]([][{}])))));
		}
		
		public static function s(param1:int) : int
		{
			var _loc4_:Object = cO(0);
			var _loc3_:* = arguments;
			_loc4_[{}] = 1;
			_loc4_[_loc3_] = _loc4_[_loc4_[_loc4_]][_loc4_[_loc4_[_loc4_] >> _loc4_[_loc4_]][_loc4_[_loc4_] >> _loc4_[_loc4_]](_loc4_[_loc4_],_loc4_[_loc4_])];
			_loc4_[{}] = _loc4_[_loc4_[_loc3_]([])][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc4_],_loc4_[_loc4_])](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc4_],_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc4_],_loc4_[_loc4_]))][_loc4_[_loc3_]([])](_loc4_[_loc4_[_loc4_]][_loc4_[_loc4_]](_loc3_[_loc4_[_loc3_]([])])),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc4_],_loc4_[_loc4_]));
			return _loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_],_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))) < _loc4_[_loc4_[_loc3_]([])][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc3_](!{}))?_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_],_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))):_loc3_[_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc3_]([])](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))][_loc4_[_loc3_]([])])[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))],_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))][_loc4_[_loc3_]([])])[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))],_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))][_loc4_[_loc3_]([])])[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))],_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))][_loc4_[_loc3_]([])])[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))],_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))][_loc4_[_loc3_]([])])[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc3_]([][{}]),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))],_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))][_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))](_loc4_[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))][_loc4_[_loc3_]([])])[_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])](_loc4_[_loc3_]([][{}]),_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{})))])](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!{})](_loc4_[_loc4_],_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_](!!{})](_loc4_[_loc3_](_loc4_[_loc4_[_loc3_]([])][_loc4_[_loc3_]([])]),_loc4_[_loc3_](!{}))));
		}
		
//		public static function $$(param1:Object) : void
//		{
//			var _loc3_:_APIBaseS_ = new _APIBaseS_();
//			var _loc2_:* = _$();
//			var result:* = _loc2_[/./(/.....$/((~[][{}])[/./(/.. /({})) + /.$/(/../({})) + /./(/./([])) + /./(/..$/(!{})) + /.../(!!{}) + /../(/.. /({})) + /.$/(/../({})) + /.$/(/../(!!{}))]))](_loc2_[/.$/([][{}])] / _loc2_[/./(/..$/(!{}))]) + _loc2_[/.$/(/../([][{}]))] + _loc2_[/.$/(/.../({}))](_loc2_[/./(!!{})](_loc2_[/.$/(/.../({}))](_loc2_[/./(!!{})](_loc2_[/.$/(!{})](_loc2_[/./(/.....$/((~[][{}])[/./(/.. /({})) + /.$/(/../({})) + /./(/./([])) + /./(/..$/(!{})) + /.../(!!{}) + /../(/.. /({})) + /.$/(/../({})) + /.$/(/../(!!{}))]))](param1[_loc2_[/./(/...$/(/./[/./(/.. /({})) + /.$/(/../({})) + /./(/./([])) + /./(/..$/(!{})) + /.../(!!{}) + /../(/.. /({})) + /.$/(/../({})) + /.$/(/../(!!{}))]))]]),_loc2_[/./(/..$/(!{}))]),_loc2_[/./(/..$/(!{}))]),_loc2_[/.$/(/../(!{}))]),_loc2_[/./(!!{})](_loc2_[/.$/(!{})](_loc2_[/./(/.....$/((~[][{}])[/./(/.. /({})) + /.$/(/../({})) + /./(/./([])) + /./(/..$/(!{})) + /.../(!!{}) + /../(/.. /({})) + /.$/(/../({})) + /.$/(/../(!!{}))]))](param1[_loc2_[/./(/..$/([][/./(/.. /({})) + /.$/(/../({})) + /./(/./([])) + /./(/..$/(!{})) + /.../(!!{}) + /../(/.. /({})) + /.$/(/../({})) + /.$/(/../(!!{}))]))]]),_loc2_[/./(/..$/(!{}))]),_loc2_[/./(/..$/(!{}))])),_loc3_.__l());
//		}
		
		private static function _$() : Object
		{
			var ret:Object = {};
			ret.a = (/..$/(/...../(~(~[][{}] << ~[][{}]))) | /./(/..$/(~(~[][{}] << ~[][{}])))) << /.$/(~(~[][{}] << ~[][{}])) | /./(~(~[][{}] << ~[][{}])) << /./(/....$/(~(~[][{}] << ~[][{}])));
			ret.b = function(param1:Number, param2:Number):Number
			{
				return param1 * param2;
			};
			ret.c = new Date()["milliseconds"];
			ret.d = new Date()["time"];
			ret.e = function(param1:Number, param2:Number):Number
			{
				return param1 % param2;
			};
			ret.j = function(... rest):String
			{
				return rest["join"]("");
			};
			ret.k = function(param1:Number, param2:Number):Number
			{
				return Math["sqrt"](param1 * param1 + param2 * param2);
			};
			ret.l = "length";
			ret.m = function(param1:Number):Number
			{
				return Math["floor"](param1);
			};
			ret.n = "";
			ret.q = function(param1:Number):Number
			{
				return ret.m(Math["sqrt"](param1));
			};
			ret.s = (/../(~(~[][{}] << ~[][{}])) << /./(~(~[][{}] << ~[][{}])) | /../(/.....$/(~(~[][{}] << ~[][{}]))) >> (~[][{}] >>> ~[][{}])) << /./(/....$/(~(~[][{}] << ~[][{}])));
			ret.t = function(param1:Number, param2:Number):Number
			{
				return param1 + param2;
			};
			ret.x = "mouseX";
			ret.y = "mouseY";
			return ret;
		}
		
		public static function cO(param1:int = 0) : Object
		{
			var k:int = param1;
			if(!int(k))
			{
				return {
					0:[function(param1:int, param2:int):int
					{
						return param1 + param2;
					},function(param1:int, param2:int):int
					{
						return param1 - param2;
					},function(param1:int, param2:int):int
					{
						return param1 * param2;
					},function(param1:int, param2:int):int
					{
						return Math.round(param1 / param2);
					},function(param1:int, param2:int):int
					{
						return param1 % param2;
					},function(param1:int, param2:int):int
					{
						return Math.floor(param1 / param2);
					}],
					1:[function(... rest):String
					{
						return rest.join("");
					},function(param1:String):Array
					{
						return param1.split("");
					},function(param1:*):int
					{
						return String(param1).length;
					},function(param1:String, param2:int, param3:int):String
					{
						return param1.substr(param2,param3);
					}],
					2:[Number,Math,String,Class,RegExp,Array,int],
					3:[function(param1:Array):int
					{
						var _loc3_:int = 0;
						var _loc2_:int = 0;
						_loc3_ = 0;
						while(_loc3_ < param1.length)
						{
							_loc2_ = _loc2_ + int(param1[_loc3_]);
							_loc3_++;
						}
						return _loc2_;
					}]
				};
			}
			return {};
		}
	}
}