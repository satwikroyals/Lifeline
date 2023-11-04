using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Lifeline.Entity;
using Lifeline.BAL;
using Lifeline.Code;
using System.IO;
using System.Text.RegularExpressions;

namespace Lifeline.Services
{
    public class MemberController : ApiController
    {
        private MemberManager objmm = new MemberManager();
        [Route("api/MemberLogin")]
        [HttpGet]
        public object MemberLogin(string userid, string pin, string deviceid, int devicetype)
        {
            MemberEntity ce = new MemberEntity();
            StatusResponse se = new StatusResponse();
            try
            {
                ce = objmm.MemberLogin(userid, pin, deviceid, devicetype);
                if (ce == null)
                {
                    se.StatusCode = -1;
                    se.StatusMessage = "It seems your username and/or password do not match—please try again.";
                }
                object res = new object();
                res = new
                {
                    Result = se,
                    Details = ce,
                };
                return res;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "MemberLogin - Services");
                return new MemberEntity();
            }
        }
        [Route("api/MemberRegister")]
        [HttpPost]
        public StatusResponse MemberRegister(MemberEntity cEntity)
        {
            try
            {
                string imgname = "";
                StatusResponse st = new StatusResponse();
                MemberEntity me = new MemberEntity();
                me.MemberId = cEntity.MemberId;
                me.FirstName = cEntity.FirstName;
                me.LastName = cEntity.LastName;
                me.Mobile = cEntity.Mobile;
                me.EmailId = cEntity.EmailId;
                me.LocationId = cEntity.LocationId;
                me.PostCode = cEntity.PostCode;
                me.GeoAddress = cEntity.GeoAddress;
                me.Latitude = cEntity.Latitude;
                me.Longitude = cEntity.Longitude;
                me.UserId = cEntity.UserId;
                me.Pin = cEntity.Pin;
                if (!string.IsNullOrEmpty(cEntity.ProfilePic))
                {
                    imgname = cEntity.MemberId.ToString() + "_" + Guid.NewGuid().ToString() + ".png";
                }
                me.ProfilePic = imgname;
                st=objmm.MemberRegister(me);
                if (cEntity.ProfilePic != "")
                {
                    Globalsettings.SaveFile(cEntity.ProfilePic, imgname, "~/content/customers/" + cEntity.MemberId + "/");
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "MemberRegister-Services");
                return new StatusResponse();
            }
        }
        [Route("api/GetMemberProfile")]
        [HttpGet]
        public MemberEntity GetMemberProfile(Int32 mid)
        {
            try
            {
                return objmm.GetMemberProfile(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetMemberProfile-Services");
                return new MemberEntity();
            }
        }

        [Route("api/UpdateMemberProfileMobileApp")]
        [HttpPost]
        public StatusResponse UpdateMemberProfileMobileApp(MemberEntity cEntity)
        {
            try
            {
                StatusResponse st = new StatusResponse();
                st = objmm.UpdateMemberProfileMobileApp(cEntity);
              
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "UpdateMemberProfileMobileApp-Services");
                return new StatusResponse();
            }
        }

        [Route("api/GetVerificationCode")]
        [HttpGet]
        public LoginResponse GetVerificationCode(string Mobile, string deviceid, int devicetype)
        {
            LoginResponse st = new LoginResponse();
            string VerificationNumber = Globalsettings.RandomNumber();
            st = objmm.CheckMemberRegister(Mobile,deviceid,devicetype);
            if (st.StatusCode > 0)
            {
                Globalsettings.SendSMSMessage(Mobile, "LifeLine Verification Code: " + VerificationNumber);
                st.StatusMessage = VerificationNumber;
            }
            return st;
        }
        [Route("api/AddMemberSOS")]
        [HttpPost]
        public StatusResponse AddMemberSOS(MemberSOSContactEntity cEntity)
        {
            try
            {
                StatusResponse sa = new StatusResponse();
                MemberEntity me = new MemberEntity();
                me = objmm.GetMemberProfile(cEntity.MemberId);
                sa = objmm.AddMemberSOS(cEntity);
                Globalsettings.SendSMSMessage(cEntity.Mobile, me.FirstName + " " + me.LastName + " has made you his SOS contact.");
                return sa;
            }
            catch(Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "AddMemberSOS-Services");
                return new StatusResponse();
            }
        }
        [Route("api/InsertAllSOScontacts")]
        [HttpPost]
        public StatusResponse InsertAllSOScontacts(MemberSOSContacts cs)
        {
            try
            {
                StatusResponse sa = new StatusResponse();
                MemberEntity me = new MemberEntity();
                me=objmm.GetMemberProfile(cs.MemberId);
                sa = objmm.InsertAllSOScontacts(cs);
                foreach (MemberSOSContactEntity surq in cs.Contacts)
                {
                    Globalsettings.SendSMSMessage(surq.Mobile, me.FirstName+" "+me.LastName+ " has made you his SOS contact.");
                }

                return sa;
            }
            catch(Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "InsertAllSOScontacts-Services");
                return new StatusResponse();
            }
        }
        [Route("api/GetMemberCoordinators")]
        [HttpGet]
        public MemberCoordinators GetMemberCoordinators(Int32 mid)
        {
            try
            {
                return objmm.GetMemberCoordinators(mid);
            }
            catch(Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetMemberCoordinators-Services");
                return new MemberCoordinators();
            }
        }

        [Route("api/CoordinatorSeekHelp")]
        [HttpPost]
        public InsertMemberHelpEntity CoordinatorSeekHelp(MemberHelpEntity mEntity)
        {
            try
            {
                string imgname = "";
                StatusResponse st = new StatusResponse();
                MemberHelpEntity sse = new MemberHelpEntity();
                sse.MemberId = mEntity.MemberId;
                sse.Message = mEntity.Message;
                sse.Latitude = mEntity.Latitude;
                sse.Longitude = mEntity.Longitude;
                sse.Postcode = mEntity.Postcode;
                if (!string.IsNullOrEmpty(mEntity.Image))
                {
                    DateTime date = DateTime.Now;
                    string fileext = ".png";
                    string generatefilename = mEntity.MemberId.ToString() + "_" + date.ToString().Replace(":", "").Replace("-", "").Replace("/", "").Replace("\\", "").Replace(" ", "").Trim();
                    imgname = generatefilename + fileext;
                }
                sse.Image = imgname;
                InsertMemberHelpEntity mhe = objmm.CoordinatorSeekHelp(sse);
                if (mhe.HelpId > 0 && !string.IsNullOrEmpty(mEntity.Image))
                {
                    try
                    {
                        byte[] imagedata = Convert.FromBase64String(mEntity.Image);
                        if (imagedata != null && imagedata.Length > 0)
                        {
                            string strFilePath = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/memberhelpimages/" + mhe.HelpId.ToString() + "/") + imgname;
                            FileStream targetStream = null;
                            MemoryStream ms = new MemoryStream(imagedata);
                            Stream sourceStream = ms;
                            string uploadFolder = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/memberhelpimages/" + mhe.HelpId.ToString() + "/");
                            if (!Directory.Exists(uploadFolder))
                            {
                                Directory.CreateDirectory(uploadFolder);
                            }

                            string filePath = Path.Combine(uploadFolder, imgname);
                            // write file using stream.
                            using (targetStream = new FileStream(filePath, FileMode.Create, FileAccess.Write, FileShare.None))
                            {
                                const int bufferLen = 4096;
                                byte[] buffer = new byte[bufferLen];
                                int count = 0;
                                int totalBytes = 0;
                                while ((count = sourceStream.Read(buffer, 0, bufferLen)) > 0)
                                {
                                    totalBytes += count;
                                    targetStream.Write(buffer, 0, count);
                                }
                                targetStream.Close();
                                sourceStream.Close();
                            }
                        }
                    }
                    catch { }
                }             
                return mhe;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "CoordinatorSeekHelp - Services");
                return new InsertMemberHelpEntity();
            }
        }
        
        [Route("api/MemberSeekHelp")]
        [HttpPost]
        public InsertMemberHelpEntity MemberSeekHelp(MemberHelpEntity mEntity)
        {
            try
            {
                string imgname = "";
                StatusResponse st = new StatusResponse();
                MemberHelpEntity sse = new MemberHelpEntity();
                sse.MemberId = mEntity.MemberId;
                sse.Message = mEntity.Message;
                sse.Latitude = mEntity.Latitude;
                sse.Longitude = mEntity.Longitude;
                sse.Postcode = mEntity.Postcode;
                if (!string.IsNullOrEmpty(mEntity.Image))
                {
                    DateTime date = DateTime.Now;
                    string fileext = ".png";
                    string generatefilename = mEntity.MemberId.ToString() + "_" + date.ToString().Replace(":", "").Replace("-", "").Replace("/", "").Replace("\\", "").Replace(" ", "").Trim();
                    imgname = generatefilename + fileext;
                }
                sse.Image = imgname;
                //Return coordinator details.
                InsertMemberHelpEntity mhe = objmm.SeekHelp(sse);
                if (mhe.HelpId > 0 && !string.IsNullOrEmpty(mEntity.Image))
                {
                    try
                    {
                        byte[] imagedata = Convert.FromBase64String(mEntity.Image);
                        if (imagedata != null && imagedata.Length > 0)
                        {
                            string strFilePath = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/memberhelpimages/" + mhe.HelpId.ToString() + "/") + imgname;
                            FileStream targetStream = null;
                            MemoryStream ms = new MemoryStream(imagedata);
                            Stream sourceStream = ms;
                            string uploadFolder = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/memberhelpimages/" + mhe.HelpId.ToString() + "/");
                            if (!Directory.Exists(uploadFolder))
                            {
                                Directory.CreateDirectory(uploadFolder);
                            }

                            string filePath = Path.Combine(uploadFolder, imgname);
                            // write file using stream.
                            using (targetStream = new FileStream(filePath, FileMode.Create, FileAccess.Write, FileShare.None))
                            {
                                const int bufferLen = 4096;
                                byte[] buffer = new byte[bufferLen];
                                int count = 0;
                                int totalBytes = 0;
                                while ((count = sourceStream.Read(buffer, 0, bufferLen)) > 0)
                                {
                                    totalBytes += count;
                                    targetStream.Write(buffer, 0, count);
                                }
                                targetStream.Close();
                                sourceStream.Close();
                            }
                        }
                    }
                    catch { }
                }

                MemberEntity me = new MemberEntity();
                me = objmm.GetMemberProfile(mEntity.MemberId);
                //MemberCoordinators mc = objmm.GetMemberCoordinators(mEntity.MemberId);
                //foreach (MemberSOSContactEntity surq in mc.SOScontacts)
                //{
                //    if (surq.Mobile != null)
                //    {
                //        Globalsettings.SendSMSMessage(surq.Mobile, me.FirstName + " " + me.LastName + " Seeking your help." + "Click on link: " + "http://www.civiccare.net/Member/Help?id=" + me.MemberId);
                //    }
                //}
                List<MemberDevices> mlist = new List<MemberDevices>();
                if (mhe != null)
                {
                    mlist = objmm.GetCoordinatorMemberDevices(mhe.MemberId);
                    //mlist = objmm.GetCoordinatorDevicesByMemberId(mhe.MemberId);
                }
                //List<MemberEntity> clist = objmm.SendNearestCoordinatorNotification(sse.Latitude, sse.Longitude, mEntity.Postcode);
                string[] Andrioddevices = { };
                string[] iphonedevices = { };
                if (mlist.Count>0)
                {
                    Andrioddevices = mlist.Where(m => m.DeviceType == 1).Select(m => m.DeviceId).ToArray();
                    iphonedevices = mlist.Where(m => m.DeviceType == 2).Select(m => m.DeviceId).ToArray();

                    string msg = me.FirstName + " " + me.LastName + " Seeking your help.";
                    if (Andrioddevices != null && Andrioddevices.Count()>0)
                    {
                        Globalsettings.AndroidPushNotifications(Andrioddevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + mhe.HelpId);
                    }
                    if (iphonedevices != null && iphonedevices.Count() > 0)
                    {
                        Globalsettings.IPhonePushNotifications(iphonedevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + mhe.HelpId);
                    }
                    if (mEntity.Message == "")
                    {
                        Globalsettings.SendSMSMessage(mhe.Mobile, me.FirstName + " " + me.LastName + " Seeking your help." + "Click on link: " + "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + mhe.HelpId);
                    }
                    else
                    {
                        Globalsettings.SendSMSMessage(mhe.Mobile, me.FirstName + " " + me.LastName + " " + sse.Message + " - " + "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + mhe.HelpId);
                    }
                }
                //if (mEntity.Image != "")
                //{
                //    Globalsettings.SaveFile(mEntity.Image, imgname, "~/content/MemberHelpimages/" + mEntity.MemberId + "/");
                //}
                return mhe;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "MemberSeekHelp - Services");
                return new InsertMemberHelpEntity();
            }
        }

        [Route("api/AddMemberHelpVideos")]
        [HttpPost]
        public AddHelpVideosResponseEntity AddMemberHelpVideos(AddHelpVideosEntity ent)
        {
            try
            {
                foreach (string video in ent.Videos)
                {
                    byte[] videodata = Convert.FromBase64String(video);
                    DateTime date = DateTime.Now;
                    string fileext= ".mp4";
                    string generatefilename = ent.MemberId.ToString() + "_" + ent.HelpId.ToString() + "_" + date.ToString().Replace(":", "").Replace("-", "").Replace("/", "").Replace("\\", "").Replace(" ", "").Trim();
                    ent.VideoName = generatefilename + fileext;
                    var addhelpvideoresponse = objmm.AddMemberHelpVideos(ent);
                    if (videodata != null && videodata.Length > 0 && addhelpvideoresponse != null)
                    {
                        long videoId = addhelpvideoresponse.VideoId;
                        if (videoId > 0)
                        {
                            string strFilePath = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/memberhelpvideos/" + ent.HelpId.ToString() + "/") + generatefilename + fileext;
                            FileStream targetStream = null;
                            MemoryStream ms = new MemoryStream(videodata);
                            Stream sourceStream = ms;
                            string uploadFolder = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/memberhelpvideos/" + ent.HelpId.ToString() + "/");
                            if (!Directory.Exists(uploadFolder))
                            {
                                Directory.CreateDirectory(uploadFolder);
                            }
                            string filename = generatefilename + fileext;

                            string filePath = Path.Combine(uploadFolder, filename);
                            // write file using stream.
                            using (targetStream = new FileStream(filePath, FileMode.Create, FileAccess.Write, FileShare.None))
                            {
                                const int bufferLen = 4096;
                                byte[] buffer = new byte[bufferLen];
                                int count = 0;
                                int totalBytes = 0;
                                while ((count = sourceStream.Read(buffer, 0, bufferLen)) > 0)
                                {
                                    totalBytes += count;
                                    targetStream.Write(buffer, 0, count);
                                }
                                targetStream.Close();
                                sourceStream.Close();
                            }
                        }
                    }
                }
                return new AddHelpVideosResponseEntity() { IsSuccess = true, ResultMessage ="Videos uploaded successfully." };
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "AddMemberHelpVideos - Services");
                return new AddHelpVideosResponseEntity() { IsSuccess=false,ResultMessage=ex.Message.ToString() };
            }
        }
        [Route("api/GetMemberHelpVideos")]
        [HttpPost]
        public List<HelpVideosEntity> GetMemberHelpVideos(GetMemberHelpVideosParams helpParams)
        {
            try
            {
                return objmm.GetMemberHelpVideos(helpParams);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetMemberHelpVideos - Services");
                return new List<HelpVideosEntity>();
            }
        }

        [Route("api/AddMemberCampaign")]
        [HttpPost]
        public StatusResponse AddMemberCampaign(CampaignEntity cpm)
        {
            try
            {
                StatusResponse st = new StatusResponse();
                string imgname = "";
                if (!string.IsNullOrEmpty(cpm.Image))
                {
                    imgname = cpm.MemberId.ToString() + "_" + "_image_" + Guid.NewGuid().ToString() + ".png";
                }
                st = objmm.AddMemberCampaign(cpm.MemberId, cpm.CampaignTitle,imgname, cpm.LocationId, cpm.StartTime,cpm.EndTime,cpm.GeoLocation,cpm.Latitude,cpm.Longitude,cpm.CampaignInfo,cpm.SpecialInstructions);
                if (st.StatusCode > 0)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(cpm.Image))
                        {
                            Globalsettings.SaveFile(cpm.Image, imgname, "~/content/Campaigns/"+ st.StatusCode +"/");
                        }
                    }
                    catch (Exception ex)
                    {
                        ExceptionUtility.LogException(ex, "InsertChatNewMessage", "Push Notification Error - Services");
                        return st;
                    }
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "AddMemberCampaign - Services");
                return new StatusResponse();
            }
        }
        [Route("api/MemberSignToCampaign")]
        [HttpGet]
        public StatusResponse MemberSignToCampaign(Int32 mid,Int32 campid,string msg)
        {
            try
            {
                return objmm.MemberSignToCampaign(mid, campid, msg);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "MemberSignToCampaign - Services");
                return new StatusResponse();
            }
        }
        [Route("api/UpdateCampignNotificationView")]
        [HttpGet]
        public StatusResponse UpdateCampignNotificationView(Int64 id)
        {
            return objmm.UpdateCampignNotificationView(id);
        }
        [Route("api/GetMemberCampaigns")]
        [HttpGet]
        public Campaigns GetMemberCampaigns(Int32 mid)
        {
            try
            {
                return objmm.GetMemberCampaigns(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetMemberCampaigns - Services");
                return new Campaigns();
            }
        }
        [Route("api/StartCampaign")]
        [HttpGet]
        public StatusResponse StartCampaign(Int32 mid, Int32 campid, decimal Latitude,decimal Longitude)
        {
            try
            {
                return objmm.StartCampaign(mid, campid, Latitude, Longitude);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "StartCampaign - Services");
                return new StatusResponse();
            }
        }
        [Route("api/GetHelpSeekingMember")]
        [HttpGet]
        public HelpSeekingMemberProfile GetHelpSeekingMember(Int32 mid)
        {
            try
            {
                return objmm.GetHelpSeekingMember(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetHelpSeekingMember - Services");
                return new HelpSeekingMemberProfile();
            }
        }
        [Route("api/GetCoordinatorSOSMembers")]
        [HttpGet]
        public CoordinatorSOS GetCoordinatorSOSMembers(Int64 mid)
        {
            try
            {
                return objmm.GetCoordinatorSOSMembers(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetCoordinatorSOSMembers - Services");
                return new CoordinatorSOS();
            }
        }
        [Route("api/GetHelpSeekingMemberDetails")]
        [HttpGet]
        public GetHelpSeekingMemberDetailsModel GetHelpSeekingMemberDetails(long helpid)
        {
            try
            {
                return objmm.GetHelpSeekingMemberDetails(helpid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetHelpSeekingMemberDetails - Services");
                return new GetHelpSeekingMemberDetailsModel() { };
            }
        }
        [Route("api/RescueActionBtn")]
        [HttpGet]
        public HelpStatusResponse RescueActionBtn(long helpid, int action)
        {
            try
            {
                HelpStatusResponse st = new HelpStatusResponse();
                List<MemberDevices> mlist = new List<MemberDevices>();
                st = objmm.RescueActionBtn(helpid, action);
               // List<MemberEntity> clist = objmm.SendNearestCoordinatorNotification(st.Latitude, st.Longitude, st.PostCode);
                List<MemberEntity> clist = objmm.GetIncidentNearestVolunteers(st.Latitude, st.Longitude, st.PostCode);
                MemberEntity me = new MemberEntity();
                me = objmm.GetMemberProfile(st.StatusCode);
                string Volunteerids = "";
                if (clist.Count > 0)
                {
                    foreach (MemberEntity member in clist)
                    {
                        mlist = objmm.GetCoordinatorMemberDevices(member.MemberId);
                        Volunteerids += member.MemberId + ",";
                        string[] Andrioddevices = { };
                        string[] iphonedevices = { };
                        if (mlist.Count > 0)
                        {
                            Andrioddevices = mlist.Where(m => m.DeviceType == 1).Select(m => m.DeviceId).ToArray();
                            iphonedevices = mlist.Where(m => m.DeviceType == 2).Select(m => m.DeviceId).ToArray();

                            string msg = me.FirstName + " " + me.LastName + " Seeking your help.";
                            if (Andrioddevices != null)
                            {
                                Globalsettings.AndroidPushNotifications(Andrioddevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + helpid);
                            }
                            if (iphonedevices != null)
                            {
                                Globalsettings.IPhonePushNotifications(iphonedevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + helpid);
                            }
                        }
                        if (st.StatusMessage == "")
                        {
                            Globalsettings.SendSMSMessage(member.Mobile, me.FirstName + " " + me.LastName + " Seeking your help." + "Click on link: " + "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + helpid);
                        }
                        else
                        {
                            Globalsettings.SendSMSMessage(member.Mobile, me.FirstName + " " + me.LastName + " " + st.StatusMessage + " - " + "http://www.civiccare.net/Member/Help?id=" + me.MemberId + "_" + helpid);
                        }
                    }

                }
                StatusResponse ste = new StatusResponse();
                ste = objmm.AssignToVolunteer(helpid, Volunteerids);
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "RescueActionBtn - Services");
                return new HelpStatusResponse();
            }
        }
        [Route("api/GetHelpSentVolunteers")]
        [HttpGet]
        public List<MemberEntity> GetHelpSentVolunteers(long helpid)
        {
            try
            {
                List<MemberEntity> clist = objmm.GetHelpSentVolunteers(helpid);  
                return clist;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetHelpSentVolunteers - Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/GetCampaignMembers")]
        [HttpGet]
        public List<CampaignMemberEntity> GetCampaignMembers(Int32 mid, Int32 cmid)
        {
            try
            {
                return objmm.GetCampaignMembers(mid,cmid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetCampaignMembers - Services");
                return new List<CampaignMemberEntity>();
            }
        }
        [Route("api/GetMemberTracking")]
        [HttpGet]
        public List<MemberTracking> GetMemberTracking(Int32 mid, Int32 cmid)
        {
            try
            {
                return objmm.GetMemberTracking(mid,cmid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetMemberTracking - Services");
                return new List<MemberTracking>();
            }
        }
        [Route("api/GetCoordinatorVolunteers")]
        [HttpGet]
        public List<MemberEntity> GetCoordinatorVolunteers(Int32 mid)
        {
            try
            {
                return objmm.GetCoordinatorVolunteers(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetCoordinatorVolunteers - Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/AssignToVolunteer")]
        [HttpGet]
        public StatusResponse AssignToVolunteer(Int32 mid,Int32 helpid,string MemberIds)
        {
            try
            {
                StatusResponse st = new StatusResponse();
                st = objmm.AssignToVolunteer(helpid, MemberIds);
                string[] values = MemberIds.Split(',');
                foreach (string id in values)
                {
                    MemberEntity me = new MemberEntity();
                    me = objmm.GetMemberProfile(Convert.ToInt32(id));
                    MemberEntity mme = objmm.GetMemberProfile(mid);
                    List<MemberDevices> mlist = new List<MemberDevices>();
                    mlist = objmm.GetCoordinatorMemberDevices(me.MemberId);
                    string[] Andrioddevices = { };
                    string[] iphonedevices = { };
                    string msg = mme.FirstName + " " + mme.LastName + " Seeking your help.";
                    if (mlist.Count>0)
                    {
                        Andrioddevices = mlist.Where(m => m.DeviceType == 1).Select(m => m.DeviceId).ToArray();
                        iphonedevices = mlist.Where(m => m.DeviceType == 2).Select(m => m.DeviceId).ToArray();
                        if (Andrioddevices != null)
                        {
                            Globalsettings.AndroidPushNotifications(Andrioddevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + mme.MemberId + "_" + helpid);
                        }
                        if (iphonedevices != null)
                        {
                            Globalsettings.IPhonePushNotifications(iphonedevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + mme.MemberId + "_" + helpid);
                        }
                    }
                    Globalsettings.SendSMSMessage(me.Mobile, msg + "Click on link: " + "http://www.civiccare.net/Member/Help?id=" + mme.MemberId + "_" + helpid);
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "AssignToVolunteer - Services");
                return new StatusResponse();
            }
        }
		[Route("api/GetVolunteerTasks")]
        [HttpGet]
        public List<HelpSeekingMemberProfile> GetVolunteerTasks(Int64 volunteerid)
        {
            try
            {
                return objmm.GetVolunteerTasks(volunteerid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetVolunteerTasks - Services");
                return new List<HelpSeekingMemberProfile>();
            }
        }
		[Route("api/VolunteerRescueActionBtn")]
        [HttpGet]
        public StatusResponse VolunteerRescueActionBtn(Int64 helpid, Int64 volunteerid)
        {
            try
            {
                HelpSeekingMemberProfile hentity = new HelpSeekingMemberProfile();
                StatusResponse st = new StatusResponse();
                hentity = objmm.GetHelpbyId(helpid);
                MemberEntity mme = objmm.GetMemberProfile(hentity.MemberId);
                MemberEntity me = objmm.GetMemberProfile(volunteerid);
                st = objmm.VolunteerRescueActionBtn(helpid, volunteerid);
                List<MemberDevices> mlist = new List<MemberDevices>();
                mlist = objmm.GetCoordinatorMemberDevices(hentity.CoordinatorId);
                string[] Andrioddevices = { };
                string[] iphonedevices = { };
                string msg = mme.FirstName + " " + mme.LastName + " Rescued by " + me.FirstName + " " + me.LastName;
                if (mlist.Count > 0)
                {
                    Andrioddevices = mlist.Where(m => m.DeviceType == 1).Select(m => m.DeviceId).ToArray();
                    iphonedevices = mlist.Where(m => m.DeviceType == 2).Select(m => m.DeviceId).ToArray();
                    if (Andrioddevices != null)
                    {
                        Globalsettings.AndroidPushNotifications(Andrioddevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + me.MemberId);
                    }
                    if (iphonedevices != null)
                    {
                        Globalsettings.IPhonePushNotifications(iphonedevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + me.MemberId);
                    }
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "VolunteerRescueActionBtn - Services");
                return new StatusResponse();
            }
        }

        [Route("api/RespondHelpByVolunteer")]
        [HttpPost]
        public RespondHelpByVolunteerResponse RespondHelpByVolunteer(RespondHelpByVolunteerParams p)
        {
            try
            {
                HelpSeekingMemberProfile hentity = new HelpSeekingMemberProfile();
                RespondHelpByVolunteerResponse st = new RespondHelpByVolunteerResponse();
                hentity = objmm.GetHelpbyId(p.HelpId);
                MemberEntity mme = objmm.GetMemberProfile(hentity.MemberId);
                MemberEntity me = objmm.GetMemberProfile(p.MemberId);
                st = objmm.RespondHelpByVolunteer(p);
                if (st.RespondId > 0)
                {
                    if (mme != null && me != null)
                    {
                        List<MemberDevices> mlist = new List<MemberDevices>();
                        mlist = objmm.GetCoordinatorMemberDevices(hentity.CoordinatorId);
                        string[] Andrioddevices = { };
                        string[] iphonedevices = { };
                        string msg = "";
                        if (p.IsAccepted)
                        {
                            msg = me.FirstName + " " + me.LastName + " accepted help for " + mme.FirstName + " " + mme.LastName;
                        }
                        else
                        {
                            msg = me.FirstName + " " + me.LastName + " declined help for " + mme.FirstName + " " + mme.LastName;
                        }
                        if (mlist.Count > 0)
                        {
                            Andrioddevices = mlist.Where(m => m.DeviceType == 1).Select(m => m.DeviceId).ToArray();
                            iphonedevices = mlist.Where(m => m.DeviceType == 2).Select(m => m.DeviceId).ToArray();
                            if (Andrioddevices != null)
                            {
                                Globalsettings.AndroidPushNotifications(Andrioddevices, "1", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + p.HelpId+"_"+me.MemberId);
                            }
                            if (iphonedevices != null)
                            {
                                Globalsettings.IPhonePushNotifications(iphonedevices, "2", msg, "SOS ", "http://www.civiccare.net/Member/Help?id=" + p.HelpId + "_" + me.MemberId);
                            }
                        }
                    }
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "RespondHelpByVolunteer - Services");
                return new RespondHelpByVolunteerResponse();
            }
        }

        [Route("api/GetHelpRespondedVolunteerDetails")]
        [HttpPost]
        public HelpRespondedVolunteerDetailsResponse GetHelpRespondedVolunteerDetails(HelpRespondedVolunteerDetailsParams p)
        {
            try
            {
                var resp = objmm.GetHelpRespondedVolunteerDetails(p);
                if (resp == null)
                {
                    resp = new HelpRespondedVolunteerDetailsResponse();
                }
                return resp;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "HelpRespondedVolunteerDetails - Services");
                return new HelpRespondedVolunteerDetailsResponse();
            }
        }

        [Route("api/UpdateProfile")]
        [HttpPost]
        public StatusResponse UpdateProfile(MemberEntity cEntity)
        {
            try
            {
                string imgname = "";
                StatusResponse st = new StatusResponse();
                MemberEntity me = new MemberEntity();
                me.MemberId = cEntity.MemberId;
                me.FirstName = cEntity.FirstName;
                me.LastName = cEntity.LastName;
                me.Mobile = cEntity.Mobile;
                me.EmailId = cEntity.EmailId;
                me.LocationId = cEntity.LocationId;
                me.PostCode = cEntity.PostCode;
                me.GeoAddress = cEntity.GeoAddress;
                me.Latitude = cEntity.Latitude;
                me.Longitude = cEntity.Longitude;
                me.UserId = cEntity.UserId;
                me.Pin = cEntity.Pin;
                if (!string.IsNullOrEmpty(cEntity.ProfilePic))
                {
                    imgname = cEntity.MemberId.ToString() + "_" + Guid.NewGuid().ToString() + ".png";
                }
                me.ProfilePic = imgname;
                st = objmm.MemberRegister(me);
                if (cEntity.ProfilePic != "")
                {
                    Globalsettings.SaveFile(cEntity.ProfilePic, imgname, "~/content/customers/" + cEntity.MemberId + "/");
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "MemberRegister-Services");
                return new StatusResponse();
            }
        }
        [Route("api/InsertSupportMessage")]
        [HttpPost]
        public StatusResponse InsertSupportMessage(MemberSupportEntity Sentity)
        {
            try
            {
                return objmm.InsertSupportMessage(Sentity);
            }
            catch(Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "InsertSupportMessage-Services");
                return new StatusResponse();
            }
        }
        [Route("api/DeleteSOScontact")]
        [HttpGet]
        public StatusResponse DeleteSOScontact(Int64 contactid)
        {
            try
            {
                return objmm.DeleteSOScontact(contactid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "DeleteSOScontact-Services");
                return new StatusResponse();
            }
        }
        [Route("api/GetCoordinatorsList")]
        [HttpGet]
        public List<MemberEntity> GetCoordinatorsList(Int32 lid,[FromUri]paggingEntity es)
        {
            try
            {
                AdminManager am=new AdminManager();
                return am.GetCoordinatorsList(es, lid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetCoordinatorsList-Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/GetCoordinatorLocationMembers")]
        [HttpGet]
        public List<MemberEntity> GetCoordinatorLocationMembers(Int64 mid)
        {
            try
            {
                return objmm.GetCoordinatorLocationMembers(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetCoordinatorLocationMembers-Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/GetCoordinatorMembers")]
        [HttpGet]
        public List<MemberEntity> GetCoordinatorMembers(long mid)
        {
            try
            {
                return objmm.GetCoordinatorMembers(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "GetCoordinatorMembers-Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/CheckUserLogin")]
        [HttpGet]
        public object CheckUserLogin(string userid, string pin, string deviceid, int devicetype)
        {
            MemberEntity ce = new MemberEntity();
            StatusResponse se = new StatusResponse();
            try
            {
                ce = objmm.CheckUserLogin(userid, pin, deviceid, devicetype);
                if (ce == null)
                {
                    se.StatusCode = -1;
                    se.StatusMessage = "It seems your username and/or password do not match—please try again.";
                }
                object res = new object();
                res = new
                {
                    Result = se,
                    Details = ce,
                };
                return res;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "CheckUserLogin - Services");
                return new MemberEntity();
            }
        }

        [Route("api/InactiveMemberFromMobileApp")]
        [HttpGet]
        public object InactiveMemberFromMobileApp(long mid)
        {
            StatusResponse se = new StatusResponse();
            try
            {
                int ce = objmm.InactiveMemberFromMobileApp(mid);               
                se.StatusCode = 1;
                se.StatusMessage = "Account deleted successfully.";
               
                return se;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Member", "InactiveMemberFromMobileApp - Services");
                return new StatusResponse() { StatusCode=-1,StatusMessage="Some problem occurred." };
            }
        }


        [Route("api/MemberRegisterMobileApp")]
        [HttpPost]
        public MemberRegisterMobileAppResponse MemberRegisterMobileApp(MemberRegisterMobileAppEntity cEntity)
        {
            try
            {
                return objmm.MemberRegisterMobileApp(cEntity);  
            }
            catch (Exception ex)
            {
                return new MemberRegisterMobileAppResponse();
            }
        }
    }
}
