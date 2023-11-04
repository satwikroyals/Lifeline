using Lifeline.BAL;
using Lifeline.Entity;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lifeline.Controllers
{
    public class PublicController : Controller
    {
        // GET: Public
        [Route("RegisterCoordinator")]
        public ActionResult RegisterCoordinator()
        {
            MemberEntity ce = new MemberEntity();
            ViewBag.RegSuc = TempData["RegSuc"];
            return View(ce);
        }

        [HttpPost]
        public ActionResult AddUpdateCoordinator(HttpPostedFileBase Image, MemberEntity cEntity)
        {
            AdminManager cusm = new AdminManager();
            StatusResponse st = new StatusResponse();
            if (Image != null && Image.ContentLength > 0)
            {
                cEntity.ProfilePic = Guid.NewGuid().ToString() + Path.GetExtension(Image.FileName).ToLower();
            }
            cEntity.Mobile = cEntity.Mobile[0] == '0' ? cEntity.Mobile.Substring(1) : cEntity.Mobile;
            st = cusm.AdminAddCoordinator(cEntity);
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
            TempData["RegSuc"] = "Registration completed successfully.";
            return RedirectToAction("RegisterCoordinator","Public");
        }
    }
}