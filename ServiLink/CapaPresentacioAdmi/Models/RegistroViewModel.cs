using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNetCore.Http;

namespace CapaPresentacioAdmi.Models
{
	public class RegistroViewModel
	{
       
            public string NombreCompleto { get; set; }
            public string Direccion { get; set; }
            public DateTime FechaNacimiento { get; set; }
            public string Correo { get; set; }
            public string Telefono { get; set; }
            public string Sexo { get; set; }
            public string NombreUsuario { get; set; }
            public string Contrasena { get; set; }
            public string Rol { get; set; }
            public string Documento { get; set; }
            public HttpPostedFileBase DocumentoFrente { get; set; }
            public HttpPostedFileBase DocumentoAtras { get; set; }
            public HttpPostedFileBase ImagenPerfil { get; set; }
            public int EspecializacionId { get; set; }
            public string DescripcionPerfil { get; set; }
        
    }
}