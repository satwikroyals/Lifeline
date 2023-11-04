using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Lifeline.BAL;
using Lifeline.Code;
using Lifeline.Entity;
using System.Drawing;
using System.Drawing.Imaging;

namespace Lifeline.Areas.Coordinator.Controllers
{
    public class NotificationController : Controller
    {
        public ActionResult ViewNotifications()
        {
            return View();
        }
        public ActionResult CreateNotification()
        {
            NotificationEntity ne = new NotificationEntity();
            return View(ne);
        }
        [HttpPost]
        //[ValidateAntiForgeryToken()]
        public ActionResult Add(NotificationEntity p, string[] CustomerId)
        {
            string Cid = "";
            if (CustomerId != null)
            {
                foreach (string Customer in CustomerId)
                {
                    Cid += Customer + ",";
                }
            }
            p.ToCids = Cid;

            NotificationManager bal = new NotificationManager();
            var res = bal.AddNotification(p);
            //}
            return RedirectToAction("ViewNotifications", "Notification");
        }
	}
}