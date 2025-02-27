<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmRegistro.aspx.cs" Inherits="CapaPresentacioAdmi.WebForms.frmRegistro" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Recursos/CSS/EstilosRegistros.css" rel="stylesheet" />
    <title></title>
</head>
<body>
  <form id="form1" runat="server">
        <div class="form-container">
            <h2>Registro de Usuarios</h2>

            <div class="form-group">
                <label for="txtNombreCompleto">Nombre Completo:</label>
                <asp:TextBox ID="txtNombreCompleto" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombreCompleto" runat="server" ControlToValidate="txtNombreCompleto" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label>Imagen de perfil (Opcional):</label>
                <asp:FileUpload ID="fuImagenPerfil" runat="server" CssClass="form-control" />
            </div>

        <div id="divDocumentosUsuario" runat="server" class="form-group">
        <label>Número de documento:</label>
        <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvDocumento" runat="server" 
            ControlToValidate="txtDocumento" 
            ErrorMessage="El número de documento es obligatorio." 
            CssClass="error-message" 
            Display="Dynamic">
        </asp:RequiredFieldValidator>

        <label>Frente del documento:</label>
        <asp:FileUpload ID="fuDocumentoFrente" runat="server" CssClass="form-control" />
        <asp:CustomValidator ID="cvDocumentoFrente" runat="server" 
            ControlToValidate="fuDocumentoFrente" 
            ErrorMessage="El archivo debe ser una imagen (JPEG, PNG) o un PDF." 
            CssClass="error-message" 
            Display="Dynamic" 
            OnServerValidate="ValidarArchivo">
        </asp:CustomValidator>

        <label>Reverso del documento:</label>
        <asp:FileUpload ID="fuDocumentoAtras" runat="server" CssClass="form-control" />
        <asp:CustomValidator ID="cvDocumentoAtras" runat="server" 
            ControlToValidate="fuDocumentoAtras" 
            ErrorMessage="El archivo debe ser una imagen (JPEG, PNG) o un PDF." 
            CssClass="error-message" 
            Display="Dynamic" 
            OnServerValidate="ValidarArchivo">
        </asp:CustomValidator>
</div>
            <div class="form-group">
                <label for="txtDireccion">Dirección:</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtFechaNacimiento">Fecha de Nacimiento:</label>
                <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFechaNacimiento" runat="server" ControlToValidate="txtFechaNacimiento" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtCorreo">Correo:</label>
                <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtCorreo" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtTelefono">Teléfono:</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="ddlSexo">Sexo:</label>
                <asp:DropDownList ID="ddlSexo" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Masculino" Value="Masculino"></asp:ListItem>
                    <asp:ListItem Text="Femenino" Value="Femenino"></asp:ListItem>
                    <asp:ListItem Text="Otro" Value="Otro"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvSexo" runat="server" ControlToValidate="ddlSexo" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtNombreUsuario">Nombre de Usuario:</label>
                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server" ControlToValidate="txtNombreUsuario" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtContrasena">Contraseña:</label>
                <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvContrasena" runat="server" ControlToValidate="txtContrasena" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="ddlRol">Rol:</label>
               <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlRol_SelectedIndexChanged">
                    <asp:ListItem Text="CONSUMIDOR" Value="CONSUMIDOR" />
                    <asp:ListItem Text="PROVEEDOR_SERVICIO" Value="PROVEEDOR_SERVICIO" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvRol" runat="server" ControlToValidate="ddlRol" ErrorMessage="Este campo es obligatorio." CssClass="error-message"></asp:RequiredFieldValidator>
            </div>

                        <div id="divEspecializacion" runat="server" class="form-group">
                    <label for="ddlEspecializacion">Especialización:</label>
                    <asp:DropDownList ID="ddlEspecializacion" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Seleccione una especialización" Value="" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEspecializacion" runat="server" 
                        ControlToValidate="ddlEspecializacion" 
                        InitialValue="" 
                        ErrorMessage="Debe seleccionar una especialización." 
                        CssClass="error-message" 
                        Display="Dynamic" />
                </div>
            <div class="form-group" id="divDescripcionPerfil" runat="server" visible="false">
                <label for="txtDescripcionPerfil">Descripción del Perfil:</label>
                <asp:TextBox ID="txtDescripcionPerfil" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
            </div>

            <div class="form-group">
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="btn-submit" OnClick="btnRegistrar_Click" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" CssClass="message-label"></asp:Label>
        </div>
    </form>
</body>
</html>
