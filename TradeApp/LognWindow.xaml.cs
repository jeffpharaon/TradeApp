using System.Windows;
using System.Windows.Media.Imaging;

namespace TradeApp
{
    public partial class LoginWindow : Window
    {
        private int loginAttempts = 0;
        private string currentCaptcha;

        public LoginWindow()
        {
            InitializeComponent();
        }

        private void LoginButton_Click(object sender, RoutedEventArgs e)
        {
            string login = LoginTextBox.Text;
            string password = PasswordBox.Password;

            if (CaptchaPanel.Visibility == Visibility.Visible)
            {
                if (CaptchaTextBox.Text != currentCaptcha)
                {
                    MessageBox.Show("Неверная капча.");
                    GenerateCaptcha();
                    return;
                }
            }

            User user;
            using (var context = new TradeContext())
                user = context.Users.FirstOrDefault(u => u.UserLogin == login && u.UserPassword == password);

            if (user != null)
            {
                MainWindow main = new MainWindow(user);
                main.Show();
                this.Close();
            }
            else
            {
                loginAttempts++;
                MessageBox.Show("Неверный логин или пароль.");
                if (loginAttempts >= 1)
                {
                    CaptchaPanel.Visibility = Visibility.Visible;
                    GenerateCaptcha();
                }
            }
        }

        private void GenerateCaptcha()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();
            currentCaptcha = new string(Enumerable.Repeat(chars, 4)
                .Select(s => s[random.Next(s.Length)]).ToArray());

            CaptchaImage.Source = new BitmapImage(new Uri("file:///D:/VsCodeProjects/.Curs/Edelweiss/задание/задание/resources/Images/captcha_placeholder.png"));
        }

        private void GuestButton_Click(object sender, RoutedEventArgs e)
        {
            User guest = new User
            {
                UserID = 0,
                UserSurname = "Гость",
                UserName = "",
                UserPatronymic = "",
                UserLogin = "guest",
                UserRole = 0
            };
            MainWindow main = new MainWindow(guest);
            main.Show();
            this.Close();
        }
    }
}
