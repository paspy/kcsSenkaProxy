package kcsRecordMain
{
    import kcsCore.Util;
    import kcsSenka.Consts_Utils;
	
	public class RankData
	{
		
		
		private var _o:Object;
		
		public function RankData(memberId:int, param1:Object, param2:Function = null, param3:Function = null)
		{
			var o:Object = param1;
			var f1:Function = param2;
			var f2:Function = param3;
			super();
			_o = o;
			if(f1 != null)
			{
				var $:* = this;
				var k:* = f2();
//				var j:* = [];
//				j.a = function(param1:String):Number
//				{
//					try
//					{
//						var _loc3_:* = param1.charCodeAt(0);
//						return _loc3_;
//					}
//					catch(b:*)
//					{
//						var _loc4_:* = b;
//						return _loc4_;
//					}
//				};
//				j.b = function(param1:Number):String
//				{
//					try
//					{
//						var _loc3_:* = String.fromCharCode(param1);
//						return _loc3_;
//					}
//					catch(b:*)
//					{
//						var _loc4_:* = b;
//						return _loc4_;
//					}
//				};
//				j.c = function(param1:Number, param2:Number):Number
//				{
//					return param2 >> param1;
//				};
//				j.d = function(param1:Number, param2:Number):Number
//				{
//					return param1 << param2;
//				};
//				j.e = function(param1:*, param2:*):*
//				{
//					try
//					{
//						param1(param2);
//					}
//					catch(e:*)
//					{
//						var _loc4_:* = /.*/(e);
//						return _loc4_;
//					}
//					return param1;
//				};
				
				var r:Object = Consts_Utils.DecodeRateAndMedal(memberId, o["api_mxltvkpyuklh"], o["api_wuhnhojjxmke"], o["api_itslcqtmrxtf"]);
				o["rate"] = r.rate;
				o["medal"] = r.medal;
//				o["rate"] = k.u(k.o(f1(memberId,k,true),k.o([k.t(k.t(k.o(k.w(),k.v()),k.o(k.w(),k.b(k.q()))),k.t(k.u(k.w(),k.b(k.u(![],![]))),k.y(k.q()))),k.u(k.y(k.q()),k.t(k.z(k.m(k.v(),k.x()),k.z(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w())))))),k.r(k.o(k.k(k.x(),k.v()),k.w())))),k.m(k.t(k.v(),k.v()),k.z(k.u(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.r(k.u(k.y(k.b(k.n())),k.x()))),k.z(k.m(k.o(k.w(),k.v()),k.o(k.w(),k.b(k.q()))),k.u(k.w(),k.b(k.u(![],![]))))),k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))))),k.m(k.t(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))),k.y(k.q())),k.z(k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))),k.z(k.b(k.w()),k.x()))),k.t(k.z(k.b(k.w()),k.x()),k.t(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.o(k.w(),k.m(k.k(k.p(k.r(k.b(k.q()) / k.x()),k.w()),k.v()),k.u(k.w(),k.x())))),k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.w(),k.b(k.u(![],![]))))),k.u(k.t(k.z(k.o(k.w(),k.m(k.k(k.p(k.r(k.b(k.q()) / k.x()),k.w()),k.v()),k.u(k.w(),k.x()))),k.r(k.u(k.y(k.b(k.n())),k.x()))),k.y(k.q()),k.y(k.q())),k.t(k.m(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.o(k.w(),k.v())),k.z(k.b(k.w()),k.x())),k.y(k.q()))),k.t(k.u(k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w())))),k.y(k.q())),k.m(k.o(k.w(),k.v()),k.y(k.q())),k.u(k.z(k.b(k.w()),k.x()),k.u(k.w(),k.b(k.u(![],![])))),k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.w(),k.b(k.u(![],![]))))),k.t(k.x(),k.r(k.u(k.y(k.b(k.n())),k.x())) * k.j(),k.j()),k.t(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.o(k.w(),k.v())),k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.w(),k.b(k.u(![],![])))),k.u(k.x(),k.y(k.q()))),k.t(k.r(k.u(k.y(k.b(k.n())),k.x())) * k.b(k.t(k.b(k.q()),k.b(k.q()),k.b(k.q()))) + k.z(k.b(k.w()),k.x()),k.u(k.w(),k.b(k.u(![],![]))) * k.b(k.t(k.b(k.q()),k.b(k.q()),k.b(k.q()))) + k.y(k.q())),k.t(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.r(k.u(k.y(k.b(k.n())),k.x()))),k.y(k.q()),k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w()))))),k.u(k.r(k.t(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.o(k.w(),k.v())),k.u(k.z(k.o(k.w(),k.v()),k.o(k.w(),k.v())),k.o(k.k(k.v(),k.x()),k.x())))),k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x()))),k.t(k.u(k.z(k.o(k.w(),k.v()),k.o(k.w(),k.v())),k.y(k.q())),k.u(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.z(k.o(k.w(),k.b(k.q())),k.o(k.w(),k.b(k.q())))))][k.p(k.u(k.r(k.u(k.y(k.b(k.n())),k.x())),k.b(k.t(k.b(k.q()),k.b(k.q()),k.b(k.q())))),o["api_mxltvkpyuklh"])],o["api_wuhnhojjxmke"])),-k.u(k.z(k.o(k.w(),k.b(k.q())),k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q())))))),k.y(k.q())));
//				o["medal"] = k.u(k.o(k.u([k.t(k.t(k.o(k.w(),k.v()),k.o(k.w(),k.b(k.q()))),k.t(k.u(k.w(),k.b(k.u(![],![]))),k.y(k.q()))),k.u(k.y(k.q()),k.t(k.z(k.m(k.v(),k.x()),k.z(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w())))))),k.r(k.o(k.k(k.x(),k.v()),k.w())))),k.m(k.t(k.v(),k.v()),k.z(k.u(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.r(k.u(k.y(k.b(k.n())),k.x()))),k.z(k.m(k.o(k.w(),k.v()),k.o(k.w(),k.b(k.q()))),k.u(k.w(),k.b(k.u(![],![]))))),k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))))),k.m(k.t(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))),k.y(k.q())),k.z(k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))),k.z(k.b(k.w()),k.x()))),k.t(k.z(k.b(k.w()),k.x()),k.t(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.o(k.w(),k.m(k.k(k.p(k.r(k.b(k.q()) / k.x()),k.w()),k.v()),k.u(k.w(),k.x())))),k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.w(),k.b(k.u(![],![]))))),k.u(k.t(k.z(k.o(k.w(),k.m(k.k(k.p(k.r(k.b(k.q()) / k.x()),k.w()),k.v()),k.u(k.w(),k.x()))),k.r(k.u(k.y(k.b(k.n())),k.x()))),k.y(k.q()),k.y(k.q())),k.t(k.m(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.o(k.w(),k.v())),k.z(k.b(k.w()),k.x())),k.y(k.q()))),k.t(k.u(k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w())))),k.y(k.q())),k.m(k.o(k.w(),k.v()),k.y(k.q())),k.u(k.z(k.b(k.w()),k.x()),k.u(k.w(),k.b(k.u(![],![])))),k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.w(),k.b(k.u(![],![]))))),k.t(k.x(),k.r(k.u(k.y(k.b(k.n())),k.x())) * k.j(),k.j()),k.t(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.o(k.w(),k.v())),k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.w(),k.b(k.u(![],![])))),k.u(k.x(),k.y(k.q()))),k.t(k.r(k.u(k.y(k.b(k.n())),k.x())) * k.b(k.t(k.b(k.q()),k.b(k.q()),k.b(k.q()))) + k.z(k.b(k.w()),k.x()),k.u(k.w(),k.b(k.u(![],![]))) * k.b(k.t(k.b(k.q()),k.b(k.q()),k.b(k.q()))) + k.y(k.q())),k.t(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.r(k.u(k.y(k.b(k.n())),k.x()))),k.y(k.q()),k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w()))))),k.u(k.r(k.t(k.z(k.r(k.u(k.y(k.b(k.n())),k.x())),k.o(k.w(),k.v())),k.u(k.z(k.o(k.w(),k.v()),k.o(k.w(),k.v())),k.o(k.k(k.v(),k.x()),k.x())))),k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x()))),k.t(k.u(k.z(k.o(k.w(),k.v()),k.o(k.w(),k.v())),k.y(k.q())),k.u(k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x())),k.z(k.o(k.w(),k.b(k.q())),k.o(k.w(),k.b(k.q())))))][k.p(k.u(k.r(k.u(k.q(),k.o(k.x(),k.b(k.t(k.q(),k.q()))))),k.u(k.w(),k.b(k.u(![],![])))),o["api_mxltvkpyuklh"])],k.t(k.z(k.o(k.w(),k.b(k.q())),k.b(k.t(k.r(k.y(k.w())),k.r(k.y(k.w()))))),k.m(k.z(k.o(k.w(),k.b(k.q())),k.b(k.t(k.b(k.q()),k.b(k.q()),k.b(k.q())))),k.y(k.q())))),o["api_itslcqtmrxtf"]),-k.t(k.z(k.u(k.w(),k.b(k.u(![],![]))),k.u(k.z(k.k(k.v(),k.x()) / (k.k(k.v(),k.x()) / k.b(k.k(k.v(),k.x()))),k.w()),k.o(k.x(),k.x()))),k.r(k.u(k.y(k.b(k.n())),k.x()))));
			}
		}
		
		public function get rankNo() : int
		{
			return Util.getInt(_o,"api_mxltvkpyuklh",0);
		}
		
		public function get rank() : int
		{
			return Util.getInt(_o,"api_pcumlrymlujh",0);
		}
		
		public function get nickName() : String
		{
			return Util.getString(_o,"api_mtjmdcwtvhdr","");
		}
		
		public function get experience() : int
		{
			return Util.getInt(_o,"api_experience",0);
		}
		
		public function get comment() : String
		{
			return Util.getString(_o,"api_itbrdpdbkynm","");
		}
		
		public function get rate() : int
		{
			return Util.getInt(_o,"rate",0);
		}
		
		public function get flag() : int
		{
			return Util.getInt(_o,"api_pbgkfylkbjuy",0);
		}
		
		public function get medalNum() : int
		{
			return Util.getInt(_o,"medal",0);
		}
	}
}

