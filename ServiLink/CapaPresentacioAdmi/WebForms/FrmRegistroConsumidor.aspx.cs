using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CapaPresentacioAdmi.WebForms
{
    public partial class FrmRegistroConsumidor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            string connectionString = "SERVICIOSPROFESIONALES1Entities"; 
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    // Insertar en la tabla Solicitante
                    string querySolicitante = "INSERT INTO Solicitante (nombre_completo, id_usuario, direccion, fecha_Nacimiento, correo, telefono, sexo) VALUES (@nombre_completo, @id_usuario, @direccion, @fecha_Nacimiento, @correo, @telefono, @sexo)";
                    SqlCommand cmdSolicitante = new SqlCommand(querySolicitante, conn);
                    cmdSolicitante.Parameters.AddWithValue("@nombre_completo", txtNombreCompleto.Text);
                    cmdSolicitante.Parameters.AddWithValue("@direccion", txtDireccion.Text);
                    cmdSolicitante.Parameters.AddWithValue("@fecha_Nacimiento", DateTime.Parse(txtFechaNacimiento.Text));
                    cmdSolicitante.Parameters.AddWithValue("@correo", txtCorreo.Text);
                    cmdSolicitante.Parameters.AddWithValue("@telefono", txtTelefono.Text);
                    cmdSolicitante.Parameters.AddWithValue("@sexo", ddlSexo.SelectedValue);
                    cmdSolicitante.ExecuteNonQuery();

                    lblError.Text = "Registro exitoso!";
                    lblError.CssClass = "alert-success";
                }
                catch (Exception ex)
                {
                    lblError.Text = "Error: " + ex.Message;
                    lblError.CssClass = "alert-danger";
                }
            }
        }
    }
}