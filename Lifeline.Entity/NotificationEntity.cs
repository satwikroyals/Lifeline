using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lifeline.Entity
{
    public class NotificationEntity
    {
        public Int64 Id { get; set; }
        public Int64 NotificationId { get; set; }
        public Int64 CoordinatorId { get; set; }
        public Int64 MemberId { get; set; }
        public string FromName { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public int IsViewed { get; set; }
        public string ToCids { get; set; }
        public int IsActive { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedDatestring { get { return Settings.SetDateFormat(this.CreatedDate); } }
        public int TotalRecords { get; set; }
    }
}
