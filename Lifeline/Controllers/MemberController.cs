using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using Lifeline.App_Start;
using Lifeline.Entity;
using Lifeline.BAL;
using System.IO;

namespace Lifeline.Controllers
{
    public class MemberController : Controller
    {
        public ActionResult Help(string id="0")
        {
            HelpSeekingMemberProfile ve = new HelpSeekingMemberProfile();
            MemberManager mm = new MemberManager();

            string[] idval =id.IndexOf('@')!=-1?id.Split('@'): id.Split('_');

            long mid = Convert.ToInt64(idval[0]);
            long helpid = Convert.ToInt64(idval[1]);
            //if (Request.Params["id"] != null)
            //{               
                ve = mm.GetHelpSeekingMember(mid);
            //}

            //string strUserAgent = Request.UserAgent.ToString().ToLower();
            //bool MobileDevice = Request.Browser.IsMobileDevice;
            //if (strUserAgent != null)
            //{
            //    if (MobileDevice == true || strUserAgent.Contains("iphone") || strUserAgent.Contains("blackberry") || strUserAgent.Contains("mobile") ||
            //    strUserAgent.Contains("android") || strUserAgent.Contains("windows ce") || strUserAgent.Contains("opera mini") || strUserAgent.Contains("palm"))
            //    {
                   ViewBag.IphoneAppUrl=Settings.IphoneAppUrl;
                   ViewBag.AndroidAppUrl = Settings.AndroidAppUrl;
                   ViewBag.Id = id;
                //}
            //}


            return View(ve);
        }
        [Route("Members")]
        public ActionResult Members()
        {
            return View();
        }
        [Route("AddVolunteer")]
        public ActionResult AddVolunteer()
        {
            Int32 id = 0;
            MemberEntity ce = new MemberEntity();
            MemberManager mm = new MemberManager();
            if (Request.Params["id"] != null)
            {
                id = Convert.ToInt32(Request.Params["id"]);
                ce = mm.GetMemberProfile(id);
            }
            ViewBag.id = id;
            return View(ce);
        }
        [HttpPost]
        [Route("AddUpdateVolunteer")]
        public ActionResult AddUpdateVolunteer(HttpPostedFileBase Image, MemberEntity cEntity)
        {
            StatusResponse st = new StatusResponse();
            AdminManager mm = new AdminManager();
            if (Image != null && Image.ContentLength > 0)
            {
                cEntity.ProfilePic = Guid.NewGuid().ToString() + Path.GetExtension(Image.FileName).ToLower();
            }
            st = mm.AdminAddCoordinator(cEntity);
            if (st.StatusCode > 0 && Image != null && Image.ContentLength > 0)
            {
                string filename = cEntity.ProfilePic.ToString();
                DirectoryInfo dir = new DirectoryInfo(HttpContext.Server.MapPath("~/content/customers/" + st.StatusCode.ToString() + "/"));
                string folder = Server.MapPath("~/content/customers/" + st.StatusCode.ToString() + "/");
                if (!dir.Exists)
                {
                    dir.Create();
                }
                Image.SaveAs(folder + filename);
            }

            return RedirectToAction("Members");
        }
	}
}