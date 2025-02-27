using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CapaPresentacioAdmi.Controllers
{
    
    public class HomeController : Controller
    {
      
        public ActionResult Index()
        {
      

            return View();
        }
        

        public ActionResult About()
        {
            ViewBag.Message = "Es una plataforma que conecta a profesionales con clientes que necesitan soluciones rápidas y eficientes. " +
                "Desde reparaciones hasta asesoría especializada, encuentras el servicio que necesitas con solo un clic.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult Logout()
        {
            // Limpia la sesión y desautentica al usuario
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();  // Si utilizas Forms Authentication

            // Redirige al login (puede ser una vista MVC o una página WebForms)
            return Redirect("~/LoginUI.aspx");


        }


    }
}