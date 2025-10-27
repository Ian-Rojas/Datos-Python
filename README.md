# Ciclovías DB - CRUD MySQL con Python

Este repositorio contiene un sistema de gestión de ciclovías utilizando **MySQL** y **Python** con procedimientos almacenados (Stored Procedures). Permite manejar información de personas, usuarios, rutas, reportes, roles, comunas y regiones, incluyendo operaciones de **crear, leer y borrado lógico**.

---

## 🗂️ Estructura del proyecto

---

## 🛠 Tecnologías utilizadas

- **Python 3.x**
- **MySQL 8.x**
- **mysql-connector-python** (librería para conexión Python-MySQL)

---

## 📦 Tablas en la base de datos

El proyecto incluye las siguientes tablas:

1. **Persona**: Información de personas.
2. **Usuario**: Usuarios vinculados a personas, roles y comunas.
3. **RutaCiclovia**: Rutas de ciclovías y su estado.
4. **Reporte**: Reportes de incidencias en las rutas.
5. **Rol**: Tipos de roles de usuario (Administrador, Usuario).
6. **Comuna**: Comunas donde se encuentran las rutas.
7. **Region**: Regiones asociadas a las comunas.

---

## 🔧 Procedimientos almacenados

Cada tabla tiene sus propios procedimientos para:

- Insertar registros
- Listar registros activos
- Borrado lógico de registros

Ejemplo de uso en Python: `cur.callproc("sp_persona_insertar", [rut, nombre, apellido, correo, telefono])`

---
