using System.Web.Mvc;

namespace Lifeline.Areas.Coordinator
{
    public class CoordinatorAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Coordinator";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "Coordinator_default",
                "Coordinator/{controller}/{action}/{id}",
                new { controller = "Account", action = "Login", id = UrlParameter.Optional },
                namespaces: new[] { "Lifeline.Areas.Coordinator.Controllers" }
            );
        }
    }
}