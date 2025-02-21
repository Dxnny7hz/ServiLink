using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CapaPresentacioAdmi.WebForms
{
    public partial class LogoutUI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Limpia la sesión y desautentica al usuario
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();  // Si usas Forms Authentication

            // Redirige al login
            Response.Redirect("Login.aspx");
        }
    }
}