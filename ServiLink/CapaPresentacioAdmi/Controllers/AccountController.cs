using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CapaPresentacioAdmi.Controllers
{
    public class AccountController : Controller
    {
        // GET: Account
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(string usuario, string contrasena)
        {
            if (ValidarUsuario(usuario, contrasena))
            {
                FormsAuthentication.SetAuthCookie(usuario, false);
                return RedirectToAction("Home", "Menu"); // Redirigir al dashboard
            }
            else
            {
                ModelState.AddModelError("", "Usuario o contraseña incorrectos.");
                return View();
            }
        }

        private bool ValidarUsuario(string usuario, string contrasena)
        {
            // Lógica de validación (puedes usar tu código actual de Web Forms)
            string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ValidarLogin", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@nombre_usuario", usuario);
                    cmd.Parameters.AddWithValue("@contrasena", contrasena); 

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Guardar datos en la sesión
                        Session["id_usuario"] = reader["id_usuario"];
                        Session["id_perfil"] = reader["id_perfil"];
                        Session["rol"] = reader["rol"];
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        // Cerrar sesión
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Logout", "Account");
        }
    }

}
