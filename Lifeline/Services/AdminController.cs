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
    public class AdminController : ApiController
    {
        AdminManager am = new AdminManager();
        [Route("api/GetAdminMembers")]
        [HttpGet]
        public List<MemberEntity> GetAdminMembers(Int32 lid,int volunteer,[FromUri]paggingEntity es)
        {
            try
            {
                return am.GetAdminMembers(es, lid, volunteer);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Admin", "GetAdminMembers-Services");
                return new List<MemberEntity>();
            }
        }
    }
}
