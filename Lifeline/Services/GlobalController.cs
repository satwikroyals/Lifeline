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
    public class GlobalController : ApiController
    {
        GlobalManager objgm = new GlobalManager();
        [Route("api/GetDdlCountry")]
        [HttpGet]
        public List<CountryEntity> GetDdlCountry()
        {
            try
            {
                return objgm.GetDdlCountry();
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetDdlCountry-Services");
                return new List<CountryEntity>();
            }
        }
        [Route("api/GetDdlLocation")]
        [HttpGet]
        public List<LocationEntity> GetDdlLocation(Int64 TownId)
        {
            try
            {
                return objgm.GetDdlLocation(TownId);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetDdlLocation-Services");
                return new List<LocationEntity>();
            }
        }
        [Route("api/GetDdlMembers")]
        [HttpGet]
        public List<MemberddlEntity> GetDdlMembers()
        {
            try
            {
                return objgm.GetDdlMembers();
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetDdlMembers-Services");
                return new List<MemberddlEntity>();
            }
        }
        [Route("api/GetCampaignddl")]
        [HttpGet]
        public List<Campaignddl> GetCampaignddl(Int32 mid)
        {
            try
            {
                return objgm.GetCampaignddl(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetCampaignddl-Services");
                return new List<Campaignddl>();
            }
        }
        [Route("api/GetStateddl")]
        [HttpGet]
        public List<Stateddl> GetStateddl(Int32 cid)
        {
            try
            {
                return objgm.GetStateddl(cid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetStateddl-Services");
                return new List<Stateddl>();
            }
        }
        [Route("api/GetRegionddl")]
        [HttpGet]
        public List<Regionddl> GetRegionddl(Int64 sid)
        {
            try
            {
                return objgm.GetRegionddl(sid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetRegionddl-Services");
                return new List<Regionddl>();
            }
        }
        [Route("api/GetTownddl")]
        [HttpGet]
        public List<Townddl> GetTownddl(Int64 rid)
        {
            try
            {
                return objgm.GetTownddl(rid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetTownddl-Services");
                return new List<Townddl>();
            }
        }
        [Route("api/GetAdminDdlLocation")]
        [HttpGet]
        public List<LocationEntity> GetAdminDdlLocation(Int64 tid, Int64 mid)
        {
            try
            {
                return objgm.GetAdminDdlLocation(tid,mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "GetAdminDdlLocation-Services");
                return new List<LocationEntity>();
            }
        }
        [Route("api/AddState")]
        [HttpGet]
        public StatusResponse AddState(Int32 countryid, string State)
        {
            try
            {
                return objgm.AddState(countryid, State);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "AddState-Services");
                return new StatusResponse();
            }
        }
        [Route("api/AddRegion")]
        [HttpGet]
        public StatusResponse AddRegion(Int64 stateid, string region)
        {
            try
            {
                return objgm.AddRegion(stateid, region);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "AddRegion-Services");
                return new StatusResponse();
            }
        }
        [Route("api/AddTown")]
        [HttpGet]
        public StatusResponse AddTown(Int64 regionid, string town)
        {
            try
            {
                return objgm.AddTown(regionid, town);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "AddTown-Services");
                return new StatusResponse();
            }
        }
        [Route("api/AddLocation")]
        [HttpGet]
        public StatusResponse AddLocation(Int64 townid, string location,decimal lat,decimal lang)
        {
            try
            {
                string town = location.Split(',')[0];
                return objgm.AddLocation(townid, town, lat, lang);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Global", "AddLocation-Services");
                return new StatusResponse();
            }
        }

        [Route("api/GetDdlCoordinators")]
        [HttpGet]
        public List<DdlEntity> GetDdlCoordinators(int st=1)
        {
            try
            {
                return objgm.GetDdlCoordinators(st);
            }
            catch (Exception ex)
            {
                return new List<DdlEntity>();
            }
        }
    }
}
