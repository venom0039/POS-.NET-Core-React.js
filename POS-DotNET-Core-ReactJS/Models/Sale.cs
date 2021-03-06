using System.ComponentModel.DataAnnotations;

namespace POS_DotNET_Core_ReactJS.Models
{
    public class Sale
    {
        [Key]
        public int CartID { get; set; }
        [Required]
        public int BillNo { get; set; }
        [Required]
        public int ItemID { get; set; }
        [Required]
        public int StockID { get; set; }
        [Required]
        public double SoldQty { get; set; }
        [Required]
        public double SoldPrice { get; set; }
        [Required]
        public int SellerID { get; set; }
        [Required]
        public DateTime Timescape { get; set; }
    }
}
