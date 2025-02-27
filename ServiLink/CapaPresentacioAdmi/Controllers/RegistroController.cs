using CapaPresentacioAdmi.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CapaPresentacioAdmi.Controllers
{
    public class RegistroController : Controller
    {
        // GET: Registro/Index
        public ActionResult Index()
        {
            // Cargar las especializaciones y pasarlas a la vista
            ViewBag.Especializaciones = GetEspecializaciones();
            return View();
        }

        // POST: Registro/Index
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(RegistroViewModel model)
        {
            // Cargar las especializaciones en caso de que el modelo no sea válido
            ViewBag.Especializaciones = GetEspecializaciones();

            if (ModelState.IsValid)
            {
                // Validar archivos: frente y reverso del documento
                if (!ValidarArchivo(model.DocumentoFrente) || !ValidarArchivo(model.DocumentoAtras))
                {
                    ModelState.AddModelError("", "Los archivos deben ser imágenes (JPEG, PNG) o PDF y no superar los 5MB.");
                    return View(model);
                }

                try
                {
                    RegistrarUsuario(model);

                 
                }
                catch (Exception ex)
                {
                    // Si hay un error, mostrarlo en la vista
                    ModelState.AddModelError("", "Error: " + ex.Message);
                }
            }

            // Si el modelo no es válido o hay un error, vuelve a mostrar el formulario
            return View(model);
        }

        // Validación de archivos (extensión y tamaño máximo de 5MB)
        private bool ValidarArchivo(HttpPostedFileBase file)
        {
            if (file == null || file.ContentLength == 0)
                return false;

            string extension = Path.GetExtension(file.FileName).ToLower();
            string[] tiposPermitidos = { ".jpg", ".jpeg", ".png", ".pdf" };
            const int maxTamano = 5 * 1024 * 1024; // 5MB
            return tiposPermitidos.Contains(extension) && file.ContentLength <= maxTamano;
        }

        // Método para obtener las especializaciones desde la base de datos
        private List<SelectListItem> GetEspecializaciones()
        {
            var especializaciones = new List<SelectListItem>();
            string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT id_especializacion, nombre FROM Especializaciones";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        especializaciones.Add(new SelectListItem { Text = "Seleccione una especialización", Value = "" });
                        while (reader.Read())
                        {
                            especializaciones.Add(new SelectListItem
                            {
                                Text = reader["nombre"].ToString(),
                                Value = reader["id_especializacion"].ToString()
                            });
                        }
                    }
                }
            }

            return especializaciones;
        }

        // Método para registrar al usuario mediante un procedimiento almacenado
        private void RegistrarUsuario(RegistroViewModel model)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("RegistrarUsuarios", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros básicos
                    cmd.Parameters.AddWithValue("@nombre_completo", model.NombreCompleto);
                    cmd.Parameters.AddWithValue("@direccion", model.Direccion);
                    cmd.Parameters.AddWithValue("@fecha_Nacimiento", model.FechaNacimiento);
                    cmd.Parameters.AddWithValue("@correo", model.Correo);
                    cmd.Parameters.AddWithValue("@telefono", model.Telefono);
                    cmd.Parameters.AddWithValue("@sexo", model.Sexo);
                    cmd.Parameters.AddWithValue("@nombre_usuario", model.NombreUsuario);
                    cmd.Parameters.AddWithValue("@contrasena", model.Contrasena);
                    cmd.Parameters.AddWithValue("@rol", model.Rol);
                    cmd.Parameters.AddWithValue("@documento", model.Documento);

                    // Parámetros para documentos (convertir los archivos a byte[])
                    if (model.DocumentoFrente != null)
                    {
                        using (var msFrente = new MemoryStream())
                        {
                            model.DocumentoFrente.InputStream.CopyTo(msFrente);
                            cmd.Parameters.AddWithValue("@documento_frente", msFrente.ToArray());
                        }
                    }
                    if (model.DocumentoAtras != null)
                    {
                        using (var msAtras = new MemoryStream())
                        {
                            model.DocumentoAtras.InputStream.CopyTo(msAtras);
                            cmd.Parameters.AddWithValue("@documento_atras", msAtras.ToArray());
                        }
                    }

                    // Imagen de perfil (opcional)
                    if (model.ImagenPerfil != null && model.ImagenPerfil.ContentLength > 0)
                    {
                        using (var msPerfil = new MemoryStream())
                        {
                            model.ImagenPerfil.InputStream.CopyTo(msPerfil);
                            cmd.Parameters.AddWithValue("@rimagen_perfil", msPerfil.ToArray());
                        }
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@rimagen_perfil", DBNull.Value);
                    }

                    // Parámetros específicos para proveedores
                    if (model.Rol == "PROVEEDOR_SERVICIO")
                    {
                        cmd.Parameters.AddWithValue("@id_especializacion",
                            string.IsNullOrEmpty(model.EspecializacionId.ToString()) ? (object)DBNull.Value : model.EspecializacionId);
                        cmd.Parameters.AddWithValue("@descripcion_perfil", model.DescripcionPerfil);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@id_especializacion", DBNull.Value);
                        cmd.Parameters.AddWithValue("@descripcion_perfil", DBNull.Value);
                    }

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            
        }
    }
}