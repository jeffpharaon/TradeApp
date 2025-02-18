using Microsoft.EntityFrameworkCore;

namespace TradeApp
{
    public class TradeContext : DbContext
    {
        public TradeContext() : base(
            new DbContextOptionsBuilder<TradeContext>()
                .UseSqlServer("Data Source=EDELWEISS\\SQLEXPRESS;Initial Catalog=Trade;Integrated Security=True")
                .Options){}

        public TradeContext(DbContextOptions<TradeContext> options) : base(options){}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
                optionsBuilder.UseSqlServer("Data Source=EDELWEISS\\SQLEXPRESS;Initial Catalog=Trade;Integrated Security=True");
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Product> Products { get; set; }
    }
}
