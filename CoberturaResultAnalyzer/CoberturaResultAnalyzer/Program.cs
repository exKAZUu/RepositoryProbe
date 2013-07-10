using System;
using System.Linq;
using JustAgile.Html.Linq;

namespace CoberturaResultAnalyzer {
    internal class Program {
        private static void Main(string[] args) {
            if (args.Length == 0) {
                Console.WriteLine("Please specify the path of the pom file.");
            }

            var doc = HDocument.Load(args[0]);
            var result = Analyze(doc);
            Console.WriteLine(result);
        }

        private static double Analyze(HDocument doc) {
            var elem = doc.Element("html")
                    .Element("body")
                    .Element("table")
                    .Element("tbody")
                    .Element("tr")
                    .Elements("td").ElementAt(2)
                    .Element("table")
                    .Element("tr")
                    .Element("td");
            return int.Parse(elem.Value.Replace("%", "").Trim());
        }
    }
}