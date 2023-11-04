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
    public class CoordinatorData
    {
        public MemberEntity CheckCoordinatorLogin(string un, string pwd)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@UserName", un, DbType.String, ParameterDirection.Input);
            param.Add("@Password", pwd, DbType.String, ParameterDirection.Input);
            return _repo.GetResult("CheckCoordinatorLogin", param);
        }
        public List<CampaignEntity> GetAdminCampaigns(paggingEntity es, Int32 mid)
        {
            DapperRepositry<CampaignEntity> _repo = new DapperRepositry<CampaignEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetAdminCampaignList", param);
        }
        public StatusResponse AddCoordinatorCampaign(CampaignEntity cEntity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CampaignId", cEntity.CampaignId, DbType.Int32, ParameterDirection.Input);
            param.Add("@MemberId", cEntity.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@CampaignTitle", cEntity.CampaignTitle, DbType.String, ParameterDirection.Input);
            param.Add("@Image", cEntity.Image, DbType.String, ParameterDirection.Input);
            param.Add("@LocationId", cEntity.LocationId, DbType.Int16, ParameterDirection.Input);
            param.Add("@StartTime", cEntity.StartTime, DbType.DateTime, ParameterDirection.Input);
            param.Add("@EndTime", cEntity.EndTime, DbType.DateTime, ParameterDirection.Input);
            param.Add("@GeoLocation", cEntity.GeoLocation, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", cEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", cEntity.Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@CampaignInfo", cEntity.CampaignInfo, DbType.String, ParameterDirection.Input);
            param.Add("@SpecialInstructions", cEntity.SpecialInstructions, DbType.String, ParameterDirection.Input);
            param.Add("@ToCids", cEntity.ToIds, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AddCoordinatorCampaign", param);
        }
        public CampaignEntity GetCampaignById(Int32 cid)
        {
            DapperRepositry<CampaignEntity> _repo = new DapperRepositry<CampaignEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CampaignId", cid, DbType.Int32, ParameterDirection.Input);

            return _repo.GetResult("GetCampaignById", param);
        }
        public List<HelpSeekingMemberProfile> GetRescuesList(paggingEntity es, Int32 mid)
        {
            DapperRepositry<HelpSeekingMemberProfile> _repo = new DapperRepositry<HelpSeekingMemberProfile>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetCoordinatorHelpList", param);
        }
        public List<MemberEntity> GetAllMemberIds(Int32 bid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();

            param.Add("@MemberId", bid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetAllCustomerIds", param);
        }
        public List<CampaignMemberEntity> GetCampaignSignedMembers(paggingEntity es, Int32 cmid)
        {
            DapperRepositry<CampaignMemberEntity> _repo = new DapperRepositry<CampaignMemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@CampaignId", cmid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetCampaignSignedMembersList", param);
        }
    }
}
