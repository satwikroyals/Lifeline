using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lifeline.Entity
{
    public class HelpEntity
    {
        public long HelpId {get;set;}
	    public long MemberId {get;set;}
	    public long CoordinatorId {get;set;}
	    public string Message {get;set;}
	    public string Image {get;set;}
	    public decimal Latitude {get;set;}
	    public decimal Longitude {get;set;}
	    public string PostCode {get;set;}
	    public int Status {get;set;}
	    public string VolunteerIds {get;set;}
	    public long RespondId {get;set;}
	    public DateTime CreatedDate {get;set;}

    }

    public class HelpImagesEntity
    {
        public long ImageId { get; set; }
        public long HelpId { get; set; }
        public string ImageName { get; set; }
        public string ImagePath { get { return Settings.GetHelpImages(this.ImageId, this.HelpId, ImageName); } }
        public DateTime CreatedDate { get; set; }
    }

    public class HelpVideosEntity
    {
        public long VideoId { get; set; }
        public long HelpId { get; set; }
        public string VideoName { get; set; }
        public string VideoPath
        {
            get
            {
                return Settings.GetHelpVideos(this.VideoId, this.HelpId, VideoName);
            }
        }
        public DateTime CreatedDate { get; set; }
        public string CreatedDateDisplay { get { return Settings.SetDateTimeFormat(this.CreatedDate); } }
    }



}
