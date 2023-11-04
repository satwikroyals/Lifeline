using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using DbFactory.Repositories;
using Lifeline.Entity;
using DbFactory;
using System.Data;
using System.Data.SqlClient;

namespace Lifeline.DAL
{
    public class NotificationData
    {
        public List<NotificationEntity> GetNotificationList(Int64 mid)
        {
            DapperRepositry<NotificationEntity> _repo = new DapperRepositry<NotificationEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("GetMemberNotifications", param);
        }
        public StatusResponse UpdateNotificationView(Int64 id)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Id", id, DbType.Int64, ParameterDirection.Input);
            return _repo.GetResult("UpdateNotificationCustomerView", param);
        }
        public StatusResponse InsertNotificationResponse(Int64 id,string res)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Id", id, DbType.Int64, ParameterDirection.Input);
            param.Add("@Response", res, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("InsertMemberNotificationResponse", param);
        }
        public List<NotificationEntity> GetCoordinatorNotificationList(paggingEntity es, Int64 coid, Int64 aid)
        {
            DapperRepositry<NotificationEntity> _repo = new DapperRepositry<NotificationEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@CoordinatorId", coid, DbType.Int64, ParameterDirection.Input);
            param.Add("@AdminId", aid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("AdminGetNotifications", param);
        }
        public StatusResponse AddNotification(NotificationEntity nEntity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@NotificationId", nEntity.NotificationId, DbType.Int64, ParameterDirection.Input);
            param.Add("@CoordinatorId", nEntity.CoordinatorId, DbType.Int64, ParameterDirection.Input);
            param.Add("@Title", nEntity.Title, DbType.String, ParameterDirection.Input);
            param.Add("@Message", nEntity.Message, DbType.String, ParameterDirection.Input);
            param.Add("@IsActive", nEntity.IsActive, DbType.Int16, ParameterDirection.Input);
            param.Add("@ToCids", nEntity.ToCids, DbType.String, ParameterDirection.Input);
            return _repo.GetResult("InsertNotification", param);
        }
    }
}
