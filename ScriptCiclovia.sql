/* =========================
   1) Base de datos
   ========================= */
DROP DATABASE IF EXISTS ciclovias_db;
CREATE DATABASE ciclovias_db;
USE ciclovias_db;

/* =========================
   2) Tablas
   ========================= */
DROP TABLE IF EXISTS Reporte;
DROP TABLE IF EXISTS UsuarioRuta;
DROP TABLE IF EXISTS RutaCiclovia;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Comuna;
DROP TABLE IF EXISTS Rol;
DROP TABLE IF EXISTS Persona;

CREATE TABLE Persona (
    id_persona INT AUTO_INCREMENT PRIMARY KEY,
    rut VARCHAR(12) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50),
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Comuna (
    id_comuna INT AUTO_INCREMENT PRIMARY KEY,
    nombre_comuna VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    id_rol INT NOT NULL,
    id_comuna INT NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_persona) REFERENCES Persona(id_persona),
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol),
    FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
) ENGINE=InnoDB;

CREATE TABLE RutaCiclovia (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ruta VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_comuna INT NOT NULL,
    estado ENUM('Activa','Inactiva') DEFAULT 'Activa',
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
) ENGINE=InnoDB;

CREATE TABLE UsuarioRuta (
    id_usuario_ruta INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_ruta INT NOT NULL,
    fecha_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_ruta) REFERENCES RutaCiclovia(id_ruta)
) ENGINE=InnoDB;

CREATE TABLE Reporte (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_ruta INT NOT NULL,
    tipo_reporte varchar(100) NOT NULL,
    detalle TEXT,
    fecha_reporte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_ruta) REFERENCES RutaCiclovia(id_ruta)
) ENGINE=InnoDB;

-- Crea la tabla
CREATE TABLE Region (
    id_region INT AUTO_INCREMENT PRIMARY KEY,
    nombre_region VARCHAR(100) NOT NULL,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


/* =========================
   3) Datos base
   ========================= */
INSERT INTO Rol (nombre_rol, descripcion) VALUES
('Administrador', 'Gestiona usuarios y reportes'),
('Usuario', 'Accede y reporta incidentes');

INSERT INTO Comuna (nombre_comuna, region) VALUES
('Puente Alto', 'Región Metropolitana'),
('La Florida', 'Región Metropolitana');

/* =========================
   4) Procedimientos almacenados
   ========================= */

-- Persona
DELIMITER //
CREATE PROCEDURE sp_persona_insertar(
  IN p_rut VARCHAR(12),
  IN p_nombre VARCHAR(50),
  IN p_apellido VARCHAR(50),
  IN p_correo VARCHAR(100),
  IN p_telefono VARCHAR(15)
)
BEGIN
  INSERT INTO Persona(rut, nombre, apellido, correo, telefono, deleted)
  VALUES (p_rut, p_nombre, p_apellido, p_correo, p_telefono, 0);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_persona_listar()
BEGIN
  SELECT * FROM Persona WHERE deleted = 0 ORDER BY nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_persona_borrado_logico(IN p_id INT)
BEGIN
  UPDATE Persona SET deleted = 1 WHERE id_persona = p_id;
END//
DELIMITER ;

-- Usuario
DELIMITER //
CREATE PROCEDURE sp_usuario_insertar(
  IN p_id_persona INT,
  IN p_id_rol INT,
  IN p_id_comuna INT,
  IN p_contraseña VARCHAR(100)
)
BEGIN
  INSERT INTO Usuario(id_persona, id_rol, id_comuna, contraseña, deleted)
  VALUES (p_id_persona, p_id_rol, p_id_comuna, p_contraseña, 0);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_usuario_listar()
BEGIN
  SELECT u.id_usuario, p.nombre, p.apellido, r.nombre_rol, c.nombre_comuna
  FROM Usuario u
  JOIN Persona p ON u.id_persona = p.id_persona
  JOIN Rol r ON u.id_rol = r.id_rol
  JOIN Comuna c ON u.id_comuna = c.id_comuna
  WHERE u.deleted = 0;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_usuario_borrado_logico(IN p_id INT)
BEGIN
  UPDATE Usuario SET deleted = 1 WHERE id_usuario = p_id;
END//
DELIMITER ;

-- Ruta Ciclovía
DELIMITER //
CREATE PROCEDURE sp_ruta_insertar(
  IN p_nombre VARCHAR(100),
  IN p_descripcion TEXT,
  IN p_id_comuna INT,
  IN p_estado ENUM('Activa','Inactiva')
)
BEGIN
  INSERT INTO RutaCiclovia(nombre_ruta, descripcion, id_comuna, estado, deleted)
  VALUES (p_nombre, p_descripcion, p_id_comuna, p_estado, 0);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_ruta_listar()
BEGIN
  SELECT r.id_ruta, r.nombre_ruta, c.nombre_comuna, r.estado
  FROM RutaCiclovia r
  JOIN Comuna c ON r.id_comuna = c.id_comuna
  WHERE r.deleted = 0;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_ruta_borrado_logico(IN p_id INT)
BEGIN
  UPDATE RutaCiclovia SET deleted = 1 WHERE id_ruta = p_id;
END//
DELIMITER ;

-- Reportes
DELIMITER //
CREATE PROCEDURE sp_reporte_insertar(
  IN p_id_usuario INT,
  IN p_id_ruta INT,
  IN p_tipo ENUM('Accidente','Problema','Cambio Contraseña','Inicio Sesion'),
  IN p_detalle TEXT
)
BEGIN
  INSERT INTO Reporte(id_usuario, id_ruta, tipo_reporte, detalle)
  VALUES (p_id_usuario, p_id_ruta, p_tipo, p_detalle);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_reporte_listar()
BEGIN
  SELECT rp.id_reporte, p.nombre, rc.nombre_ruta, rp.tipo_reporte, rp.fecha_reporte
  FROM Reporte rp
  JOIN Usuario u ON rp.id_usuario = u.id_usuario
  JOIN Persona p ON u.id_persona = p.id_persona
  JOIN RutaCiclovia rc ON rp.id_ruta = rc.id_ruta;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_persona_listar_todo()
BEGIN
  SELECT 
    p.id_persona AS id,
    p.rut,
    p.nombre,
    p.apellido,
    p.correo,
    p.telefono,
    p.deleted
  FROM Persona p
  ORDER BY p.nombre;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_region_insertar(IN p_nombre VARCHAR(100))
BEGIN
    INSERT INTO Region(nombre_region, deleted) 
    VALUES (p_nombre, 0);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_region_listar()
BEGIN
    SELECT * FROM Region WHERE deleted = 0 ORDER BY nombre_region;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_region_borrado_logico(IN p_id INT)
BEGIN
    UPDATE Region SET deleted = 1 WHERE id_region = p_id;
END //
DELIMITER ;

/* =========================
   PROCEDIMIENTOS PARA ROL
   ========================= */

DELIMITER //

-- Insertar rol
CREATE PROCEDURE sp_rol_insertar(
    IN p_nombre_rol VARCHAR(50),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO Rol(nombre_rol, descripcion, deleted)
    VALUES (p_nombre_rol, p_descripcion, 0);
END//

-- Listar roles activos
CREATE PROCEDURE sp_rol_listar()
BEGIN
    SELECT id_rol, nombre_rol, descripcion
    FROM Rol
    WHERE deleted = 0
    ORDER BY nombre_rol;
END//

-- Borrado lógico rol
CREATE PROCEDURE sp_rol_borrado_logico(IN p_id INT)
BEGIN
    UPDATE Rol
    SET deleted = 1
    WHERE id_rol = p_id;
END//

DELIMITER ;


/* =========================
   PROCEDIMIENTOS PARA COMUNA
   ========================= */

DELIMITER //

-- Insertar comuna
CREATE PROCEDURE sp_comuna_insertar(
    IN p_nombre_comuna VARCHAR(100),
    IN p_region VARCHAR(100)
)
BEGIN
    INSERT INTO Comuna(nombre_comuna, region, deleted)
    VALUES (p_nombre_comuna, p_region, 0);
END//

-- Listar comunas activas
CREATE PROCEDURE sp_comuna_listar()
BEGIN
    SELECT id_comuna, nombre_comuna, region
    FROM Comuna
    WHERE deleted = 0
    ORDER BY nombre_comuna;
END//

-- Borrado lógico comuna
CREATE PROCEDURE sp_comuna_borrado_logico(IN p_id INT)
BEGIN
    UPDATE Comuna
    SET deleted = 1
    WHERE id_comuna = p_id;
END//

DELIMITER ;


/* =========================
   5) Pruebas rápidas
   ========================= */
CALL sp_persona_insertar('20.111.333-4', 'Ian', 'Rojas', 'ianr@gmail.com', '987654321');
CALL sp_persona_insertar('19.222.444-5', 'Camila', 'Soto', 'camilas@gmail.com', '912345678');

CALL sp_usuario_insertar(1, 1, 1, 'admin123');
CALL sp_usuario_insertar(2, 2, 2, 'user123');

CALL sp_ruta_insertar('Ruta Las Perdices', 'Conecta con el parque principal', 1, 'Activa');
CALL sp_ruta_insertar('Ruta San Carlos', 'Alta congestión', 2, 'Inactiva');

CALL sp_reporte_insertar(2, 1, 'Accidente', 'Caída por mal estado del pavimento');

CALL sp_persona_listar();
CALL sp_usuario_listar();
CALL sp_ruta_listar();
CALL sp_reporte_listar();

CALL sp_persona_borrado_logico(1);
CALL sp_persona_listar_todo();
CALL sp_persona_listar();