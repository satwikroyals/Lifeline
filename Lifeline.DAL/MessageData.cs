using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Dapper;
using DbFactory.Repositories;
using Lifeline.Entity;
using DbFactory;
using System.Data;

namespace Lifeline.DAL
{
    public class MessageData 
    {
        public List<MemberEntity> GetAllMembers(Int64 mid,string search)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            param.Add("@Search", search, DbType.String, ParameterDirection.Input);

            return _repo.GetList("GetAllMembers", param);
        }
        public List<MemberEntity> GetMemberFriends(Int64 mid, int status, string srchname)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();

            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            param.Add("@Status", status, DbType.Int16, ParameterDirection.Input);

            param.Add("@SearchName", srchname, DbType.String, ParameterDirection.Input);
            return _repo.GetList("GetMemberFriends", param);
        }
        public Int32 AddOrRemoveFriend(Int64 mid, Int64 frid, int action)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();

            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            param.Add("@MemberFriendId", frid, DbType.Int64, ParameterDirection.Input);

            param.Add("@Action", action, DbType.Int16, ParameterDirection.Input);
            param.Add("@Res", 0, DbType.Int32, ParameterDirection.Output);
            return _repo.Add<Int32>("AddRemoveMemberFriend", param);
        }
        public List<MessagePostEntity> GetMemberGroupMessages(paggingEntity es,Int32 mid,Int32 gid)
        {
            DapperRepositry<MessagePostEntity> _repo = new DapperRepositry<MessagePostEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@GroupId", gid, DbType.Int32, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetMemberGroupMessageList", param);
        }
        public List<MessagePostEntity> GetMemberWallPostMessages(paggingEntity es, Int32 mid)
        {
            DapperRepositry<MessagePostEntity> _repo = new DapperRepositry<MessagePostEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetMemberWallPostMessageList", param);
        }


        public StatusResponse PostMessage(Int32 groupid, Int32 mid, string msg, string pimage, string pvideo)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@GroupId", groupid, DbType.Int32, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            param.Add("@Message", msg, DbType.String, ParameterDirection.Input);
            param.Add("@PostImage", pimage, DbType.String, ParameterDirection.Input);
            param.Add("@PostVideo", pvideo, DbType.String, ParameterDirection.Input);
            return _repo.GetResult("PostMessage", param);
        }
        
        /// <summary>
        /// Remove message by committee member
        /// </summary>
        /// <param name="orgid">orgid</param>
        /// <param name="msgid">msgid</param>
        /// <param name="cid">cid</param>
        /// <returns></returns>
        public StatusResponse RemoveMessage(Int64 msgid,Int64 mid)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();

            param.Add("@GMSGId", msgid, DbType.Int64, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetResult("RemoveMessage", param);
        }
        public StatusResponse InsertChatNewMessage(Int64 fromcid,string tocids,int ismultiple,int isgroup,string msg,string pimage,string pvideo)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@FromCId", fromcid, DbType.Int64, ParameterDirection.Input);
            param.Add("@ToCids", tocids.TrimEnd(',').TrimStart(','), DbType.String, ParameterDirection.Input);
            param.Add("@IsMultiple", ismultiple, DbType.Int16, ParameterDirection.Input);
            param.Add("@IsGroup", isgroup, DbType.Int16, ParameterDirection.Input);
            param.Add("@MessageText", msg, DbType.String, ParameterDirection.Input);
            param.Add("@Image", pimage, DbType.String, ParameterDirection.Input);
            param.Add("@Video", pvideo, DbType.String, ParameterDirection.Input);
            return _repo.GetResult("InsertChatNewMessages", param);
        }
        public StatusResponse ChatReplyMessage(Int64 frmid,Int64 toid,Int64 chatid,string msg,string pimage,string pvideo)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@FromId", frmid, DbType.Int64, ParameterDirection.Input);
            param.Add("@ToId", toid, DbType.Int64, ParameterDirection.Input);
            param.Add("@MessageText", msg, DbType.String, ParameterDirection.Input);
            param.Add("@Image", pimage, DbType.String, ParameterDirection.Input);
            param.Add("@Video", pvideo, DbType.String, ParameterDirection.Input);
            param.Add("@ChatId", chatid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetResult("ChatreplyMessage", param);
        }
        public List<ChatList> GetChatList(Int64 mid)
        {
            DapperRepositry<ChatList> _repo = new DapperRepositry<ChatList>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetList("GetChatFriendsList", param);
        }
        public List<ChatMessages> GetChatMessageByChatId(Int64 mid,Int64 chatid,Int16 pgindex,Int64 pgsize)
        {
            DapperRepositry<ChatMessages> _repo = new DapperRepositry<ChatMessages>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            param.Add("@ChatId", chatid, DbType.Int64, ParameterDirection.Input);
            param.Add("@PageIndex", pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageSize", pgsize, DbType.Int16, ParameterDirection.Input);
            return _repo.GetList("GetChatMessagesByChatId", param);
        }
        public StatusResponse UpadteChatViewMessage(Int64 mid,Int64 chatid)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            param.Add("@ChatId", chatid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetResult("UpdateChatView", param);
        }
        public List<CustomerGroupsEntity> GetMemberGroups(Int64 mid)
        {
            DapperRepositry<CustomerGroupsEntity> _repo = new DapperRepositry<CustomerGroupsEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetList("GetMemberChatGroups", param);
        }
        public List<MemberEntity> GetMembersbygroupId(Int32 gid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@GroupId", gid, DbType.Int32, ParameterDirection.Input);

            return _repo.GetList("GetMembersByGroupId", param);
        }
        public StatusResponse CreateMemberGroup(CustomerGroupsEntity centity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", centity.MemberId, DbType.Int64, ParameterDirection.Input);
            param.Add("@GroupName", centity.GroupName, DbType.Int64, ParameterDirection.Input);
            param.Add("@GroupMembers", centity.GroupMembers, DbType.Int64, ParameterDirection.Input);
            return _repo.GetResult("CreateMemberGroup", param);
        }
    }
}
