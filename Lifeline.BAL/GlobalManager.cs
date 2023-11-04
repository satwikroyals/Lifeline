using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.Entity;
using Lifeline.DAL;

namespace Lifeline.BAL
{
    public class GlobalManager
    {
        GlobalData objgd = new GlobalData();
        public List<CountryEntity> GetDdlCountry()
        {
            return objgd.GetDdlCountry();
        }
        public List<LocationEntity> GetDdlLocation(Int64 TownId)
        {
            return objgd.GetDdlLocation(TownId);
        }
        public List<MemberddlEntity> GetDdlMembers()
        {
            return objgd.GetDdlMembers();
        }
        public List<Campaignddl> GetCampaignddl(Int32 mid)
        {
            return objgd.GetCampaignddl(mid);
        }
        public List<Stateddl> GetStateddl(Int32 cid)
        {
            return objgd.GetStateddl(cid);
        }
        public List<Regionddl> GetRegionddl(Int64 sid)
        {
            return objgd.GetRegionddl(sid);
        }
        public List<Townddl> GetTownddl(Int64 rid)
        {
            return objgd.GetTownddl(rid);
        }
        public List<LocationEntity> GetAdminDdlLocation(Int64 tid, Int64 mid)
        {
            return objgd.GetAdminDdlLocation(tid,mid);
        }
        public StatusResponse AddState(Int32 countryid,string State)
        {
            return objgd.AddState(countryid, State);
        }
        public StatusResponse AddRegion(Int64 stateid, string region)
        {
            return objgd.AddRegion(stateid, region);
        }
        public StatusResponse AddTown(Int64 regionid, string town)
        {
            return objgd.AddTown(regionid, town);
        }
        public StatusResponse AddLocation(Int64 townid, string location, decimal lat, decimal lang)
        {
            return objgd.AddLocation(townid, location, lat, lang);
        }
        public List<DdlEntity> GetDdlCoordinators(int st)
        {
            return objgd.GetDdlCoordinators(st);
        }
    }
}
