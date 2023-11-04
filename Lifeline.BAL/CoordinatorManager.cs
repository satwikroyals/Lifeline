using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.Entity;
using Lifeline.DAL;

namespace Lifeline.BAL
{
    public class CoordinatorManager
    {
        CoordinatorData objcd = new CoordinatorData();
        public MemberEntity CheckCoordinatorLogin(string un, string pwd)
        {
            return objcd.CheckCoordinatorLogin(un, pwd);
        }
        public List<CampaignEntity> GetAdminCampaigns(paggingEntity es, Int32 mid)
        {
            return objcd.GetAdminCampaigns(es, mid);
        }
        public StatusResponse AddCoordinatorCampaign(CampaignEntity cEntity)
        {
            return objcd.AddCoordinatorCampaign(cEntity);
        }
        public CampaignEntity GetCampaignById(Int32 cid)
        {
            return objcd.GetCampaignById(cid);
        }
        public List<HelpSeekingMemberProfile> GetRescuesList(paggingEntity es, Int32 mid)
        {
            return objcd.GetRescuesList(es, mid);
        }
        public List<MemberEntity> GetAllMemberIds(Int32 bid)
        {
            return objcd.GetAllMemberIds(bid);
        }
        public List<CampaignMemberEntity> GetCampaignSignedMembers(paggingEntity es, Int32 cmid)
        {
            return objcd.GetCampaignSignedMembers(es, cmid);
        }
    }
}
