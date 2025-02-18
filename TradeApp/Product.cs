using System.ComponentModel.DataAnnotations;

namespace TradeApp
{
    public class Product
    {
        [Key]
        public string ProductArticleNumber { get; set; }

        [Required]
        public string ProductName { get; set; }

        [Required]
        public string ProductDescription { get; set; }

        [Required]
        public string ProductCategory { get; set; }

        public string ProductPhotoPath { get; set; }

        [Required]
        public string ProductManufacturer { get; set; }

        [Required]
        public decimal ProductCost { get; set; }

        public byte? ProductDiscountAmount { get; set; }

        [Required]
        public int ProductQuantityInStock { get; set; }

        [Required]
        public string ProductStatus { get; set; }
    }
}