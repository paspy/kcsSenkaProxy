using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Threading.Tasks;
using System.Text;
using System.Linq;
using TimeZoneConverter;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Paspy;


namespace kcsSenkaProxy {
    class Collector {
        private static Random s_RND = new Random();

        private string m_token;
        private int m_serverId;
        private string m_serverAddr;
        private string m_serverName;
        //private string m_exportFileName;
        private string m_logFileName;
        private int m_memberId;
        private HttpClient m_client = new HttpClient(new HttpClientHandler() {
            AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate,
            AllowAutoRedirect = true,
            UseCookies = true,
        });
        private ConcurrentBag<UserData> m_concurrentResults = new ConcurrentBag<UserData>();

        private static readonly string[] RANK_NAME = { "", "元帥", "大将", "中将", "少将", "大佐", "中佐", "新米中佐", "少佐", "中堅少佐", "新米少佐" };

        public Collector(int serverId, string token, int memberId = 0) {
            m_serverId = serverId - 1;
            m_token = token;
            m_memberId = memberId;
            m_serverAddr = Utils.WorldServerAddr[m_serverId];
            m_serverName = Utils.WorldServerName[m_serverId];
            m_logFileName = Path.Combine("log", string.Format("{0}.log", m_serverName));
            Directory.CreateDirectory(Path.Combine(Directory.GetCurrentDirectory(), "log"));
            GetMemberId();
        }

        private void GetMemberId() {
            List<Task> tasks = new List<Task>();
            if (m_memberId <= 0) {
                var postContent = new Dictionary<string, string>
                {
                    {"api_verno","1"},
                    {"api_token", m_token},
                };
                var httpReqMsg = Utils.CreateHttpRequestMessage(
                        string.Format("http://{0}/kcsapi/api_get_member/record", m_serverAddr), new FormUrlEncodedContent(postContent));
                var respones = m_client.SendAsync(httpReqMsg).Result;
                var rawResult = respones.Content.ReadAsStringAsync().Result;
                var rawJson = rawResult.Substring(7); // delete "svdata="
                dynamic json = JToken.Parse(rawJson);
                if ((int)json.api_result != 1) {
                    string msg = json.api_result_msg;
                    Utils.Log(string.Format("Error on acquiring memberId, code: {0}.", json.api_result), m_logFileName, "SenkaModule");
                    throw new NotSupportedException(); // TO-DO acquire a new token
                }
                m_memberId = (int)(json.api_data.api_member_id);
                Utils.Log("Get Member ID " + m_memberId + " for Collector from server " + m_serverName + " completed.", m_logFileName, "SenkaModule");
            }
        }

        public void GetSenkaDataNow() {
            m_concurrentResults.Clear();
            var outputPath = Path.Combine(Directory.GetCurrentDirectory(), "Senka", Utils.GetCurrentFixedUpdateTime().ToString("yyMMddHH"));
            var outputFile = Path.Combine(outputPath, string.Format("{0}.{1}", m_serverName, "json"));
            if (File.Exists(outputFile)) return;
            Directory.CreateDirectory(outputPath);
            try {
                List<Task> tasks = new List<Task>();
                for (int pageNo = 1; pageNo < 100; pageNo++) {
                    var newTask = GetRankPageInfoAsync(pageNo);
                    tasks.Add(newTask.ContinueWith((p) => {
                        foreach (var user in p.Result) {
                            m_concurrentResults.Add(user);
                        }
                    }, TaskContinuationOptions.OnlyOnRanToCompletion));
                    if (tasks.Count >= 50) {
                        Task.WaitAll(tasks.ToArray());
                        tasks.Clear();
                    }
                }
                Task.WaitAll(tasks.ToArray());
                tasks.Clear();
                var sortedResult = m_concurrentResults.OrderBy(x => x.RankNo).ToList();
                var jsonResult = JsonConvert.SerializeObject(sortedResult, Formatting.Indented);
                File.WriteAllText(outputFile, jsonResult);
                Utils.Log("All Senka data downloaded. ", m_logFileName, m_serverName);
            } catch (Exception e) {
                Utils.Log("Critical Error at GetSenkaDataNow: " + e.Message, m_logFileName, "SenkaCollector");
                throw;
            }
        }

        private async Task<List<UserData>> GetRankPageInfoAsync(int pageNo) {
            try {
                var postContent = new Dictionary<string, string>
                {
                    {"api_verno","1"},
                    {"api_ranking", KeyGen.CreateSignature(m_memberId)},
                    {"api_pageno", pageNo.ToString()},
                    {"api_token", m_token},
                };
                var httpReqMsg = Utils.CreateHttpRequestMessage(
                                string.Format("http://{0}/kcsapi/api_req_ranking/mxltvkpyuklh", m_serverAddr), new FormUrlEncodedContent(postContent));
                var respones = await m_client.SendAsync(httpReqMsg);
                var rawResult = await respones.Content.ReadAsStringAsync();
                var rawJson = rawResult.Substring(7); // delete "svdata="
                dynamic json = JToken.Parse(rawJson);
                if ((int)json.api_result != 1) {
                    string msg = json.api_result_msg;
                    Utils.Log(string.Format("Error on acquiring memberId, code: {0}.", json.api_result), m_logFileName, "SenkaCollector");
                    throw new NotSupportedException(); // TO-DO
                }

                List<UserData> currentPageOfTeitoku = new List<UserData>();
                foreach (var teitokuJson in json.api_data.api_list) {
                    currentPageOfTeitoku.Add(ParseRankingData(teitokuJson));
                }
                return currentPageOfTeitoku;
            } catch (Exception e) {
                Utils.Log("Critical Error at GetRankPageInfoAsync: " + e.Message, m_logFileName, "SenkaCollector");
                throw;
            }
        }

        private UserData ParseRankingData(dynamic eachUser) {
            try {
                var decodedData = KeyGen.DecodeRankAndMedal(m_memberId, (int)eachUser.api_mxltvkpyuklh, (long)eachUser.api_wuhnhojjxmke, (long)eachUser.api_itslcqtmrxtf);
                UserData user = new UserData();
                user.Nickname = eachUser.api_mtjmdcwtvhdr;
                user.Nickname = Utils.Base64Encode(user.Nickname);
                user.Comment = eachUser.api_itbrdpdbkynm;
                user.Comment = Utils.Base64Encode(user.Comment);
                user.MedalNum = (int)decodedData["medal"];
                user.Senka = (int)decodedData["rate"];
                user.RankNo = (int)eachUser.api_mxltvkpyuklh;
                user.Rank = RANK_NAME[(int)eachUser.api_pcumlrymlujh];
                user.Server = m_serverName;
                var tokyo = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, Utils.TokyoTimeInfo);
                user.FixedJST = int.Parse(Utils.GetCurrentFixedUpdateTime().ToString("yyMMddHH"));
                user.Update = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
                return user;
            } catch (Exception e) {
                Utils.Log("Critical Error at ParseRankingData: " + e.Message, m_logFileName, "SenkaCollector");
                throw;
            }

        }

    }

    public static class Utils {
        private static object locker = new object();
        public static readonly TimeZoneInfo TokyoTimeInfo = TZConvert.GetTimeZoneInfo("Tokyo Standard Time");

        public static string Base64Encode(string plainText) {
            var plainTextBytes = Encoding.UTF8.GetBytes(plainText);
            return Convert.ToBase64String(plainTextBytes);
        }
        public static string Base64Decode(string base64EncodedData) {
            var base64EncodedBytes = Convert.FromBase64String(base64EncodedData);
            return Encoding.UTF8.GetString(base64EncodedBytes);
        }

        public static DateTime GetCurrentFixedUpdateTime() {
            var jst = GetJSTNow();
            int hour = 0;
            if (jst.Hour < 3 && jst.Hour >= 0) {
                hour = 15;
                jst = jst.AddDays(-1);
            }
            if (jst.Hour >= 3 && jst.Hour < 15) {
                hour = 3;
            }
            if (jst.Hour >= 15 && jst.Hour < 24) {
                hour = 15;
            }
            return new DateTime(jst.Year, jst.Month, jst.Day, hour, 0, 0, DateTimeKind.Local);
        }

        /// <summary>
        /// Has bug
        /// </summary>
        /// <param name="forwardSecond"></param>
        /// <returns></returns>
        public static int GetNextCycleTimeLeft(int forwardSecond = 10) {
            var currJST = GetJSTNow().TimeOfDay;
            int hour = 0;
            int day = 0;
            if (currJST.Hours < 3) hour = 3;
            else if (currJST.Hours >= 3 && currJST.Hours < 15) hour = 15;
            else { hour = 3; day++; }
            TimeSpan nextTime = new TimeSpan(currJST.Days + day, hour, 0, currJST.Seconds, 0);
            return (int)Math.Floor((nextTime - currJST).TotalMilliseconds) + forwardSecond * 1000;
        }

        public static string FormatedTimeLeft() {
            TimeSpan t = TimeSpan.FromMilliseconds(GetNextCycleTimeLeft());
            return string.Format(
                "{0:D2}:{1:D2}:{2:D2}:{3:D3}ms", t.Hours, t.Minutes, t.Seconds, t.Milliseconds);
        }

        public static DateTime GetJSTNow() {
            return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TZConvert.GetTimeZoneInfo("Tokyo Standard Time"));
        }

        public static HttpRequestMessage CreateHttpRequestMessage(string destUrl, HttpContent content) {
            var msg = new HttpRequestMessage();
            msg.Method = HttpMethod.Post;
            msg.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("*/*"));
            msg.Headers.AcceptEncoding.Add(new StringWithQualityHeaderValue("gzip"));
            msg.Headers.AcceptEncoding.Add(new StringWithQualityHeaderValue("deflate"));
            msg.Headers.UserAgent.ParseAdd("Mozilla/5.0 (Android; U; zh-CN) AppleWebKit/533.19.4 (KHTML, like Gecko) AdobeAIR/21.0 rqxbjmdizgzp");
            msg.Headers.ExpectContinue = false;
            msg.Headers.Referrer = new Uri("app:/AppMain.swf/[[DYNAMIC]]/1");
            msg.Headers.Add("x-flash-version", "21,0,0,174");
            msg.RequestUri = new Uri(destUrl);
            msg.Content = content;
            return msg;
        }

        public static void Log(string log, string outputPath, string belongs, ConsoleColor fgc = ConsoleColor.Gray, ConsoleColor bgc = ConsoleColor.Black) {
            lock (locker) {
                using (StreamWriter sw = new StreamWriter(new FileStream(outputPath, FileMode.Append, FileAccess.Write, FileShare.ReadWrite), Encoding.UTF8)) {
                    string s = string.Format("[{0}] {1} - {2}", DateTime.UtcNow.ToString(), log, belongs);
                    string head = string.Format("[{0}] ", DateTime.UtcNow.ToString());
                    //Console.BackgroundColor = ConsoleColor.Black;
                    //Console.ForegroundColor = ConsoleColor.Gray;
                    Console.Write(head);
                    //Console.BackgroundColor = bgc;
                    //Console.ForegroundColor = fgc;
                    Console.WriteLine(log + " - " + belongs);
                    //Console.BackgroundColor = ConsoleColor.Black;
                    //Console.ForegroundColor = ConsoleColor.Gray;
                    sw.WriteLine(s);
                }
            }
        }

        public static readonly List<string> WorldServerAddr = new List<string>() {
               "203.104.209.71"  , // 01.横須賀鎮守府   
               "203.104.209.87"  , // 02.呉鎮守府        
               "125.6.184.16"    , // 03.佐世保鎮守府    
               "125.6.187.205"   , // 04.舞鶴鎮守府      
               "125.6.187.229"   , // 05.大湊警備府      
               "203.104.209.134" , // 06.トラック泊地    
               "203.104.209.167" , // 07.リンガ泊地      
               "203.104.248.135" , // 08.ラバウル基地    
               "125.6.189.7"     , // 09.ショートランド泊地
               "125.6.189.39"    , // 10.ブイン基地
               "125.6.189.71"    , // 11.タウイタウイ泊地 
               "125.6.189.103"   , // 12.パラオ泊地
               "125.6.189.135"   , // 13.ブルネイ泊地    
               "125.6.189.167"   , // 14.単冠湾泊地      
               "125.6.189.215"   , // 15.幌筵泊地        
               "125.6.189.247"   , // 16.宿毛湾泊地      
               "203.104.209.23"  , // 17.鹿屋基地        
               "203.104.209.39"  , // 18.岩川基地        
               "203.104.209.55"  , // 19.佐伯湾泊地      
               "203.104.209.102" , // 20.柱島泊地        
        };

        public static readonly List<string> WorldServerName = new List<string>() {
              /*203.104.209.71 */ "01.横須賀鎮守府",
              /*203.104.209.87 */ "02.呉鎮守府",
              /*125.6.184.16   */ "03.佐世保鎮守府",
              /*125.6.187.205  */ "04.舞鶴鎮守府",
              /*125.6.187.229  */ "05.大湊警備府",
              /*203.104.209.134*/ "06.トラック泊地",
              /*203.104.209.167*/ "07.リンガ泊地",
              /*203.104.248.135*/ "08.ラバウル基地",
              /*125.6.189.7    */ "09.ショートランド泊地",
              /*125.6.189.39   */ "10.ブイン基地",
              /*125.6.189.71   */ "11.タウイタウイ泊地",
              /*125.6.189.103  */ "12.パラオ泊地",
              /*125.6.189.135  */ "13.ブルネイ泊地",
              /*125.6.189.167  */ "14.単冠湾泊地",
              /*125.6.189.215  */ "15.幌筵泊地",
              /*125.6.189.247  */ "16.宿毛湾泊地",
              /*203.104.209.23 */ "17.鹿屋基地",
              /*203.104.209.39 */ "18.岩川基地",
              /*203.104.209.55 */ "19.佐伯湾泊地",
              /*203.104.209.102*/ "20.柱島泊地",
        };
    }


}
