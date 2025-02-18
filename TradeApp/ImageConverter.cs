using System;
using System.Globalization;
using System.IO;
using System.Windows.Data;
using System.Windows.Media.Imaging;

namespace TradeApp
{
    public class ImageConverter : IValueConverter
    {
        private const string ProductImagesBasePath = @"D:\VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\Images\";
        private const string DefaultProductImage = @"D:\VsCodeProjects\.VsCodeProjects\.Curs\Edelweiss\задание\задание\resources\Images\picture.png";

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string imagePath = value as string;

            if (string.IsNullOrEmpty(imagePath))
            {
                imagePath = DefaultProductImage;
            }
            else if (!Path.IsPathRooted(imagePath))
            {
                imagePath = Path.Combine(ProductImagesBasePath, imagePath);
            }
            if (!File.Exists(imagePath))
            {
                imagePath = DefaultProductImage;
            }
            try
            {
                BitmapImage bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.UriSource = new Uri(imagePath, UriKind.Absolute);
                bitmap.CacheOption = BitmapCacheOption.OnLoad;
                bitmap.EndInit();
                return bitmap;
            }
            catch
            {
                return null;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
