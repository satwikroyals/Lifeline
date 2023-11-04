using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Lifeline.Entity;
using Lifeline.BAL;
using Lifeline.Areas.Coordinator.Models;
using System.Web.Security;
using Lifeline.Code;
using System.IO;


namespace Lifeline.Areas.Coordinator.Controllers
{
    public class AccountController : Controller
    {
        CoordinatorManager objcm = new CoordinatorManager();
        public ActionResult Login()
        {
            Response.Cache.SetNoStore();
            if (HttpContext.Request.Cookies["_lifecoordi"] != null)
            {
                return RedirectToAction("Dashboard", "Account", new { area="Coordinator"});
            }
            else
            {
                LoginModel lm = new LoginModel();
                return View(lm);
            }
        }
        [HttpPost]
        //[Route("Login")]
        public ActionResult Login(LoginModel model)
        {
            if (ModelState.IsValid)
            {
                MemberEntity ae = new MemberEntity();

                ae = objcm.CheckCoordinatorLogin(model.UserName, model.Password);  //Check Valid admin or not; return valid 1 not valid 0
                if (ae == null)
                {
                    ModelState.AddModelError("Login", "Invalid username / password.");    //go to login page
                    return View(model);
                }

                else
                {
                    //bool rememberMe = form.IsRemember;
                    //create cookie
                    DateTime expiration = DateTime.Now.AddDays(30);
                    FormsAuthentication.Initialize();
                    FormsAuthenticationTicket tkt = new FormsAuthenticationTicket(1, model.UserName,
                        DateTime.Now, expiration, true,
                        FormsAuthentication.FormsCookiePath);
                    HttpCookie ck = new HttpCookie("_lifecoordi", FormsAuthentication.Encrypt(tkt));
                    ck.Path = FormsAuthentication.FormsCookiePath;
                    ck.Expires = expiration;
                    ck["mid"] = ae.MemberId.ToString();
                    ck["iscoordi"] = ae.IsCoordinator.ToString();
                    ck["lid"] = ae.LocationId.ToString();
                    Response.Cookies.Add(ck);
                    FormsAuthentication.RedirectFromLoginPage(ae.MemberId.ToString(), true);
                    return RedirectToAction("Dashboard", "Account", new { area = "Coordinator" });
                }
            }
            else
            {
                return View(model);
            }
        }
        public ActionResult Logout()
        {
            if (Request.Cookies["_lifecoordi"] != null)
            {
                var c = new HttpCookie("_lifecoordi");
                c.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(c);
                FormsAuthentication.SignOut();
            }
            return RedirectToAction("Login");
        }
        public ActionResult Dashboard()
        {
            return View();
        }
	}
}