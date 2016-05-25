using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;

public static class AutoBuilder
{
  static string GetProjectName()
  {
    string[] path = Application.dataPath.Split('/');
    return path[path.Length - 2];
  }

  static string[] GetScenePaths()
  {
    return EditorBuildSettings.scenes.ToList().Select(s => s.path).ToArray();
  }

  [MenuItem("AutoBuilder/Windows/32-bit")]
  static void PerformWin32Build()
  {
    PerformBuild("Builds/Win32/" + GetProjectName() + ".exe", BuildTarget.StandaloneWindows);
  }

  [MenuItem("AutoBuilder/Windows/64-bit")]
  static void PerformWin64Build()
  {
    PerformBuild("Builds/Win64/" + GetProjectName() + ".exe", BuildTarget.StandaloneWindows64);
  }

  [MenuItem("AutoBuilder/Windows/Universal")]
  static void PerformUWPBuild()
  {
    PerformBuild("Builds/UWP/", BuildTarget.WSAPlayer);
  }

  [MenuItem("AutoBuilder/Mac OSX")]
  static void PerformOSXBuild()
  {
    PerformBuild("Builds/OSX/" + GetProjectName() + ".app", BuildTarget.StandaloneOSXUniversal);
  }

  [MenuItem("AutoBuilder/Linux")]
  static void PerformLinuxBuild()
  {
    PerformBuild("Builds/Linux/" + GetProjectName(), BuildTarget.StandaloneLinuxUniversal);
  }

  [MenuItem("AutoBuilder/iOS")]
  static void PerformIOSBuild()
  {
    PerformBuild("Builds/iOS", BuildTarget.iOS);
  }

  [MenuItem("AutoBuilder/Android")]
  static void PerformAndroidBuild()
  {
    PerformBuild("Builds/Android/" + GetProjectName() + ".apk", BuildTarget.Android);
  }

  [MenuItem("AutoBuilder/WebGL")]
  static void PerformWebGLBuild()
  {
    PerformBuild("Builds/WebGL", BuildTarget.WebGL);
  }

  [MenuItem("AutoBuilder/Web Player")]
  static void PerformWebBuild()
  {
    PerformBuild("Builds/Web", BuildTarget.WebPlayer);
  }

  private static void PerformBuild(string path, BuildTarget target, BuildOptions options = BuildOptions.None)
  {
    Directory.CreateDirectory(Path.GetDirectoryName(path));
    EditorUserBuildSettings.SwitchActiveBuildTarget(target);
    BuildPipeline.BuildPlayer(GetScenePaths(), path, target, options);
  }
}
