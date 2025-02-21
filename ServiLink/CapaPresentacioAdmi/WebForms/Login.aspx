<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CapaPresentacioAdmi.WebForms.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js> </script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js></script>
    <link href="../Recursos/CSS/EstilosLog.css" rel="stylesheet"></link>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>

     <div class="wrapper">
         <divclass="formcontent">     

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
                 <div>
              <asp:Label ID="lblError" CssClass="alert-danger" runat="server" ></asp:Label>
                 </div>
            <br />
            <div class="row">
                <asp:Button ID="btnIngresar" CssClass="btn btn-primary btn-dark " runat="server" Text="Ingresar" OnClick="btnIngresar_Clik" />
            </div>   
    </div>
       
    </form> 
           </divclass="wrapper"></div>  
</body>
</html>
