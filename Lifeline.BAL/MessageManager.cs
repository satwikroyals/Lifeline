using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.DAL;
using Lifeline.Entity;

namespace Lifeline.BAL
{
    public class MessageManager
    {
        private MessageData objmsdata = new MessageData();
        public List<MemberEntity> GetAllMembers(Int64 mid,string search)
        {
            return objmsdata.GetAllMembers(mid, search);
        }
        public List<MemberEntity> GetMemberFriends(Int64 mid, int status, string srchname)
        {
            return objmsdata.GetMemberFriends(mid, status, srchname);
        }
        public Int32 AddOrRemoveFriend(Int64 mid, Int64 frid, int action)
        {
            return objmsdata.AddOrRemoveFriend(mid, frid, action);
        }
        public List<MessagePostEntity> GetMemberGroupMessages(paggingEntity es, Int32 mid, Int32 gid)
        {
            return objmsdata.GetMemberGroupMessages(es, mid, gid);
        }

        public StatusResponse PostMessage(Int32 groupid, Int32 mid, string msg, string pimage, string pvideo)
        {
            return objmsdata.PostMessage(groupid, mid, msg, pimage, pvideo);
        }
        public List<MessagePostEntity> GetMemberWallPostMessages(paggingEntity es, Int32 mid)
        {
            return objmsdata.GetMemberWallPostMessages(es, mid);
        }
       
        //public string GetAndroidDevices(Int32 orgid,Int64 cid)
        //{
        //    List<MemberEntity> clist = new List<MemberEntity>();
          
        //    string andevices = "";
        //    foreach(var cs in clist)
        //    {
        //        if(!string.IsNullOrEmpty(cs.AndroidDevices))
        //        {
        //            andevices += cs.AndroidDevices + ",";
        //        }
        //    }
        //    return andevices;
        //}
        public StatusResponse RemoveMessage(Int64 msgid, Int64 mid)
        {
            return objmsdata.RemoveMessage(msgid, mid);
        }

        public StatusResponse InsertChatNewMessage(Int64 fromcid, string tocids, int ismultiple, int isgroup, string msg, string pimage, string pvideo)
        {
            return objmsdata.InsertChatNewMessage(fromcid, tocids, ismultiple, isgroup, msg, pimage, pvideo);
        }
        public StatusResponse ChatReplyMessage(Int64 frmid, Int64 toid, Int64 chatid, string msg, string pimage, string pvideo)
        {
            return objmsdata.ChatReplyMessage(frmid, toid, chatid, msg, pimage, pvideo);
        }
        public List<ChatList> GetChatList(Int64 mid)
        {
            return objmsdata.GetChatList(mid);
        }
        public List<ChatMessages> GetChatMessageByChatId(Int64 mid, Int64 chatid, Int16 pgindex, Int64 pgsize)
        {
            return objmsdata.GetChatMessageByChatId(mid, chatid, pgindex, pgsize);
        }
        public StatusResponse UpadteChatViewMessage(Int64 mid, Int64 chatid)
        {
            return objmsdata.UpadteChatViewMessage(mid, chatid);
        }
        public List<CustomerGroupsEntity> GetMemberGroups(Int64 mid)
        {
            return objmsdata.GetMemberGroups(mid);
        }
        public List<MemberEntity> GetMembersbygroupId(Int32 gid)
        {
            return objmsdata.GetMembersbygroupId(gid);
        }
        public StatusResponse CreateMemberGroup(CustomerGroupsEntity centity)
        {
            return objmsdata.CreateMemberGroup(centity);
        }
    
    }
}
