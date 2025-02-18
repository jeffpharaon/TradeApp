using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TradeApp
{
    public class User
    {
        [Key]
        public int UserID { get; set; }

        [Required]
        public string UserSurname { get; set; }

        [Required]
        public string UserName { get; set; }

        [Required]
        public string UserPatronymic { get; set; }

        [Required]
        public string UserLogin { get; set; }

        [Required]
        public string UserPassword { get; set; }

        [ForeignKey("Role")]
        public int UserRole { get; set; }

        public virtual Role Role { get; set; }

        public string FullName => $"{UserSurname} {UserName} {UserPatronymic}";
    }
}