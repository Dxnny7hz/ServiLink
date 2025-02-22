<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FrmRegistroConsumidor.aspx.cs" Inherits="CapaPresentacioAdmi.WebForms.FrmRegistroConsumidor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
     <link href="../Recursos/CSS/EstiloSoli.css" rel="stylesheet"></link>
    <title>Registros de Usuario</title>
</head>
<body>
      <div class="wrapper">
        <div class="formcontent">
            <form id="formRegistro" runat="server">
                <div class="form-control">
                    <div class="col-md-6 text-center mb-5">
            
                        <asp:Label CssClass="head3" ID="lblBienvenida" runat="server" Text="Registro de Solicitante"></asp:Label>
                    </div>

                    <div>
                        <asp:Label ID="lblNombreCompleto" runat="server" Text="Nombre Completo"></asp:Label>
                        <asp:TextBox ID="txtNombreCompleto" CssClass="form-control" runat="server" placeholder="Ingrese su nombre completo"></asp:TextBox>
                    </div>

                    <div>
                        <asp:Label ID="lblCorreo" runat="server" Text="Correo Electrónico"></asp:Label>
                        <asp:TextBox ID="txtCorreo" CssClass="form-control" runat="server" placeholder="Ingrese su correo"></asp:TextBox>
                    </div>

                    <div>
                        <asp:Label ID="lblTelefono" runat="server" Text="Teléfono"></asp:Label>
                        <asp:TextBox ID="txtTelefono" CssClass="form-control" runat="server" placeholder="Ingrese su teléfono"></asp:TextBox>
                    </div>

                    <div>
                        <asp:Label ID="lblDireccion" runat="server" Text="Dirección"></asp:Label>
                        <asp:TextBox ID="txtDireccion" CssClass="form-control" runat="server" placeholder="Ingrese su dirección"></asp:TextBox>
                    </div>

                    <div>
                        <asp:Label ID="lblFechaNacimiento" runat="server" Text="Fecha de Nacimiento"></asp:Label>
                        <asp:TextBox ID="txtFechaNacimiento" CssClass="form-control" runat="server" TextMode="Date"></asp:TextBox>
                    </div>

                    <div>
                        <asp:Label ID="lblSexo" runat="server" Text="Sexo"></asp:Label>
                        <asp:DropDownList ID="ddlSexo" CssClass="form-control" runat="server">
                            <asp:ListItem Text="Masculino" Value="Masculino" />
                            <asp:ListItem Text="Femenino" Value="Femenino" />
                        </asp:DropDownList>
                    </div>

                    <br />
                    <div>
                        <asp:Label ID="lblError" CssClass="alert-danger" runat="server"></asp:Label>
                    </div>
                    <br />

                    <div class="row">
                        <asp:Button ID="btnRegistrar" CssClass="btn btn-primary btn-dark" runat="server" Text="Registrarse" OnClick="btnRegistrar_Click" />
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
