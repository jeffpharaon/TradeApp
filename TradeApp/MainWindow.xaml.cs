using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;

namespace TradeApp
{
    public partial class MainWindow : Window
    {
        public ObservableCollection<Product> AllProducts { get; set; }
        public ObservableCollection<Product> FilteredProducts { get; set; }
        public User CurrentUser { get; set; }

        public MainWindow(User user)
        {
            InitializeComponent();
            CurrentUser = user;
            DataContext = this;
            LoadProducts();
            LoadManufacturers();
        }

        private void LoadProducts()
        {
            using (var context = new TradeContext())
            {
                var products = context.Products.ToList();
                AllProducts = new ObservableCollection<Product>(products);
            }
            FilterProducts();
        }

        private void LoadManufacturers()
        {
            var manufacturers = AllProducts.Select(p => p.ProductManufacturer).Distinct();
            foreach (var m in manufacturers)
            {
                ManufacturerComboBox.Items.Add(new ComboBoxItem { Content = m });
            }
        }

        private void FilterProducts()
        {
            string searchText = SearchTextBox.Text.ToLower();
            string selectedManufacturer = (ManufacturerComboBox.SelectedItem as ComboBoxItem)?.Content.ToString() ?? "Все производители";

            var filtered = AllProducts.Where(p =>
                (string.IsNullOrEmpty(searchText) ||
                 p.ProductName.ToLower().Contains(searchText) ||
                 p.ProductDescription.ToLower().Contains(searchText) ||
                 p.ProductManufacturer.ToLower().Contains(searchText)) &&
                (selectedManufacturer == "Все производители" || p.ProductManufacturer == selectedManufacturer)
            );

            FilteredProducts = new ObservableCollection<Product>(filtered);
            ProductsDataGrid.ItemsSource = FilteredProducts;
            ProductCountTextBlock.Text = $"{FilteredProducts.Count} из {AllProducts.Count}";
        }

        private void SearchTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            FilterProducts();
        }

        private void ManufacturerComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            FilterProducts();
        }

        private void Logout_Click(object sender, RoutedEventArgs e)
        {
            LoginWindow login = new LoginWindow();
            login.Show();
            this.Close();
        }
    }
}
