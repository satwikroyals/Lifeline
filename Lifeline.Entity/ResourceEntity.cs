using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lifeline.Entity
{
    public class ResourceEntity
    {
        public Int64 ResourceId { get; set; }
        public string CaseStudyId { get; set; }
        public string DocTitle { get; set; }
        public string ResourceDoc { get; set; }
        public string ResourceFilePath { get { return Settings.GetResourceDocFile(this.ResourceId, this.ResourceDoc); } }
        public string ResourceBrief { get; set; }
        public string VideoUrl { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedDateString { get { return Settings.SetDateFormat(this.CreatedDate); } }
        public int TotalRecords { get; set; }
    }
}
