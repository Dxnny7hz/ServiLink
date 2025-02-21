using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.EntityClient;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CapaPresentacioAdmi.WebForms
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnIngresar_Clik(object sender, EventArgs e)
        {
            // Obtiene la cadena de conexión definida en el web.config
            string conectar = ConfigurationManager.ConnectionStrings["SERVICIOSPROFESIONALES1Entities"].ConnectionString;

            // Extrae la cadena de conexión real del proveedor (SQL Server)
            EntityConnectionStringBuilder entityBuilder = new EntityConnectionStringBuilder(conectar);
            string providerConnectionString = entityBuilder.ProviderConnectionString;

            using (SqlConnection sqlConectar = new SqlConnection(providerConnectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_ValidarLogin", sqlConectar);
                cmd.CommandType = CommandType.StoredProcedure;

                // Usa .Text para obtener los valores de los controles
                cmd.Parameters.Add("@nombre", SqlDbType.VarChar).Value = txtUsuario.Text;
                cmd.Parameters.Add("@contrasena", SqlDbType.VarChar).Value = txtContrasena.Text;

                sqlConectar.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    int mensajeErrorIndex = -1;
                    try
                    {
                        mensajeErrorIndex = dr.GetOrdinal("MensajeError");
                    }
                    catch (IndexOutOfRangeException)
                    {
                        mensajeErrorIndex = -1; // La columna no existe
                    }

                    if (mensajeErrorIndex != -1)
                    {
                        // Se encontró la columna MensajeError, por lo que la validación falló.
                        lblError.Text = dr["MensajeError"].ToString();
                    }
                    else
                    {
                        // No se encontró MensajeError: login exitoso.
                        Response.Redirect("~/Home/Index");
                    }
                }
                else
                {
                    lblError.Text = "No se encontró el usuario.";
                }
                sqlConectar.Close();
            }

        }

    }
}