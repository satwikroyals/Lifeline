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
    public class CampaignController : Controller
    {
        public ActionResult Campaigns()
        {
            return View();
        }
        public ActionResult AddCampaign()
        {
            Int32 id = 0;
            CampaignEntity ce = new CampaignEntity();
            CoordinatorManager mm = new CoordinatorManager();
            if (Request.Params["id"] != null)
            {
                id = Convert.ToInt32(Request.Params["id"]);
                ce = mm.GetCampaignById(id);
            }
            ViewBag.id = id;
            return View(ce);
        }
        [HttpPost]
        public ActionResult AddCampaign(HttpPostedFileBase Imagefile, CampaignEntity cEntity)
        {
            StatusResponse st = new StatusResponse();
            CoordinatorManager mm = new CoordinatorManager();
            if (Imagefile != null && Imagefile.ContentLength > 0)
            {
                cEntity.Image = Guid.NewGuid().ToString() + Path.GetExtension(Imagefile.FileName).ToLower();
            }
            st = mm.AddCoordinatorCampaign(cEntity);
            if (st.StatusCode > 0 && Imagefile != null && Imagefile.ContentLength > 0)
            {
                string filename = cEntity.Image.ToString();
                DirectoryInfo dir = new DirectoryInfo(HttpContext.Server.MapPath("~/content/Campaigns/" + st.StatusCode.ToString() + "/"));
                string folder = Server.MapPath("~/content/Campaigns/" + st.StatusCode.ToString() + "/");
                if (!dir.Exists)
                {
                    dir.Create();
                }
                Imagefile.SaveAs(folder + filename);
            }

            return RedirectToAction("Campaigns");
        }
        public ActionResult CampaignMembers()
        {
            return View();
        }
	}
}