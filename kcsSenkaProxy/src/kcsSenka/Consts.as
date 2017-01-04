package kcsSenka {

    public final class Consts {

        public static const LocalIP:String="127.0.0.1";
        public static const DefaultPort:int=12315;
        public static const TargetPort:int=12316;

        public static const RequestRankingAPI:String="kcsRequestAPIRanking";
        public static const EncodedRankingAPI:String="kcsEncodedAPIRanking";

        public static const PayItemAPI:String="api_get_member/payitem";
        public static const RecordAPI:String="api_get_member/record";
        public static const SenkaAPI:String="api_req_ranking/mxltvkpyuklh";
        public static const Magic_api_verno:int=1;
        public static const RankName:Array=["", "元帥", "大将", "中将", "少将", "大佐", "中佐", "新米中佐", "少佐", "中堅少佐", "新米少佐"];

        public static const Server_Info:String="203.104.209.7"; //ランキング画像など

        public static const Server_01:String="203.104.209.71"; //横須賀鎮守府
        public static const Server_02:String="203.104.209.87"; //新呉鎮守府
        public static const Server_03:String="125.6.184.16"; //佐世保鎮守府　　
        public static const Server_04:String="125.6.187.205"; //舞鶴鎮守府　
        public static const Server_05:String="125.6.187.229"; //大湊警備府　　　　　　
        public static const Server_06:String="125.6.187.253"; //トラック泊地
        public static const Server_07:String="125.6.188.25"; //リンガ泊地
        public static const Server_08:String="203.104.248.135"; //ラバウル基地
        public static const Server_09:String="125.6.189.7"; //ショートランド泊地
        public static const Server_09_api_token:String="9e8965c249610a2f0e7536d6dfbb3ae603f8eabd";

        public static const Server_10:String="125.6.189.39"; //ブイン基地
        public static const Server_11:String="125.6.189.71"; //タウイタウイ泊地
        public static const Server_12:String="125.6.189.103"; //パラオ泊地　
        public static const Server_13:String="125.6.189.135"; //ブルネイ泊地
        public static const Server_14:String="125.6.189.167"; //単冠湾泊地
        public static const Server_15:String="125.6.189.215"; //幌筵泊地　
        public static const Server_16:String="125.6.189.247"; //宿毛湾泊地
        public static const Server_17:String="203.104.209.23"; //鹿屋基地　
        public static const Server_18:String="203.104.209.39"; //岩川基地
        public static const Server_19:String="203.104.209.55"; //佐伯湾泊地
        public static const Server_20:String="203.104.209.102"; //柱島泊地


        public static const POST_UserAgent:String="Mozilla/5.0 (Android; U; zh-CN) AppleWebKit/533.19.4 (KHTML, like Gecko) AdobeAIR/21.0 rqxbjmdizgzp";
        public static const POST_Referer:String="app:/AppMain.swf/[[DYNAMIC]]/1";
        public static const POST_FlashVersion:String="21,0,0,174";

        public static const COLOR_Red:uint=0xFF0000;
        public static const COLOR_Green:uint=0x00FF00;
        public static const COLOR_Blue:uint=0x0000FF;
        public static const COLOR_White:uint=0xFFFFFF;
        public static const COLOR_Black:uint=0x000000;

        // custom decoder
        public static const Magic_R:Array=[8931, 1201, 1156, 5061, 4569, 4732, 3779, 4568, 5695, 4619, 4912, 5669, 6586];
        public static const Magic_L:Array=[47, 23, 47, 53, 32, 29, 69, 18, 89, 30];
        public static const Magic_M:Array=[10784, 3054, 3009, 6914, 6422, 6585, 5632, 6421, 7548, 6472, 6765, 7522, 8439];

        public static function DecodeRateAndMedal(memberId:Number, rankNo:Number, maskedRate:Number, maskedMedal:Number):Object {
            var r:Number=Magic_R[rankNo % 13];
            var m:Number=Magic_M[rankNo % 13];
            var l:Number=Magic_L[memberId % 10];
            var rateAndMedal:Object=new Object();
            rateAndMedal.rate=maskedRate / (r * l) - 73.0 - 18.0;
            rateAndMedal.medal=maskedMedal / m - 157.0;
            return rateAndMedal;
        }

        public function Consts() {
            super();
        }
    }
}
