using System.Windows;

namespace SleepDeprivation
{
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            
            // Hide the main window on startup - we only want the tray icon
            MainWindow = new MainWindow();
            MainWindow.WindowState = WindowState.Minimized;
            MainWindow.ShowInTaskbar = false;
        }
    }
}