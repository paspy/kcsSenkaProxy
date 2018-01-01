using System;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
namespace kcsSenkaProxy {
    class Program {
        static void Main(string[] args) {

            if (args.Length < 1) {
                Console.WriteLine("Need Account Info file.");
                return;
            }
            try {
                var accountInfo = JsonConvert.DeserializeObject<List<KancolleAccount>>(File.ReadAllText(args[0]));
                foreach (var info in accountInfo) {
                    if (string.IsNullOrEmpty(info.Token))
                        continue;
                    Collector c = new Collector(info.ServerId, info.Token);
                    c.GetSenkaDataNow();
                }

            } catch (Exception) {
                Console.WriteLine("Corrupt Account Info file.");
            }
        }

        public sealed class KancolleAccount {
            public int ServerId { get; set; }
            public string ServerName { get; set; }
            public string LoginId { get; set; }
            public string ServerAddress { get; set; }
            public string LoginPassword { get; set; }
            public string Token { get; set; }
        }

    }
}
