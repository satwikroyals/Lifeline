using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Lifeline.Entity;
using Lifeline.BAL;
using System.IO;

namespace Lifeline.Controllers
{
    public class ResourceController : Controller
    {
        ResourceManager objrm = new ResourceManager();
        public ActionResult Resources()
        {
            return View();
        }
        public ActionResult AddResourceDoc()
        {
            Int32 id = 0;
            ResourceEntity bd = new ResourceEntity();
            if (Request.Params["id"] != null)
            {
                id = Convert.ToInt32(Request.Params["id"]);
                bd = objrm.GetResourceDocumentById(id);
            }
            return View(bd);
        }
        [HttpPost]
        public ActionResult AddDocument(HttpPostedFileBase doc, ResourceEntity bentity)
        {
            StatusResponse st = new StatusResponse();
            if (doc != null && doc.ContentLength > 0)
            {
                bentity.ResourceDoc = Guid.NewGuid().ToString() + Path.GetExtension(doc.FileName).ToLower();
            }
            st = objrm.AddResourceDocuments(bentity);
            if (st.StatusCode > 0 && doc != null && doc.ContentLength > 0)
            {
                string filename = bentity.ResourceDoc.ToString();
                DirectoryInfo dir = new DirectoryInfo(HttpContext.Server.MapPath("~/content/Resource/" + st.StatusCode.ToString() + "/"));
                string folder = Server.MapPath("~/content/Resource/" + st.StatusCode.ToString() + "/");
                if (!dir.Exists)
                {
                    dir.Create();
                }
                doc.SaveAs(folder + filename);
            }
            return RedirectToAction("Resources");
        }
	}
}