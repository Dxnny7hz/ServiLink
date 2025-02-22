<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CapaPresentacioAdmi.WebForms.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js> </script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js></script>
   <link href="../Recursos/CSS/EstiloLog.css" rel="stylesheet" />

    <title> Login</title>
</head>
<body id="cuerpo">

     <div class="wrapper">
         <div="formcontent">     

    <form id="LoginUI" runat="server">
        <div class="form-control">
            <div class="col-md-6 text-center mb-5">
                <asp:label cLass="head3" ID="lblbienvenida" runat="server" Text="Bienvenido/a al sistema" >  </asp:label>
            </div>

            <div>
                <asp:Label ID="lblUsuario" runat="server" Text="Usuario"> </asp:Label>
                <asp:TextBox ID="txtUsuario" CssClass="form-control" runat="server" placeholder="Ingrese su Usuario"></asp:TextBox>
            </div>
               
            <div>
                <asp:Label ID="lblContraseña" runat="server" Text="Contrasena"></asp:Label>
               <asp:TextBox ID="txtContrasena" CssClass="form-control" runat="server" TextMode="Password"  placeholder="Ingrese su contrasena"></asp:TextBox>
            </div>

          <br />
            <div class="no-account">
        <label>¿No tiene cuenta?</label>
              <a href="FrmRegistroConsumidor.aspx">Cree una aquí</a>
                </div>
                 <div>
              <asp:Label ID="lblError" CssClass="alert-danger" runat="server" ></asp:Label>
                 </div>
            <br />
            <div class="row">
                <asp:Button ID="btnIngresar" CssClass="btn btn-primary btn-dark " runat="server" Text="Ingresar" OnClick="btnIngresar_Clik" />
            </div>   
    </div>
       
    </form> 
           </div>  
         </div>
</body>
</html>
