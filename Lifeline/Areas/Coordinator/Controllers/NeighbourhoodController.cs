using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lifeline.Areas.Coordinator.Controllers
{
    public class NeighbourhoodController : Controller
    {
        // GET: Neighbourhood/Neighbourhoods

        public ActionResult Neighbourhoods()
        {
            return View();
        }

        // GET: Neighbourhood/AddNeighbourhood

        public ActionResult AddNeighbourhood()
        {
            return View();
        }
    }
}