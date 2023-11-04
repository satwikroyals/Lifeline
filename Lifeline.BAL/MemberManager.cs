using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.Entity;
using Lifeline.DAL;

namespace Lifeline.BAL
{
    public class MemberManager
    {
        private MemberData objmd = new MemberData();
        public MemberEntity MemberLogin(string userid, string pin, string deviceid, int devicetype)
        {
            return objmd.MemberLogin(userid, pin, deviceid, devicetype);
        }
        public StatusResponse MemberRegister(MemberEntity cEntity)
        {
            return objmd.MemberRegister(cEntity);
        }
        public MemberEntity GetMemberProfile(Int64 mid)
        {
            return objmd.GetMemberProfile(mid);
        }
        public StatusResponse UpdateMemberProfileMobileApp(MemberEntity cEntity)
        {
            return objmd.UpdateMemberProfileMobileApp(cEntity);
        }
        public StatusResponse AddMemberSOS(MemberSOSContactEntity cEntity)
        {
            return objmd.AddMemberSOS(cEntity);
        }
        public LoginResponse CheckMemberRegister(string Mobile, string deviceid, int devicetype)
        {
            return objmd.CheckMemberRegister(Mobile,deviceid,devicetype);
        }
        public StatusResponse InsertAllSOScontacts(MemberSOSContacts cs)
        {
            return objmd.InsertAllSOScontacts(cs);
        }
        public MemberCoordinators GetMemberCoordinators(Int32 mid)
        {
            return objmd.GetMemberCoordinators(mid);
        }
        public InsertMemberHelpEntity CoordinatorSeekHelp(MemberHelpEntity mEntity)
        {
            return objmd.CoordinatorSeekHelp(mEntity);
        }
        public InsertMemberHelpEntity SeekHelp(MemberHelpEntity mEntity)
        {
            return objmd.SeekHelp(mEntity);
        }
        public AddHelpVideosResponseEntity AddMemberHelpVideos(AddHelpVideosEntity ent)
        {
            return objmd.AddMemberHelpVideos(ent);
        }
        public List<HelpVideosEntity> GetMemberHelpVideos(GetMemberHelpVideosParams helpParams)
        {
            return objmd.GetMemberHelpVideos(helpParams);
        }
        public StatusResponse AddMemberCampaign(Int32 MemberId, string CampaignTitle, string Image, int LocationId, DateTime? StartTime, DateTime? EndTime, string GeoLocation, decimal Latitude, decimal Longitude, string CampaignInfo, string SpecialInstructions)
        {
            return objmd.AddMemberCampaign(MemberId, CampaignTitle, Image, LocationId, StartTime, EndTime, GeoLocation, Latitude, Longitude, CampaignInfo, SpecialInstructions);
        }
        public StatusResponse MemberSignToCampaign(Int32 mid,Int32 campid,string msg)
        {
            return objmd.MemberSignToCampaign(mid, campid, msg);
        }
        public StatusResponse UpdateCampignNotificationView(Int64 id)
        {
            return objmd.UpdateCampignNotificationView(id);
        }
        public Campaigns GetMemberCampaigns(Int32 mid)
        {
            return objmd.GetMemberCampaigns(mid);
        }
        public StatusResponse StartCampaign(Int32 mid, Int32 campid, decimal Latitude,decimal Longitude)
        {
            return objmd.StartCampaign(mid, campid, Latitude, Longitude);
        }
        public HelpSeekingMemberProfile GetHelpSeekingMember(long mid)
        {
            return objmd.GetHelpSeekingMember(mid);
        }
        public List<MemberDevices> GetCoordinatorMemberDevices(Int64 mid)
        {
            return objmd.GetCoordinatorMemberDevices(mid);
        }
        public List<MemberDevices> GetCoordinatorDevicesByMemberId(Int64 mid)
        {
            return objmd.GetCoordinatorDevicesByMemberId(mid);
        }
        public CoordinatorSOS GetCoordinatorSOSMembers(Int64 mid)
        {
            return objmd.GetCoordinatorSOSMembers(mid);
        }
        public GetHelpSeekingMemberDetailsModel GetHelpSeekingMemberDetails(long helpid)
        {
            return objmd.GetHelpSeekingMemberDetails(helpid);
        }
        public HelpStatusResponse RescueActionBtn(Int64 helpid, int action)
        {
            return objmd.RescueActionBtn(helpid, action);
        }
        public List<MemberEntity> SendNearestCoordinatorNotification(double Latitude, double Longitude, string Postcode)
        {
            return objmd.SendNearestCoordinatorNotification(Latitude, Longitude, Postcode);
        }
        public List<MemberEntity> GetIncidentNearestVolunteers(double Latitude, double Longitude, string Postcode)
        {
            return objmd.GetIncidentNearestVolunteers(Latitude, Longitude, Postcode);
        }
        public List<MemberEntity> GetHelpSentVolunteers(long helpid)
        {
            return objmd.GetHelpSentVolunteers(helpid);
        }
        public List<CampaignMemberEntity> GetCampaignMembers(Int32 mid,Int32 cmid)
        {
            return objmd.GetCampaignMembers(mid, cmid);
        }
        public List<MemberTracking> GetMemberTracking(Int32 mid, Int32 cmid)
        {
            return objmd.GetMemberTracking(mid, cmid);
        }
        public List<MemberEntity> GetCoordinatorVolunteers(Int32 mid)
        {
            return objmd.GetCoordinatorVolunteers(mid);
        }
        public StatusResponse AssignToVolunteer(Int64 helpid, string MemberIds)
        {
            return objmd.AssignToVolunteer(helpid, MemberIds);
        }
        public List<HelpSeekingMemberProfile> GetVolunteerTasks(Int64 volunteerid)
        {
            return objmd.GetVolunteerTasks(volunteerid);
        }
        public StatusResponse VolunteerRescueActionBtn(Int64 helpid, Int64 volunteerid)
        {
            return objmd.VolunteerRescueActionBtn(helpid, volunteerid);
        }
        public RespondHelpByVolunteerResponse RespondHelpByVolunteer(RespondHelpByVolunteerParams p)
        {
            return objmd.RespondHelpByVolunteer(p);
        }
        public HelpRespondedVolunteerDetailsResponse GetHelpRespondedVolunteerDetails(HelpRespondedVolunteerDetailsParams p)
        {
            return objmd.GetHelpRespondedVolunteerDetails(p);
        }
        public HelpSeekingMemberProfile GetHelpbyId(Int64 helpid)
        {
            return objmd.GetHelpbyId(helpid);
        }
        public StatusResponse InsertSupportMessage(MemberSupportEntity Sentity)
        {
            return objmd.InsertSupportMessage(Sentity);
        }
        public StatusResponse DeleteSOScontact(Int64 contactid)
        {
            return objmd.DeleteSOScontact(contactid);
        }
        public List<MemberEntity> GetCoordinatorLocationMembers(Int64 mid)
        {
            return objmd.GetCoordinatorLocationMembers(mid);
        }
        public List<MemberEntity> GetCoordinatorMembers(long mid)
        {
            return objmd.GetCoordinatorMembers(mid);
        }
        public MemberEntity CheckUserLogin(string userid, string pin, string deviceid, int devicetype)
        {
            return objmd.CheckUserLogin(userid, pin, deviceid, devicetype);
        }

        public int InactiveMemberFromMobileApp(long mid)
        {
            return objmd.InactiveMemberFromMobileApp(mid);
        }

        public MemberRegisterMobileAppResponse MemberRegisterMobileApp(MemberRegisterMobileAppEntity cEntity)
        {
            return objmd.MemberRegisterMobileApp(cEntity);
        }
    }
}
