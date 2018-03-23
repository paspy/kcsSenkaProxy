using System;
using System.Collections.Generic;

/// <summary>
/// De-obfuscated version of _APIBaseS_ and other helper functions
/// </summary>
namespace Paspy {
    public static class KeyGen {

        // A set of key frequently update by Kancolle officials - Incorrect key would get error code 100
        static readonly int[] Il = { 9542, 2404, 5208, 2139, 6773, 4132653, 1033183, 3436, 8280, 2357, 13, 5795, 3791, 10, 7599, 8707, 1000, 1875979 };

        /// <summary>
        /// Construct a signature string that will verified by Kancolle server (api_ranking, api_port, ...)
        /// </summary>
        /// <param name="param1">Teitoku's member ID</param>
        /// <returns></returns>
        public static string CreateSignature(int param1) {
            var _loc3_ = KeyFuncs.u(32768, KeyFuncs.i((int)KeyFuncs.m(32768, 1)));
            var _loc4_ = KeyFuncs.c(KeyFuncs.u(KeyFuncs.u(KeyFuncs.p(Il[16], param1), Il[16]), KeyFuncs.z(Il[16], KeyFuncs.i(9)))) + KeyFuncs.z(KeyFuncs.m(KeyFuncs.u(KeyFuncs.m(KeyFuncs.z(KeyFuncs.u(Il[5], _loc3_), KeyFuncs.u(KeyFuncs.l(KeyFuncs.c(param1), 0, 4), Il[16])), KeyFuncs.n()), KeyFuncs.u(Il[17], KeyFuncs.z(_loc3_, 9))), param1), Il[I1((int)KeyFuncs.p(10, param1))]) + KeyFuncs.u(Il[16], KeyFuncs.i((int)KeyFuncs.z(Il[16], 9)));
            return KeyFuncs.i(10) + KeyFuncs.a(_loc4_, 0, 7) + KeyFuncs.i(10) + KeyFuncs.a(_loc4_, 7, 9) + KeyFuncs.i(10) + KeyFuncs.a(_loc4_, 16, Il[16]) + KeyFuncs.c(_loc3_);
        }
        /// <summary>
        /// Original I1 for easy maintaining in the future.
        /// </summary>
        /// <param name="param1"></param>
        /// <returns></returns>
        static int I1(int param1) {
            var _loc3_ = 0;
            while (param1 != KeyFuncs.l(KeyFuncs.s(KeyFuncs.y(Il[Il[13]])), _loc3_, 1)) {
                _loc3_++;
            }
            return _loc3_;
        }

        static readonly int[] Magic_R = { 8931, 1201, 1156, 5061, 4569, 4732, 3779, 4568, 5695, 4619, 4912, 5669, 6586 };
        static readonly int[] Magic_M = { 10784, 3054, 3009, 6914, 6422, 6585, 5632, 6421, 7548, 6472, 6765, 7522, 8439 };

        /// <summary>
        /// A custom decoder for De-obfuscated ranking rate and medal number
        /// 
        /// Source: 
        /// http://ch.nicovideo.jp/arisu_yaya/blomaga/ar941858
        /// 
        /// https://github.com/yukixz/kctools/blob/master/rank.py
        /// 
        /// </summary>
        /// <param name="memberId">Teitoku's member ID</param>
        /// <param name="rankNo">Actual ranking number from 1 to 990</param>
        /// <param name="obfuscatedRate">Obfuscated ranking rate from Kancolle server</param>
        /// <param name="obfuscatedMedal">Pbfuscated ranking medal number from Kancolle server</param>
        /// <returns></returns>
        public static Dictionary<string, double> DecodeRankAndMedal(int memberId, int rankNo, long obfuscatedRate, long obfuscatedMedal) {
            Dictionary<string, double> rateAndMedal = new Dictionary<string, double>();
            List<double> magic_l = new List<double>();
            for (int i = 0; i < 10; i++) {
                magic_l.Add(Simplified_l_(i, true));
            }
            var r = Magic_R[rankNo % 13];
            var m = Magic_M[rankNo % 13];
            var l = magic_l[memberId % 10];
            rateAndMedal["rate"] = obfuscatedRate / (r * l) - 73.0 - 18.0;
            rateAndMedal["medal"] = obfuscatedMedal / m - 157.0;
            return rateAndMedal;
        }

        /// <summary>
        /// Simplified version of I1
        /// </summary>
        /// <param name="param1"></param>
        /// <returns></returns>
        static int Simplified_I1(int param1) {
            if (param1 == 0) {
                return 1;
            }
            //string s_sqrt13 = Math.Sqrt(13).ToString(); // has precisous problem
            string s_sqrt13 = "3.605551275463989";
            return s_sqrt13.IndexOf(param1.ToString());
        }

        /// <summary>
        /// Simplified version of _l_
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="firstTwo"></param>
        /// <returns></returns>
        public static double Simplified_l_(int memberId, bool firstTwo = false) {
            int magicNum = 0;
            try {
                var i = Simplified_I1(memberId % 10);
                magicNum = Il[i];
            } catch (Exception ex) {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                throw;
            }
            return firstTwo ? long.Parse(magicNum.ToString().Substring(0/* NaN */, 2)) : magicNum;
        }

        /// <summary>
        /// _createKey() functions in C-Sharp
        /// </summary>
        static class KeyFuncs {
            static Random rnd = new Random();
            public static string a(string param1, int param2, int param3) {
                return param1.Substring(param2, param3 >= (param1.Length - param2) ? param1.Length - param2 : param3);
            }
            public static int b(string param1) {
                return param1.Length;
            }
            public static string c(double param1) {
                return param1.ToString();
            }
            public static int r(double param1) {
                return (int)Math.Floor(param1);
            }
            public static int i(int param1) {
                return r(rnd.NextDouble() * param1);
            }
            public static int j() {
                return 8;
            }
            public static int k(int param1, int param2) {
                return param1 ^ param2;
            }
            public static int l(string param1, int param2, int param3) {
                try {
                    long result = -1;
                    if (long.TryParse(param1.Substring(param2, param3), out result)) {
                        return (int)result;
                    }
                    return 0;
                } catch (Exception e) {
                    System.Diagnostics.Debug.WriteLine(e.Message);
                    throw;
                }

            }
            public static double m(double param1, double param2) {
                return param1 - param2;
            }
            public static double n() {
                return r((long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalMilliseconds / 1000);
            }
            public static double o(double param1, double param2) {
                return param2 / param1;
            }
            public static double p(double param1, double param2) {
                return param2 % param1;
            }
            public static double q() {
                return 1.44269504088896;
            }
            public static string s(object param1) {
                return param1.ToString();
            }
            //void t(... rest):String
            //{
            //	return rest.join("");
            //};
            public static double u(double param1, double param2) {
                return param1 + param2;
            }
            public static int v() {
                return 16;
            }
            public static int w() {
                return 2;
            }
            public static int x() {
                return 4;
            }
            public static decimal y(int param1) {
                if (param1 == 13) return 3.605551275463989M; // actually always sqrt(13)
                return (decimal)Math.Sqrt(param1);
            }
            public static double z(double param1, double param2) {
                return param1 * param2;
            }
        }
    }
}
