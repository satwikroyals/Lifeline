using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using Lifeline.App_Start;
using Lifeline.Entity;
using Lifeline.BAL;
using System.IO;


namespace Lifeline.Areas.Coordinator.Controllers
{
    public class MemberController : Controller
    {
        public ActionResult Members()
        {
            return View();
        }
        public ActionResult AddMember()
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
        public ActionResult AddUpdateVolunteer(HttpPostedFileBase Image, MemberEntity cEntity)
        {
            StatusResponse st = new StatusResponse();
            AdminManager mm = new AdminManager();
            if (Image != null && Image.ContentLength > 0)
            {
                cEntity.ProfilePic = Guid.NewGuid().ToString() + Path.GetExtension(Image.FileName).ToLower();
            }
            cEntity.Mobile = cEntity.Mobile[0] == '0' ? cEntity.Mobile.Substring(1) : cEntity.Mobile;
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
            if (st.StatusCode > 0)
            {
                string body = "";
                body += "<html><body>";
                body += "<p>Please find the login  Credentials for your Lifeline app:</p>";
                body += "<p>Username:" + cEntity.UserId + "</p>";
                body += "<p>Pin:" + cEntity.Pin + "</p>";
                sendmail send = new sendmail();
                send.SendEmail(cEntity.EmailId, "Credentials", "", body, "no-replay@Lifeline.com", "Lifeline");
            }
            return RedirectToAction("Members");
        }
	}
}