using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Lifeline.Entity;
using Lifeline.BAL;
using System.IO;

namespace Lifeline.Areas.Coordinator.Controllers
{
    public class IncidentsController : Controller
    {
        public ActionResult ViewIncidents()
        {
            return View();
        }
	}
}