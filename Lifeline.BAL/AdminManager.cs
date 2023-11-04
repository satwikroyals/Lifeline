using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.Entity;
using Lifeline.DAL;

namespace Lifeline.BAL
{
    public class AdminManager
    {
        AdminData ad = new AdminData();
        public AdminEntity CheckAdminLogin(string un, string pwd)
        {
            return ad.CheckAdminLogin(un, pwd);
        }
        public StatusResponse AdminAddCoordinator(MemberEntity cEntity)
        {
            return ad.AdminAddCoordinator(cEntity);
        }
        public List<MemberEntity> GetCoordinatorsList(paggingEntity es,Int32 lid)
        {
            return ad.GetCoordinatorsList(es, lid);
        }
        public List<MemberEntity> GetAdminMembers(paggingEntity es, Int32 lid,int volunteer)
        {
            return ad.GetAdminMembers(es, lid, volunteer);
        }
    }
}
