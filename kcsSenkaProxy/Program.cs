using System;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Collections.Generic;
using System.Threading;
using Newtonsoft.Json;
namespace kcsSenkaProxy {
    class Program {

        static Timer m_timer;
        static string m_filename;
        static void Main(string[] args) {

            if (args.Length < 1) {
                Console.WriteLine("Need Account Info file.");
                return;
            }

            m_timer = new Timer(StartWork, null, Utils.GetNextCycleTimeLeft(), Timeout.Infinite);
            m_filename = args[0];
            Console.WriteLine("Senka record will start in " + Utils.FormatedTimeLeft());
            do {
                if (Console.ReadKey(true).Key == ConsoleKey.R)
                    StartWork();
                if (Console.ReadKey(true).Key == ConsoleKey.T)
                    Console.WriteLine("Senka record will start in " + Utils.FormatedTimeLeft());
                Thread.Sleep(100);
            } while (Console.ReadKey(true).Key != ConsoleKey.Q);
        }

        static void StartWork(object state = null) {
            try {
                var accountInfo = JsonConvert.DeserializeObject<List<KancolleAccount>>(File.ReadAllText(m_filename));
                foreach (var info in accountInfo) {
                    if (string.IsNullOrEmpty(info.Token))
                        continue;
                    Collector c = new Collector(info.ServerId, info.Token);
                    c.GetSenkaDataNow();
                }
                var source = Path.Combine(Directory.GetCurrentDirectory(), "Senka", Utils.GetCurrentFixedUpdateTime().ToString("yyMMddHH"));
                var destFile = source + ".zip";

                if (!File.Exists(destFile)) {
                    ZipFile.CreateFromDirectory(source, destFile, CompressionLevel.Optimal, false, Encoding.UTF8);
                }
                Console.WriteLine("Rua.");
                Console.WriteLine("Senka record will start in " + Utils.FormatedTimeLeft());

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
