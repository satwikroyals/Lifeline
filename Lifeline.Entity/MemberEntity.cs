using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lifeline.Entity
{
    public class MemberEntity
    {
        string _fname;
        string _lname;
        string _mobile;
        string _email;
        string _city;
        string _postcode;
        string _address;
        public Int32 MemberId { get; set; }
        public Int32 CoordinatorId { get; set; }
        public string FirstName { get { return Settings.SetFont(this._fname); } set { _fname = value; } }
        public string LastName { get { return Settings.SetFont(this._lname); } set { _lname = value; } }
        public string UserId { get { return Settings.SetFont(this._mobile); } set { _mobile = value; } }
        public string Pin { get; set; }
        public string ProfilePic { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.MemberId, this.ProfilePic); } }
        public Int64 LocationId { get; set; }
        public string Location { get; set; }
        public int CountryId { get; set; }
        public int StateId { get; set; }
        public string Mobile { get; set; }
        public string EmailId { get; set; }
        public string PostCode { get; set; }
        //public string CountryName { get { return CountryId == 1 ? "Australia" : CountryId == 2 ? "Canada" : CountryId == 3 ? "India" : CountryId == 4 ? "Malaysia" : CountryId == 5 ? "New Zealand" : CountryId == 6 ? "Singapore" : CountryId == 7 ? "United Kingdom" : CountryId == 8 ? "USA" : ""; } }
        public string CommunityBelong { get; set; }
        public int Gender { get; set; }
        public string GeoAddress { get { return Settings.SetFont(this._address); } set { _address = value; } }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Street { get; set; }
        public string Suburb { get; set; }
        public string City { get; set; }
        public string MemberInfo { get; set; }
        public string OrganisationName { get; set; }
        public Int32 ReferredById { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Createdstring { get { return Settings.SetDateTimeFormat(this.CreatedDate); } }
        public DateTime ModifiedDate { get; set; }
        public string Modifiedstring { get { return Settings.SetDateTimeFormat(this.ModifiedDate); } }
        public int TotalRecords { get; set; }
        public int IsFriend { get; set; }
        public int IsCoordinator { get; set; }
        public string UserType { get { return IsCoordinator == 1 ? "Volunteer" : IsCoordinator == 2 ? "Coordinator" : IsCoordinator == 3 ? "TownCoordinator" : ""; } }
        public string RequestStatus { get; set; }
        public int RequestSent { get; set; }
        public int Status { get; set; }
        public string HelpLineNumber { get; set; }
        public string CoordinatorNumber { get; set; }
    }

    public class StatusResponse
    {
        public int StatusCode { get; set; }
        public string StatusMessage { get; set; }

    }
    public class HelpStatusResponse
    {
        public int StatusCode { get; set; }
        public string StatusMessage { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string PostCode { get; set; }

    }
    public class LoginResponse
    {
        public int StatusCode { get; set; }
        public string StatusMessage { get; set; }
        public int IsVolunteer { get; set; }
        public string HelpLineNumber { get; set; }
        public string CoordinatorNumber { get; set; }

    }
    public class MemberSOSContactEntity
    {
        public Int64 ContactId { get; set; }
        public Int32 MemberId { get; set; }
        public string Name { get; set; }
        public string EmailId { get; set; }
        public string Mobile { get; set; }
    }
    public class MemberSOSContacts
    {
        public Int32 MemberId { get; set; }
        public List<MemberSOSContactEntity> Contacts { get; set; }
    }
    public class MemberCoordinators
    {
        public List<MemberSOSContactEntity> SOScontacts { get; set; }
        public List<MemberEntity> TownCoordinators { get; set; }
        public List<MemberEntity> AreaCoordinators { get; set; }
        public List<MemberEntity> AreaVolunteers { get; set; }
    }
    public class MemberHelpEntity
    {
        public Int32 MemberId { get; set; }
        public string Message { get; set; }
        public string Image { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Postcode { get; set; }
    }

    public class AddHelpVideosEntity
    {     
        public long HelpId { get; set; }
        public long MemberId { get; set; }
        public string[] Videos { get; set; }        
        public string VideoName { get; set; }   
    }

    public class AddHelpVideosResponseEntity:ApiCrudResponse
    {
        public long VideoId { get; set; }
    }
   
    public class Campaigns
    {
        public List<CampaignEntity> NewCampaigns { get; set; }
        public List<CampaignEntity> signed { get; set; }
        public List<CampaignEntity> Completed { get; set; }
    }
    public class CampaignEntity
    {
        public Int32 CampaignId { get; set; }
        public Int32 CampaignMemberId { get; set; }
        public Int32 MemberId { get; set; }
        public string ToIds { get; set; }
        public string CampaignTitle { get; set; }
        public string Image { get; set; }
        public string ImagePath { get { return Settings.GetCampaignImage(this.CampaignId, this.Image); } }
        public int LocationId { get; set; }
        public DateTime? StartTime { get; set; }
        public string Datestring { get { return Settings.SetDateTimeFormat(this.StartTime); } }
        public DateTime? EndTime { get; set; }
        public string Timestring { get { return Settings.SetDateTimeFormat(this.EndTime); } }
        public string Location { get; set; }
        public string GeoLocation { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public int Status { get; set; }
        public string CampaignInfo { get; set; }
        public string SpecialInstructions { get; set; }
        public int TotalRecords { get; set; }
    }
    public class HelpSeekingMemberProfile
    {
        private string _helperName = "";
        public Int64 MemberId { get; set; }
        public Int64 HelpId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string VictimName { get; set; }
        public string HelperName { get { return this._helperName; } set { this._helperName = value; } }
        public string Mobile { get; set; }
        public string ProfilePic { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.MemberId, this.ProfilePic); } }
        public string Location { get; set; }
        public string GeoAddress { get; set; }
        public string Message { get; set; }
        public string Image { get; set; }
        public string ImagePath { get { return Settings.GetHelpImage(this.MemberId, this.Image); } }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public Int64 CoordinatorId { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreateDatestring { get { return Settings.SetDateTimeFormat(this.CreatedDate); } }
        public int TotalRecords { get; set; }

        public long IncidentImageId { get; set; }
        public string IncidentImageName { get; set; }
        public string IncidentImagePath { get { return Settings.GetHelpImages(this.IncidentImageId, this.HelpId, IncidentImageName); } }
        public long VideoId { get; set; }
        public string VideoName { get; set; }
        public string VideoPath
        {
            get
            {
                return Settings.GetHelpVideos(this.VideoId, this.HelpId, VideoName);
            }
        }
    }
    public class MemberDevices
    {
        public Int64 CAppdeviceId { get; set; }
        public string DeviceId { get; set; }
        public string MemberId { get; set; }
        public int DeviceType { get; set; }
    }
    public class CoordinatorSOS
    {
        public List<HelpSeekingMemberProfile> Latest { get; set; }
        public List<HelpSeekingMemberProfile> Noticed { get; set; }
    }
    public class CampaignMemberEntity
    {
        public Int64 CampaignMemberTrackingId { get; set; }
        public Int32 CampaignId { get; set; }
        public Int32 MemberId { get; set; }
        public string CampaignTitle { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Mobile { get; set; }
        public string Message { get; set; }
        public string ProfilePic { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.MemberId, this.ProfilePic); } }
        public int TotalRecords { get; set; }
    }
    public class MemberTracking
    {
        public Int64 CampaignMemberTrackingId { get; set; }
        public Int32 CampaignId { get; set; }
        public Int32 MemberId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
    }
    public class MemberSupportEntity
    {
        public Int64 SupportId { get; set; }
        public Int64 MemberId { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public int HandledBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedDatestring { get { return Settings.SetDateFormat(this.CreatedDate); } }
    }

    public class InsertMemberHelpEntity
    {
        string _fname;
        string _lname;
        public long HelpId { get; set; }
        public long MemberId { get; set; }
        public long CoordinatorId { get; set; }
        public string FirstName { get { return Settings.SetFont(this._fname); } set { _fname = value; } }
        public string LastName { get { return Settings.SetFont(this._lname); } set { _lname = value; } }
        public string Name { get { return this.FirstName + " " + this.LastName; } }     
        public string Mobile { get; set; }
        public string EmailId { get; set; }
        public string PostCode { get; set; }       
        public string GeoAddress { get;set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }    
    }

    public class GetMemberHelpVideosParams
    {
        public long MemberId { get; set; }
        public long HelpId { get; set; }
    }

    public class GetHelpSeekingMemberDetailsModel
    {
        public HelpSeekingMemberProfile Member { get; set; }
        public List<HelpImagesEntity> Images { get; set; }
        public List<HelpVideosEntity> Videos { get; set; }
    }

    public class RespondHelpByVolunteerParams
    {
        public long MemberId { get; set; }
        public long HelpId { get; set; }
        public bool IsAccepted { get; set; }
    }

    public class RespondHelpByVolunteerResponse
    {
        public long RespondId { get; set; }
        public long RespondedMemberId { get; set; }
        public string RespondedMemberName { get; set; }
        public string Message { get; set; }
    }

    public class HelpRespondedVolunteerDetailsParams
    {
        public long MemberId { get; set; }
        public long HelpId { get; set; }
    }

    public class HelpRespondVolunteersEntity
    {
        public long RespondId { get; set; }
        public long MemberId { get; set; }
        public long HelpId { get; set; }
        public bool IsAccepted { get; set; }
        public DateTime RespondDate { get; set; }
    }

    public class HelpRespondedVolunteerDetailsResponse : HelpRespondVolunteersEntity
    {
        string _fname;
        string _lname;
        string _emailid = "";
        public string FirstName { get { return Settings.SetFont(this._fname); } set { _fname = value; } }
        public string LastName { get { return Settings.SetFont(this._lname); } set { _lname = value; } }
        public string Name { get { return this.FirstName + " " + this.LastName; } }
        public string Mobile { get; set; }
        public string EmailId { get { return Settings.SetFont(this._emailid); } set { _emailid = value; } }
        public string PostCode { get; set; }
        public string GeoAddress { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string ProfilePic { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.MemberId, this.ProfilePic); } }
        public string DisplayRespondDate { get { return Settings.SetDateTimeFormat(this.RespondDate); } }
    }

    public class MemberRegisterMobileAppEntity
    {
        string _fname;
        string _lname;
        string _mobile;
        string _email;
        string _city;
        string _postcode;
        string _address;
        public Int32 CoordinatorId { get; set; }
        public string FirstName { get { return Settings.SetFont(this._fname); } set { _fname = value; } }
        public string LastName { get { return Settings.SetFont(this._lname); } set { _lname = value; } }
        public string UserId { get; set; }
        public string Pin { get; set; }
        public string Mobile { get; set; }
        public string EmailId { get; set; }
        public string PostCode { get; set; }      
        public string GeoAddress { get { return Settings.SetFont(this._address); } set { _address = value; } }
        public double Latitude { get; set; }
        public double Longitude { get; set; }     
        public int IsCoordinator { get; set; }
        public int MemberType { get; set; }
    }

    public class MemberRegisterMobileAppResponse:BaseResponse
    {

    }

}
