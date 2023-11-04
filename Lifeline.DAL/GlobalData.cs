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
    public class GlobalData
    {
        public List<CountryEntity> GetDdlCountry()
        {
            DapperRepositry<CountryEntity> _repo = new DapperRepositry<CountryEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();

            return _repo.GetList("GetddlCountries", param);
        }
        public List<Stateddl> GetStateddl(Int32 cid)
        {
            DapperRepositry<Stateddl> _repo = new DapperRepositry<Stateddl>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CountryId", cid, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetStateddl", param);
        }
        public List<Regionddl> GetRegionddl(Int64 sid)
        {
            DapperRepositry<Regionddl> _repo = new DapperRepositry<Regionddl>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@StateId", sid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("GetRegionddl", param);
        }
        public List<Townddl> GetTownddl(Int64 rid)
        {
            DapperRepositry<Townddl> _repo = new DapperRepositry<Townddl>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@RegionId", rid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("GetTownddl", param);
        }
        public List<LocationEntity> GetAdminDdlLocation(Int64 tid,Int64 mid)
        {
            DapperRepositry<LocationEntity> _repo = new DapperRepositry<LocationEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@TownId", tid, DbType.Int64, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("GetAdminddlLocations", param);
        }
        public List<LocationEntity> GetDdlLocation(Int64 TownId)
        {
            DapperRepositry<LocationEntity> _repo = new DapperRepositry<LocationEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@TownId", TownId, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("GetddlLocations", param);
        }
        public List<MemberddlEntity> GetDdlMembers()
        {
            DapperRepositry<MemberddlEntity> _repo = new DapperRepositry<MemberddlEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();

            return _repo.GetList("GetddlMembers", param);
        }
        public List<Campaignddl> GetCampaignddl(Int32 mid)
        {
            DapperRepositry<Campaignddl> _repo = new DapperRepositry<Campaignddl>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CoordinatorId", mid, DbType.Int32, ParameterDirection.Input);

            return _repo.GetList("GetCampaignddl", param);
        }
        public StatusResponse AddState(Int32 countryid,string State)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CountryId", countryid, DbType.Int32, ParameterDirection.Input);
            param.Add("@StateName", State, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AddState", param);
        }
        public StatusResponse AddRegion(Int64 stateid, string region)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@StateId", stateid, DbType.Int64, ParameterDirection.Input);
            param.Add("@Region", region, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AddRegion", param);
        }
        public StatusResponse AddTown(Int64 regionid, string town)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@RegionId", regionid, DbType.Int64, ParameterDirection.Input);
            param.Add("@Town", town, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AddTown", param);
        }
        public StatusResponse AddLocation(Int64 townid, string location, decimal lat, decimal lang)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@TownId", townid, DbType.Int64, ParameterDirection.Input);
            param.Add("@Location", location, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", lat, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", lang, DbType.Decimal, ParameterDirection.Input);

            return _repo.GetResult("AddLocation", param);
        }

        public List<DdlEntity> GetDdlCoordinators(int st)
        {
            DapperRepositry<DdlEntity> _repo = new DapperRepositry<DdlEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Status", st, DbType.Int32, ParameterDirection.Input);
            return _repo.GetList("GetDdlCoordinators", param);
        }
    }
}
