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

namespace Lifeline.Services
{
    public class MessageController : ApiController
    {
        private MessageManager objmsgm = new MessageManager();
        [Route("api/GetAllMembers")]
        [HttpGet]
        public List<MemberEntity> GetAllMembers(Int64 mid,string search)
        {
            try
            {
                return objmsgm.GetAllMembers(mid, search);
            }
            catch(Exception ex)
            {
                ExceptionUtility.LogException(ex, "MessageController", "GetAllMembers-Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/GetMemberFriends")]
        [HttpGet]
        public List<MemberEntity> GetMemberFriends(Int64 mid, int status, string srchname)
        {
            try
            {
                return objmsgm.GetMemberFriends(mid, status, srchname);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "MessageController", "GetMemberFriends-Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/AddOrRemoveFriend")]
        [HttpGet]
        public object AddOrRemoveFriend(Int64 mid, Int64 frid, int action)
        {
            try
            {
                Int32 res = objmsgm.AddOrRemoveFriend(mid, frid, action);
                return new { Result = res };
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "MessageController", "AddOrRemoveFriend-Services");
                return new { Result = 0 };
            }
        }
        [Route("api/GetMemberGroupMessages")]
        [HttpGet]
        public List<MessagePostEntity> GetMemberGroupMessages(Int32 mid, Int32 gid, [FromUri]paggingEntity es)
        {
            try
            {
                return objmsgm.GetMemberGroupMessages(es, mid, gid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "MessageController", "GetMemberGroupMessages - Services");
                return new List<MessagePostEntity>();
            }
        }
        [Route("api/GetMemberWallPostMessages")]
        [HttpGet]
        public List<MessagePostEntity> GetMemberWallPostMessages(Int32 mid, [FromUri]paggingEntity es)
        {
            try
            {
                return objmsgm.GetMemberWallPostMessages(es, mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "MessageController", "GetMemberWallPostMessages - Services");
                return new List<MessagePostEntity>();
            }
        }


        [Route("api/GroupPostMessage")]
        [HttpPost]
        public StatusResponse GroupPostMessage(PostMessage pm)
        {
            try
            {
                StatusResponse st = new StatusResponse();
                string imgname = "";
                string videoname = "";
                if (!string.IsNullOrEmpty(pm.Pimage))
                {
                    imgname = pm.groupid.ToString() + "_image_" + Guid.NewGuid().ToString() + "." + pm.imgextension;
                }
                if (!string.IsNullOrEmpty(pm.Pvideo))
                {
                    videoname = pm.groupid.ToString() + "_video_" + Guid.NewGuid().ToString() + "." + pm.vidextension;
                }
                st = objmsgm.PostMessage(pm.groupid, pm.mid, pm.msg, imgname, videoname);
                if (st.StatusCode > 0)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(pm.Pimage))
                        {
                            Globalsettings.SaveFile(pm.Pimage, imgname, "~/content/postmessages/");
                        }
                        if (!string.IsNullOrEmpty(pm.Pvideo))
                        {
                            Globalsettings.SaveFile(pm.Pvideo, videoname, "~/content/postmessages/");
                        }
                        //string[] andevices = objmsgm.GetAndroidDevices(pm.orgid, pm.cid).Split(',');
                        //var orgdetails = objom.GetOrgById(pm.orgid);
                        //string appkey = orgdetails.AndroidPushKey;  // "AIzaSyB1cZ7lABHjcZhkfGiej0kHYQSqMbtMul4";
                        //Globalsettings.AndroidPushNotifications(andevices, pm.msg, "New Message", "", appkey);
                    }
                    catch (Exception ex)
                    {
                        ExceptionUtility.LogException(ex, "WallPostMessage", "Push Notification Error - Services");
                        return st;
                    }
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "WallPostMessage", "WallPostMessage - Services");
                return new StatusResponse();
            }
        }
        [Route("api/removemessage")]
        [HttpGet]
        public StatusResponse RemoveMessage(Int64 mid, Int64 msgid)
        {
            try
            {
                return objmsgm.RemoveMessage(msgid, mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "MessageController", "RemoveMessage - Services");
                return new StatusResponse();
            }
        }

        [Route("api/InsertChatNewMessage")]
        [HttpPost]
        public StatusResponse InsertChatNewMessage(ChatPostMessage cpm)
        {
            try
            {
                StatusResponse st = new StatusResponse();
                string imgname = "";
                string videoname = "";
                if (!string.IsNullOrEmpty(cpm.Pimage))
                {
                    imgname = cpm.frmid.ToString()+"_"+cpm.toids + "_image_" + Guid.NewGuid().ToString() + "." + cpm.imgextension;
                }
                if (!string.IsNullOrEmpty(cpm.Pvideo))
                {
                    videoname = cpm.frmid.ToString() + "_" + cpm.toids + "_video_" + Guid.NewGuid().ToString() + "." + cpm.vidextension;
                }
                st = objmsgm.InsertChatNewMessage(cpm.frmid,cpm.toids.Trim(',').TrimStart(',').TrimEnd(','),cpm.ismultiple,cpm.isgroup,cpm.msg,imgname,videoname);
                if (st.StatusCode > 0)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(cpm.Pimage))
                        {
                            Globalsettings.SaveFile(cpm.Pimage, imgname, "~/content/messages/");
                        }
                        if (!string.IsNullOrEmpty(cpm.Pvideo))
                        {
                            Globalsettings.SaveFile(cpm.Pvideo, videoname, "~/content/messages/");
                        }
                        //foreach (string toid in cpm.toids.Trim(',').TrimEnd(',').TrimStart(',').Split(','))
                        //{
                        //    string[] andevices = objmsgm.GetAndroidDevices(1,Convert.ToInt64(toid)).Split(',');
                        //    var orgdetails = objom.GetOrgById(cpm.orgid);
                        //    string appkey = orgdetails.AndroidPushKey;  // "AIzaSyB1cZ7lABHjcZhkfGiej0kHYQSqMbtMul4";
                        //    Globalsettings.AndroidPushNotifications(andevices, cpm.msg, "New Message", "", appkey);
                        //}
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
                ExceptionUtility.LogException(ex, "InsertChatNewMessage", "GetCustomerGroupMasseges - Services");
                return new StatusResponse();
            }
        }
        [Route("api/ChatReplyMessage")]
        [HttpPost]
        public StatusResponse ChatReplyMessage(ChatPostMessage cpm)
        {
            try
            {
                StatusResponse st = new StatusResponse();
                string imgname = "";
                string videoname = "";
                if (!string.IsNullOrEmpty(cpm.Pimage))
                {
                    imgname = cpm.frmid.ToString() + "_" + cpm.toids + "_image_" + Guid.NewGuid().ToString() + "." + cpm.imgextension;
                }
                if (!string.IsNullOrEmpty(cpm.Pvideo))
                {
                    videoname = cpm.frmid.ToString() + "_" + cpm.toids + "_video_" + Guid.NewGuid().ToString() + "." + cpm.vidextension;
                }
                st = objmsgm.ChatReplyMessage(cpm.frmid, cpm.toid,cpm.chatid,cpm.msg, imgname, videoname);
                if (st.StatusCode > 0)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(cpm.Pimage))
                        {
                            Globalsettings.SaveFile(cpm.Pimage, imgname, "~/content/messages/");
                        }
                        if (!string.IsNullOrEmpty(cpm.Pvideo))
                        {
                            Globalsettings.SaveFile(cpm.Pvideo, videoname, "~/content/messages/");
                        }
                        //foreach (string toid in cpm.toids.Trim(',').TrimEnd(',').TrimStart(',').Split(','))
                        //{
                        //    string[] andevices = objmsgm.GetAndroidDevices(1,Convert.ToInt64(toid)).Split(',');
                        //    var orgdetails = objom.GetOrgById(cpm.orgid);
                        //    string appkey = orgdetails.AndroidPushKey;  // "AIzaSyB1cZ7lABHjcZhkfGiej0kHYQSqMbtMul4";
                        //    Globalsettings.AndroidPushNotifications(andevices, cpm.msg, "New Message", "", appkey);
                        //}
                    }
                    catch (Exception ex)
                    {
                        ExceptionUtility.LogException(ex, "ChatReplyMessage", "Push Notification Error - Services");
                        return st;
                    }
                }
                return st;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "ChatReplyMessage", "GetCustomerGroupMasseges - Services");
                return new StatusResponse();
            }
        }
        [Route("api/GetChatList")]
        [HttpGet]
        public List<ChatList> GetChatList(Int64 mid)
        {
            try
            {
                return objmsgm.GetChatList(mid);
            }
            catch(Exception ex)
            {
                ExceptionUtility.LogException(ex, "Message", "GetChatList - Services");
                return new List<ChatList>();
            }
           
        }
        [Route("api/GetChatMessageByChatId")]
        [HttpGet]
        public List<ChatMessages> GetChatMessageByChatId(Int64 mid, Int64 chatid, Int16 pgindex, Int64 pgsize)
        {
            try
            {
                return objmsgm.GetChatMessageByChatId(mid,chatid,pgindex,pgsize);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Message", "GetChatMessageByChatId - Services");
                return new List<ChatMessages>();
            }
        }
        [Route("api/UpadteChatViewMessage")]
        [HttpGet]
        public StatusResponse UpadteChatViewMessage(Int64 mid, Int64 chatid)
        {
            try
            {
                return objmsgm.UpadteChatViewMessage(mid, chatid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Message", "UpadteChatViewMessage - Services");
                return new StatusResponse();
            }
        }
        [Route("api/GetMemberGroups")]
        [HttpGet]
        public List<CustomerGroupsEntity> GetMemberGroups(Int64 mid)
        {
            try
            {
                return objmsgm.GetMemberGroups(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Message", "GetMemberGroups - Services");
                return new List<CustomerGroupsEntity>();
            }
        }
        [Route("api/GetMembersbygroupId")]
        [HttpGet]
        public List<MemberEntity> GetMembersbygroupId(Int32 gid)
        {
            try
            {
                return objmsgm.GetMembersbygroupId(gid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Message", "GetMembersbygroupId - Services");
                return new List<MemberEntity>();
            }
        }
        [Route("api/CreateMemberGroup")]
        [HttpPost]
        public StatusResponse CreateMemberGroup(CustomerGroupsEntity centity)
        {
            try
            {
                return objmsgm.CreateMemberGroup(centity);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Message", "CreateMemberGroup - Services");
                return new StatusResponse();
            }
        }

    }
}
