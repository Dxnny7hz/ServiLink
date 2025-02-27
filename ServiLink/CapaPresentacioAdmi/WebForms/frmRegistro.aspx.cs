using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;
using System.Data;
using System.Linq;

namespace CapaPresentacioAdmi.WebForms
{
    public partial class frmRegistro : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        

            if (!IsPostBack)
            {
                CargarEspecializaciones();
                divEspecializacion.Visible = false;
                divDescripcionPerfil.Visible = false;
                divDocumentosUsuario.Visible = true;
            }
        }

        protected void ddlRol_SelectedIndexChanged(object sender, EventArgs e)
        {
            string rolSeleccionado = ddlRol.SelectedValue;

            // Mostrar documentos si es Consumidor o Proveedor
            divDocumentosUsuario.Visible = (rolSeleccionado == "CONSUMIDOR" || rolSeleccionado == "PROVEEDOR_SERVICIO");

            // Mostrar especialización y descripción solo para Proveedor
            divEspecializacion.Visible = (rolSeleccionado == "PROVEEDOR_SERVICIO");
            divDescripcionPerfil.Visible = (rolSeleccionado == "PROVEEDOR_SERVICIO");

            // Habilitar o deshabilitar el validador de especialización
            rfvEspecializacion.Enabled = (rolSeleccionado == "PROVEEDOR_SERVICIO");
        }

        protected void ValidarArchivo(object source, ServerValidateEventArgs args)
        {
            CustomValidator validador = (CustomValidator)source;
            FileUpload fuArchivo = (FileUpload)validador.Parent.FindControl(validador.ControlToValidate);

            args.IsValid = false;

            if (fuArchivo == null || !fuArchivo.HasFile)
            {
                return;
            }

            // Validar extensión
            string extension = Path.GetExtension(fuArchivo.FileName).ToLower();
            string[] tiposPermitidos = { ".jpg", ".jpeg", ".png", ".pdf" };

            // Validar tamaño (5MB)
            const int maxTamano = 5 * 1024 * 1024;
            bool tamanoValido = fuArchivo.FileBytes.Length <= maxTamano;

            args.IsValid = tiposPermitidos.Contains(extension) && tamanoValido;
        }
        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                RegistrarUsuario();
                LimpiarFormulario();
                lblMensaje.Text = "Usuario registrado exitosamente.";
                lblMensaje.CssClass = "success-message";

                ScriptManager.RegisterStartupScript(this, GetType(), "redirectAndClose",
     "setTimeout(function() { window.location.href = 'Login.aspx'; window.close(); }, 2000);", true);
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"Error: {ex.Message}";
                lblMensaje.CssClass = "error-message";
            }
        }

        private void RegistrarUsuario()
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["SQLServerConnection"].ConnectionString))
            {
                using (var cmd = new SqlCommand("RegistrarUsuarios", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    ConfigurarParametros(cmd);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ConfigurarParametros(SqlCommand cmd)
        {
            // Parámetros básicos
            cmd.Parameters.AddWithValue("@nombre_completo", txtNombreCompleto.Text);
            cmd.Parameters.AddWithValue("@direccion", txtDireccion.Text);
            cmd.Parameters.AddWithValue("@fecha_Nacimiento", DateTime.Parse(txtFechaNacimiento.Text));
            cmd.Parameters.AddWithValue("@correo", txtCorreo.Text);
            cmd.Parameters.AddWithValue("@telefono", txtTelefono.Text);
            cmd.Parameters.AddWithValue("@sexo", ddlSexo.SelectedValue);
            cmd.Parameters.AddWithValue("@nombre_usuario", txtNombreUsuario.Text);
            cmd.Parameters.AddWithValue("@contrasena", txtContrasena.Text);
            cmd.Parameters.AddWithValue("@rol", ddlRol.SelectedValue);

            // Documentos (obligatorios para ambos roles)
            cmd.Parameters.AddWithValue("@documento", txtDocumento.Text);
            cmd.Parameters.AddWithValue("@documento_frente", fuDocumentoFrente.FileBytes);
            cmd.Parameters.AddWithValue("@documento_atras", fuDocumentoAtras.FileBytes);

            // Parámetros opcionales
            cmd.Parameters.AddWithValue("@rimagen_perfil", fuImagenPerfil.HasFile ?
                fuImagenPerfil.FileBytes : (object)DBNull.Value);

            // Parámetros específicos de proveedor
            if (ddlRol.SelectedValue == "PROVEEDOR_SERVICIO")
            {
                cmd.Parameters.AddWithValue("@id_especializacion", int.Parse(ddlEspecializacion.SelectedValue));
                cmd.Parameters.AddWithValue("@descripcion_perfil", txtDescripcionPerfil.Text);
            }
            else
            {
                cmd.Parameters.AddWithValue("@id_especializacion", DBNull.Value);
                cmd.Parameters.AddWithValue("@descripcion_perfil", DBNull.Value);
            }
        }

        private void LimpiarFormulario()
        {
            // Limpiar todos los campos
            txtNombreCompleto.Text = string.Empty;
            txtDireccion.Text = string.Empty;
            txtFechaNacimiento.Text = string.Empty;
            txtCorreo.Text = string.Empty;
            txtTelefono.Text = string.Empty;
            txtNombreUsuario.Text = string.Empty;
            txtContrasena.Text = string.Empty;
            txtDocumento.Text = string.Empty;
            txtDescripcionPerfil.Text = string.Empty;

            // Limpiar file uploads
            fuImagenPerfil.Attributes.Clear();
            fuDocumentoFrente.Attributes.Clear();
            fuDocumentoAtras.Attributes.Clear();
        }




        private void CargarEspecializaciones()
        {
            // Cadena de conexión desde el Web.config
            string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnection"].ConnectionString;
            // Consulta SQL para obtener las especializaciones
            string query = "SELECT id_especializacion, nombre FROM Especializaciones";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        // Limpiar los elementos existentes en el DropDownList
                        ddlEspecializacion.Items.Clear();

                        // Agregar el ítem por defecto
                        ddlEspecializacion.Items.Add(new ListItem("Seleccione una especialización", ""));

                        // Recorrer los resultados y agregarlos al DropDownList
                        while (reader.Read())
                        {
                            string id = reader["id_especializacion"].ToString();
                            string nombre = reader["nombre"].ToString();
                            ddlEspecializacion.Items.Add(new ListItem(nombre, id));
                        }
                    }
                    catch (Exception ex)
                    {
                        // Manejar errores
                        lblMensaje.Text = "Error al cargar las especializaciones: " + ex.Message;
                        lblMensaje.CssClass = "error-message";
                    }
                }
            }
        }
    }
}


	
