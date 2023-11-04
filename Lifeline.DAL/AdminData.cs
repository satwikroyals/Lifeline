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

namespace Lifeline.DAL
{
    public class AdminData
    {
        public AdminEntity CheckAdminLogin(string un, string pwd)
        {
            DapperRepositry<AdminEntity> _repo = new DapperRepositry<AdminEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@UserName", un, DbType.String, ParameterDirection.Input);
            param.Add("@Password", pwd, DbType.String, ParameterDirection.Input);
            return _repo.GetResult("CheckAdminLogin", param);
        }
        public StatusResponse AdminAddCoordinator(MemberEntity cEntity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", cEntity.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@CoordinatorId", cEntity.CoordinatorId, DbType.Int32, ParameterDirection.Input);
            param.Add("@FirstName", cEntity.FirstName, DbType.String, ParameterDirection.Input);
            param.Add("@LastName", cEntity.LastName, DbType.String, ParameterDirection.Input);
            param.Add("@UserId", cEntity.UserId, DbType.String, ParameterDirection.Input);
            param.Add("@Pin", cEntity.Pin, DbType.String, ParameterDirection.Input);
            param.Add("@LocationId", cEntity.LocationId, DbType.Int64, ParameterDirection.Input);
            param.Add("@CountryId", cEntity.CountryId, DbType.Int16, ParameterDirection.Input);
            param.Add("@StateId", cEntity.StateId, DbType.Int32, ParameterDirection.Input);
            param.Add("@CommunityBelong", cEntity.CommunityBelong, DbType.String, ParameterDirection.Input);
            param.Add("@Gender", cEntity.Gender, DbType.Int16, ParameterDirection.Input);
            param.Add("@ReferredById", cEntity.ReferredById, DbType.Int32, ParameterDirection.Input);
            param.Add("@GeoAddress", cEntity.GeoAddress, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", cEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", cEntity.Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@MemberInfo", cEntity.MemberInfo, DbType.String, ParameterDirection.Input);
            param.Add("@EmailId", cEntity.EmailId, DbType.String, ParameterDirection.Input);
            param.Add("@Mobile", cEntity.Mobile, DbType.String, ParameterDirection.Input);
            param.Add("@PostCode", cEntity.PostCode, DbType.String, ParameterDirection.Input);
            param.Add("@ProfilePic", cEntity.ProfilePic, DbType.String, ParameterDirection.Input);
            param.Add("@IsCoordinator", cEntity.IsCoordinator, DbType.Int16, ParameterDirection.Input);
            param.Add("@Status", cEntity.Status, DbType.Int16, ParameterDirection.Input);
            param.Add("@OrganisationName", cEntity.OrganisationName, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AdminAddCoordinator", param);
        }
        public List<MemberEntity> GetCoordinatorsList(paggingEntity es,Int32 lid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@LocationId", lid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetAdminCoordinatorList", param);
        }
        public List<MemberEntity> GetAdminMembers(paggingEntity es, Int32 lid,int volunteer)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@PageSize", es.pgsize, DbType.Int16, ParameterDirection.Input);
            param.Add("@PageIndex", es.pgindex, DbType.Int16, ParameterDirection.Input);
            param.Add("@Searchstr", es.str, DbType.String, ParameterDirection.Input);
            param.Add("@SortBy", es.sortby, DbType.Int16, ParameterDirection.Input);
            param.Add("@LocationId", lid, DbType.Int32, ParameterDirection.Input);
            param.Add("@Volunteer", volunteer, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetAdminMembersList", param);
        }
    }
}
