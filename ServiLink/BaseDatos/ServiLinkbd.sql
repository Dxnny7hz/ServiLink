CREATE DATABASE Servilinkbd;
GO

USE Servilinkbd;
GO

CREATE TABLE Perfil (
    id_perfil INT IDENTITY(1,1) PRIMARY KEY,
	rimagen_perfil VARBINARY(MAX),
	documneto_frente VARBINARY(MAX),
	documento_atras VARBINARY(MAX),
	documento  Varchar(25),
    nombre_completo VARCHAR(300) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    fecha_nacimiento DATETIME,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    sexo VARCHAR(10) NOT NULL CHECK (sexo IN ('Masculino', 'Femenino')),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    fecha_registro DATETIME DEFAULT (GETDATE())
);
GO


CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_perfil INT UNIQUE NOT NULL, -- Relación con el perfil
    nombre_usuario VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('CONSUMIDOR', 'PROVEEDOR_SERVICIO', 'ADMINISTRADOR')),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil)
);
GO

CREATE TABLE Consumidor (  -- Se corrigió "Cosumidor" a "Consumidor"
    id_consumidor INT IDENTITY(1,1) PRIMARY KEY,
    id_perfil INT UNIQUE NOT NULL, -- Relación con el perfil
    calificacion_promedio DECIMAL(3,2) DEFAULT 0.00,
    latitud DECIMAL(10, 6),
    longitud DECIMAL(10, 6),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    detalles_adicionales VARCHAR(500), -- Campo opcional para más detalles
    FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil)
);
GO
CREATE TABLE Especializaciones (
    id_especializacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE ProveedorServicio (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    id_perfil INT UNIQUE NOT NULL, -- Relación con el perfil
    id_especializacion INT NOT NULL,
    descripcion_perfil VARCHAR(500),
    disponibilidad VARCHAR(15) DEFAULT 'DISPONIBLE' CHECK (disponibilidad IN ('DISPONIBLE', 'OCUPADO', 'NO DISPONIBLE')),
    calificacion_promedio DECIMAL(3,2) DEFAULT 0.00,
    latitud DECIMAL(10, 6),
    longitud DECIMAL(10, 6),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil),
    FOREIGN KEY (id_especializacion) REFERENCES Especializaciones(id_especializacion) ON DELETE CASCADE
);
GO



CREATE TABLE Administrador (
    id_administrador INT IDENTITY(1,1) PRIMARY KEY,
    id_perfil INT UNIQUE NOT NULL, -- Relación con el perfil
    nivel_acceso VARCHAR(20) NOT NULL CHECK (nivel_acceso IN ('BASICO', 'MEDIO', 'ALTO')),
    FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil)
);
GO

CREATE TABLE Etiqueta (
    id_etiqueta INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE ServiciosCategoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo'))
);
GO

CREATE TABLE Servicios (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    id_categoria INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    FOREIGN KEY (id_categoria) REFERENCES ServiciosCategoria(id_categoria)
);
GO

CREATE TABLE Solicitudes (
    id_solicitud INT IDENTITY(1,1) PRIMARY KEY,
    id_consumidor INT,
    id_servicio INT,
    id_proveedor INT,
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_servicio DATETIME NOT NULL,
    estado VARCHAR(15) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'ACEPTADA', 'EN PROGRESO', 'COMPLETADA', 'CANCELADA')),
    detalles VARCHAR(1000),  
    direccion_servicio VARCHAR(255),  
    metodo_pago VARCHAR(15) CHECK (metodo_pago IN ('EFECTIVO')),
    costo DECIMAL(10, 2), 
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    comentario_calificacion VARCHAR(500),
    
    -- Restricción para validar las fechas
    CONSTRAINT chk_fecha_servicio CHECK (
        fecha_servicio >= GETDATE() 
        AND fecha_servicio <= DATEADD(MONTH, 6, fecha_solicitud)
    ),

    -- Claves foráneas
    FOREIGN KEY (id_consumidor) REFERENCES Consumidor(id_consumidor),
    FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio),
    FOREIGN KEY (id_proveedor) REFERENCES ProveedorServicio(id_proveedor)
);
GO

CREATE TABLE HistorialServicios (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_solicitud INT NOT NULL,
    id_proveedor INT,
    estado_progreso VARCHAR(15) NOT NULL CHECK (estado_progreso IN ('PENDIENTE', 'ACEPTADA', 'EN PROGRESO', 'COMPLETADA', 'CANCELADA')),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    comentario VARCHAR(500),  
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    FOREIGN KEY (id_solicitud) REFERENCES Solicitudes(id_solicitud),
    FOREIGN KEY (id_proveedor) REFERENCES ProveedorServicio(id_proveedor)
);
GO

CREATE TABLE Notificaciones (
    id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,  
    tipo VARCHAR(20) CHECK (tipo IN ('NUEVA SOLICITUD', 'RECORDATORIO', 'ALERTA')),
    mensaje VARCHAR(500) NOT NULL,  
    fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    leida BIT DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
GO



CREATE TABLE ProveedorEtiqueta ( 
    id_proveedor_etiqueta INT IDENTITY(1,1) PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_etiqueta INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES ProveedorServicio(id_proveedor),
    FOREIGN KEY (id_etiqueta) REFERENCES Etiqueta(id_etiqueta)
);
GO
  
ALTER PROCEDURE RegistrarUsuarios
    @nombre_completo VARCHAR(300),
    @direccion VARCHAR(250),
    @fecha_Nacimiento DATETIME = NULL,
    @correo VARCHAR(150),
    @telefono VARCHAR(20),
    @sexo VARCHAR(10),
    @nombre_usuario VARCHAR(100),
    @contrasena VARCHAR(255),
    @rol VARCHAR(20),
    @id_especializacion INT = NULL,
    @descripcion_perfil VARCHAR(500) = NULL,
    @rimagen_perfil VARBINARY(MAX) = NULL,
    @documento_frente VARBINARY(MAX) = NULL,
    @documento_atras VARBINARY(MAX) = NULL,
    @documento VARCHAR(25) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar campos obligatorios generales
    IF @nombre_completo IS NULL OR @direccion IS NULL OR @correo IS NULL 
       OR @telefono IS NULL OR @sexo IS NULL OR @nombre_usuario IS NULL 
       OR @contrasena IS NULL OR @rol IS NULL
    BEGIN
        RAISERROR('Todos los campos obligatorios deben ser proporcionados.', 16, 1);
        RETURN;
    END;

    -- Validar documentos para Consumidor y Proveedor
    IF @rol IN ('CONSUMIDOR', 'PROVEEDOR_SERVICIO')
    BEGIN
        IF @documento IS NULL OR @documento_frente IS NULL OR @documento_atras IS NULL
        BEGIN
            RAISERROR('Para Consumidores y Proveedores, se requieren: número de documento y fotos del documento.', 16, 1);
            RETURN;
        END;
    END;

    -- Validar especialización solo para Proveedor
    IF @rol = 'PROVEEDOR_SERVICIO' AND @id_especializacion IS NULL
    BEGIN
        RAISERROR('La especialización es obligatoria para Proveedores.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar en Perfil (nombres de columnas corregidos)
        INSERT INTO Perfil (
            nombre_completo, direccion, fecha_Nacimiento, 
            correo, telefono, sexo, 
            rimagen_perfil, documento_frente, documento_atras, documento
        )
        VALUES (
            @nombre_completo, @direccion, @fecha_Nacimiento, 
            @correo, @telefono, @sexo, 
            @rimagen_perfil, @documento_frente, @documento_atras, @documento
        );

        DECLARE @id_perfil INT = SCOPE_IDENTITY();

        -- Insertar en Usuario
        INSERT INTO Usuario (id_perfil, nombre_usuario, contrasena, rol)
        VALUES (@id_perfil, @nombre_usuario, @contrasena, @rol);

        -- Insertar en tabla específica según rol
        IF @rol = 'CONSUMIDOR'
        BEGIN
            INSERT INTO Consumidor (id_perfil)
            VALUES (@id_perfil);
        END
        ELSE IF @rol = 'PROVEEDOR_SERVICIO'
        BEGIN
            INSERT INTO ProveedorServicio (
                id_perfil, id_especializacion, descripcion_perfil
            )
            VALUES (
                @id_perfil, @id_especializacion, @descripcion_perfil
            );
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al registrar el usuario: %s', 16, 1, @ErrorMessage);
    END CATCH;
END;
GO





ALTER PROCEDURE RegistrarUsuarios
    @nombre_completo VARCHAR(300),
    @direccion VARCHAR(250),
    @fecha_Nacimiento DATETIME = NULL,
    @correo VARCHAR(150),
    @telefono VARCHAR(20),
    @sexo VARCHAR(10),
    @nombre_usuario VARCHAR(100),
    @contrasena VARCHAR(255),
    @rol VARCHAR(20),
    @id_especializacion INT = NULL,
    @descripcion_perfil VARCHAR(500) = NULL,
    @rimagen_perfil VARBINARY(MAX) = NULL,
    @documento_frente VARBINARY(MAX),
    @documento_atras VARBINARY(MAX),
    @documento VARCHAR(25) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar campos obligatorios generales
    IF @nombre_completo IS NULL OR @direccion IS NULL OR @correo IS NULL 
       OR @telefono IS NULL OR @sexo IS NULL OR @nombre_usuario IS NULL 
       OR @contrasena IS NULL OR @rol IS NULL
    BEGIN
        RAISERROR('Todos los campos obligatorios deben ser proporcionados.', 16, 1);
        RETURN;
    END;

    -- Validar documentos para Consumidor y Proveedor
    IF @rol IN ('CONSUMIDOR', 'PROVEEDOR_SERVICIO')
    BEGIN
        IF @documento IS NULL OR @documento_frente IS NULL OR @documento_atras IS NULL
        BEGIN
            RAISERROR('Para Consumidores y Proveedores, se requieren: número de documento y fotos del documento.', 16, 1);
            RETURN;
        END;
    END;

    -- Validar especialización solo para Proveedor
    IF @rol = 'PROVEEDOR_SERVICIO' AND @id_especializacion IS NULL
    BEGIN
        RAISERROR('La especialización es obligatoria para Proveedores.', 16, 1);
        RETURN;
    END;

    -- Asegurar que para Consumidor, id_especializacion y descripcion_perfil sean nulos
    IF @rol = 'CONSUMIDOR'
    BEGIN
        SET @id_especializacion = NULL;
        SET @descripcion_perfil = NULL;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar en Perfil
        INSERT INTO Perfil (
            nombre_completo, direccion, fecha_Nacimiento, 
            correo, telefono, sexo, 
            rimagen_perfil, documento_frente, documento_atras, documento
        )
        VALUES (
            @nombre_completo, @direccion, @fecha_Nacimiento, 
            @correo, @telefono, @sexo, 
            @rimagen_perfil, @documento_frente, @documento_atras, @documento
        );

        DECLARE @id_perfil INT = SCOPE_IDENTITY();

        -- Insertar en Usuario
        INSERT INTO Usuario (id_perfil, nombre_usuario, contrasena, rol)
        VALUES (@id_perfil, @nombre_usuario, @contrasena, @rol);

        -- Insertar en tabla específica según rol
        IF @rol = 'CONSUMIDOR'
        BEGIN
            INSERT INTO Consumidor (id_perfil)
            VALUES (@id_perfil);
        END
        ELSE IF @rol = 'PROVEEDOR_SERVICIO'
        BEGIN
            -- Validar nuevamente que id_especializacion no sea nulo
            IF @id_especializacion IS NULL
            BEGIN
                RAISERROR('La especialización es obligatoria para Proveedores.', 16, 1);
                RETURN;
            END;

            INSERT INTO ProveedorServicio (
                id_perfil, id_especializacion, descripcion_perfil
            )
            VALUES (
                @id_perfil, @id_especializacion, @descripcion_perfil
            );
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al registrar el usuario: %s', 16, 1, @ErrorMessage);
    END CATCH;
END;
GO
SELECT id_especializacion, nombre FROM Especializaciones


INSERT INTO Especializaciones (nombre) VALUES 
('Electricista'),
('Plomero'),
('Carpintero'),
('Pintor'),
('Mecánico Automotriz'),
('Técnico en Refrigeración'),
('Cerrajero'),
('Jardinero'),
('Albañil'),
('Técnico en Computación');

select * from Perfil
select * from ProveedorServicio
select * from Usuario
select * from Consumidor




CREATE PROCEDURE ValidarLogin
    @nombre_usuario NVARCHAR(50),
    @contrasena NVARCHAR(50) -- Contraseña en texto plano
AS
BEGIN
    -- Verificar si el usuario y la contraseña coinciden
    SELECT 
        id_usuario,
        id_perfil,
        rol
    FROM 
        Usuario
    WHERE 
        nombre_usuario = @nombre_usuario
        AND contrasena = @contrasena 
        AND estado = 'ACTIVO'; 
END





CREATE NONCLUSTERED INDEX IX_Usuario_NombreUsuario 
ON Usuario (nombre_usuario);





ALTER PROCEDURE RegistrarUsuarios
    @nombre_completo VARCHAR(300),
    @direccion VARCHAR(250),
    @fecha_Nacimiento DATETIME = NULL,
    @correo VARCHAR(150),
    @telefono VARCHAR(20),
    @sexo VARCHAR(10),
    @nombre_usuario VARCHAR(100),
    @contrasena VARCHAR(255),
    @rol VARCHAR(20),
    @id_especializacion INT = NULL,
    @descripcion_perfil VARCHAR(500) = NULL,
    @rimagen_perfil VARBINARY(MAX) = NULL,
    @documento_frente VARBINARY(MAX),
    @documento_atras VARBINARY(MAX),
    @documento VARCHAR(25) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar campos obligatorios generales
    IF @nombre_completo IS NULL OR @direccion IS NULL OR @correo IS NULL 
       OR @telefono IS NULL OR @sexo IS NULL OR @nombre_usuario IS NULL 
       OR @contrasena IS NULL OR @rol IS NULL
    BEGIN
        RAISERROR('Todos los campos obligatorios deben ser proporcionados.', 16, 1);
        RETURN;
    END;

    -- Validar documentos para Consumidor y Proveedor
    IF @rol IN ('CONSUMIDOR', 'PROVEEDOR_SERVICIO')
    BEGIN
        IF @documento IS NULL OR @documento_frente IS NULL OR @documento_atras IS NULL
        BEGIN
            RAISERROR('Para Consumidores y Proveedores, se requieren: número de documento y fotos del documento.', 16, 1);
            RETURN;
        END;
    END;

    -- Validar especialización solo para Proveedor
    IF @rol = 'PROVEEDOR_SERVICIO' AND @id_especializacion IS NULL
    BEGIN
        RAISERROR('La especialización es obligatoria para Proveedores.', 16, 1);
        RETURN;
    END;

    -- Asegurar que para Consumidor, id_especializacion y descripcion_perfil sean nulos
    IF @rol = 'CONSUMIDOR'
    BEGIN
        SET @id_especializacion = NULL;
        SET @descripcion_perfil = NULL;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar en Perfil (Corregido el nombre de la columna documento_frente)
        INSERT INTO Perfil (
            nombre_completo, direccion, fecha_Nacimiento, 
            correo, telefono, sexo, 
            rimagen_perfil, documento_frente, documento_atras, documento
        )
        VALUES (
            @nombre_completo, @direccion, @fecha_Nacimiento, 
            @correo, @telefono, @sexo, 
            @rimagen_perfil, @documento_frente, @documento_atras, @documento
        );

        DECLARE @id_perfil INT = SCOPE_IDENTITY();

        -- Insertar en Usuario
        INSERT INTO Usuario (id_perfil, nombre_usuario, contrasena, rol)
        VALUES (@id_perfil, @nombre_usuario, @contrasena, @rol);

        -- Insertar en tabla específica según rol
        IF @rol = 'CONSUMIDOR'
        BEGIN
            INSERT INTO Consumidor (id_perfil)
            VALUES (@id_perfil);
        END
        ELSE IF @rol = 'PROVEEDOR_SERVICIO'
        BEGIN
            -- Validar existencia de especialización (Opcional)
            IF NOT EXISTS (SELECT 1 FROM Especializaciones WHERE id_especializacion = @id_especializacion)
            BEGIN
                RAISERROR('La especialización proporcionada no existe.', 16, 1);
                RETURN;
            END;

            INSERT INTO ProveedorServicio (
                id_perfil, id_especializacion, descripcion_perfil
            )
            VALUES (
                @id_perfil, @id_especializacion, @descripcion_perfil
            );
        END
        ELSE IF @rol = 'ADMINISTRADOR'
        BEGIN
            -- Si se permite crear administradores, agregar lógica aquí con parámetros adicionales
            RAISERROR('Registro de administradores no está soportado en este procedimiento.', 16, 1);
            RETURN;
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al registrar el usuario: %s', 16, 1, @ErrorMessage);
    END CATCH;
END;
GO



EXEC RegistrarUsuarios 
    @nombre_completo = 'Miguel Pérez',
    @direccion = 'Calle 123, Ciudad',
    @fecha_Nacimiento = '1990-05-15',
    @correo = 'juan.perez@email.com',
    @telefono = '809-555-1234',
    @sexo = 'Masculino',
    @nombre_usuario = 'juanperez90',
    @contrasena = 'ClaveSegura123',  -- Asegúrate de que esté encriptada si es necesario
    @rol = 'CONSUMIDOR',
    @id_especializacion = NULL,
    @descripcion_perfil = NULL,
    @rimagen_perfil = NULL,
    @documento_frente = 0x12345678,  -- Sustituir con un valor binario real
    @documento_atras = 0x87654321,   -- Sustituir con un valor binario real
    @documento = '001-1234567-8';