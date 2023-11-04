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
    public class CoordinatorController : ApiController
    {
        CoordinatorManager objcm = new CoordinatorManager();
        [Route("api/GetAdminCampaigns")]
        [HttpGet]
        public List<CampaignEntity> GetAdminCampaigns(Int32 mid,[FromUri]paggingEntity es)
        {
            try
            {
                return objcm.GetAdminCampaigns(es, mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Coordinator", "GetAdminCampaigns-Services");
                return new List<CampaignEntity>();
            }
        }
        [Route("api/GetRescuesList")]
        [HttpGet]
        public List<HelpSeekingMemberProfile> GetRescuesList(Int32 mid,[FromUri]paggingEntity es)
        {
            try
            {
                return objcm.GetRescuesList(es, mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Coordinator", "GetRescuesList-Services");
                return new List<HelpSeekingMemberProfile>();
            }
        }
        [Route("api/GetAllMemberIds")]
        [HttpGet]
        public List<MemberEntity> GetAllMemberIds(Int32 bid)
        {
            return objcm.GetAllMemberIds(bid);
        }
        [Route("api/GetCampaignSignedMembers")]
        [HttpGet]
        public List<CampaignMemberEntity> GetCampaignSignedMembers(Int32 cmid,[FromUri]paggingEntity es)
        {
            try
            {
                return objcm.GetCampaignSignedMembers(es, cmid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Coordinator", "GetCampaignSignedMembers-Services");
                return new List<CampaignMemberEntity>();
            }
        }
    }
}
