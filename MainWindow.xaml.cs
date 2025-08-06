using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using Hardcodet.Wpf.TaskbarNotification;

namespace SleepDeprivation
{
    public partial class MainWindow : Window
    {
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        static extern uint SetThreadExecutionState(uint esFlags);

        const uint ES_CONTINUOUS = 0x80000000;
        const uint ES_SYSTEM_REQUIRED = 0x00000001;
        const uint ES_DISPLAY_REQUIRED = 0x00000002;

        private bool _isActive = false;
        private bool _isClosing = false;

        private System.Drawing.Icon CreateTrayIcon(System.Drawing.Color color)
        {
            var bitmap = new Bitmap(16, 16);
            using (var graphics = Graphics.FromImage(bitmap))
            {
                graphics.Clear(System.Drawing.Color.Transparent);
                graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                
                using (var brush = new SolidBrush(color))
                {
                    graphics.FillEllipse(brush, 2, 2, 12, 12);
                }
                
                using (var pen = new System.Drawing.Pen(System.Drawing.Color.White, 1))
                {
                    graphics.DrawEllipse(pen, 2, 2, 12, 12);
                }
            }

            var handle = bitmap.GetHicon();
            var icon = System.Drawing.Icon.FromHandle(handle);
            return icon;
        }

        private System.Drawing.Icon CreateActiveIcon()
        {
            return CreateTrayIcon(System.Drawing.Color.Green);
        }

        private System.Drawing.Icon CreateInactiveIcon()
        {
            return CreateTrayIcon(System.Drawing.Color.Red);
        }

        public new bool IsActive
        {
            get { return _isActive; }
            set
            {
                _isActive = value;
                UpdateUI();
                UpdateSleepState();
            }
        }

        public MainWindow()
        {
            InitializeComponent();
            this.WindowState = WindowState.Minimized;
            this.ShowInTaskbar = false;
            
            // Handle window closing to minimize to tray instead
            this.Closing += MainWindow_Closing;
            
            UpdateUI();
        }

        private void UpdateUI()
        {
            if (IsActive)
            {
                StatusText.Text = "Sleep Deprivation - Active";
                StatusIndicator.Fill = System.Windows.Media.Brushes.Green;
                ToggleButton.Content = "Deactivate";
                TrayIcon.ToolTipText = "Sleep Deprivation - Active";
                TrayIcon.Icon = CreateActiveIcon();
                
                // Update context menu
                var contextMenu = (ContextMenu)FindResource("TrayContextMenu");
                var menuItemEnable = (MenuItem)contextMenu.Items[0];
                menuItemEnable.IsChecked = true;
            }
            else
            {
                StatusText.Text = "Sleep Deprivation - Inactive";
                StatusIndicator.Fill = System.Windows.Media.Brushes.Red;
                ToggleButton.Content = "Activate";
                TrayIcon.ToolTipText = "Sleep Deprivation - Inactive";
                TrayIcon.Icon = CreateInactiveIcon();
                
                // Update context menu
                var contextMenu = (ContextMenu)FindResource("TrayContextMenu");
                var menuItemEnable = (MenuItem)contextMenu.Items[0];
                menuItemEnable.IsChecked = false;
            }
        }

        private void UpdateSleepState()
        {
            if (IsActive)
            {
                // Prevent system sleep and display sleep
                SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
            }
            else
            {
                // Allow system to sleep normally
                SetThreadExecutionState(ES_CONTINUOUS);
            }
        }

        private void ToggleButton_Click(object sender, RoutedEventArgs e)
        {
            IsActive = !IsActive;
        }

        private void MenuItemEnable_Click(object sender, RoutedEventArgs e)
        {
            IsActive = true;
        }

        private void MenuItemDisable_Click(object sender, RoutedEventArgs e)
        {
            IsActive = false;
        }

        private void MenuItemShow_Click(object sender, RoutedEventArgs e)
        {
            Show();
            WindowState = WindowState.Normal;
            ShowInTaskbar = true;
            Activate();
        }

        private void MenuItemExit_Click(object sender, RoutedEventArgs e)
        {
            _isClosing = true;
            
            // Restore normal sleep behavior before closing
            SetThreadExecutionState(ES_CONTINUOUS);
            
            Application.Current.Shutdown();
        }

        private void TrayIcon_TrayLeftMouseDown(object sender, RoutedEventArgs e)
        {
            // Toggle active state on left click
            IsActive = !IsActive;
        }

        private void MinimizeToTray_Click(object sender, RoutedEventArgs e)
        {
            Hide();
            ShowInTaskbar = false;
        }

        private void MainWindow_Closing(object? sender, System.ComponentModel.CancelEventArgs e)
        {
            if (!_isClosing)
            {
                e.Cancel = true;
                Hide();
                ShowInTaskbar = false;
            }
        }

        protected override void OnClosed(EventArgs e)
        {
            // Clean up tray icon
            TrayIcon?.Dispose();
            base.OnClosed(e);
        }
    }
}