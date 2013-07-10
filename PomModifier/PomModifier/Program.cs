using System;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace PomModifier {
    internal class Program {
        private static readonly XNamespace Namespace = "http://maven.apache.org/POM/4.0.0";

        private static void Main(string[] args) {
            args = new string[] { "../../../pom.xml" };
            if (args.Length == 0) {
                Console.WriteLine("Please specify the path of the pom file.");
            }

            var xdoc = XDocument.Load(args[0]);
            Modify(xdoc.Root);
            File.WriteAllText(args[0], xdoc.ToString());
        }

        private static void Modify(XElement project) {
            if (project.Name.LocalName != "project") {
                throw new Exception("The project Element should appear as the root element.");
            }

            ModifyBuildForCobertura(project);
            ModifyReportingForCobertura(project);
        }

        private static void ModifyBuildForCobertura(XElement parent) {
            var build = TryAdd(parent, "build");
            var plugins = TryAdd(build, "plugins");
            var plugin = plugins.Elements().Where(e => {
                var artifactId = e.Element(Namespace + "artifactId");
                return artifactId != null && artifactId.Value == "cobertura-maven-plugin";
            }).FirstOrDefault();
            if (plugin == null) {
                //var phase = new XElement(Namespace + "phase", "pre-site");
                var goals = new XElement(Namespace + "goals",
                        new XElement(Namespace + "goal", "clean"), new XElement(Namespace + "goal", "check"));

                var execution = new XElement(Namespace + "execution", goals);

                var groupId = new XElement(Namespace + "groupId", "org.codehaus.mojo");
                var artifactId = new XElement(Namespace + "artifactId", "cobertura-maven-plugin");
                var executions = new XElement(Namespace + "executions", execution);
                plugins.Add(new XElement(Namespace + "plugin", groupId, artifactId, executions));
            }
        }

        private static void ModifyReportingForCobertura(XElement parent) {
            var reporting = TryAdd(parent, "reporting");
            var plugins = TryAdd(reporting, "plugins");
            var plugin = plugins.Elements().Where(e => {
                var artifactId = e.Element(Namespace + "artifactId");
                return artifactId != null && artifactId.Value == "cobertura-maven-plugin";
            }).FirstOrDefault();
            if (plugin == null) {
                var groupId = new XElement(Namespace + "groupId", "org.codehaus.mojo");
                var artifactId = new XElement(Namespace + "artifactId", "cobertura-maven-plugin");
                plugins.Add(new XElement(Namespace + "plugin", groupId, artifactId));
            }
        }

        private static XElement TryAdd(XElement parent, string childName) {
            var child = parent.Element(Namespace + childName);
            if (child == null) {
                child = new XElement(Namespace + childName);
                parent.Add(child);
            }
            return child;
        }
    }
}