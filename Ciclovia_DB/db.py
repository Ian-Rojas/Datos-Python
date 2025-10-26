# ==========================================
# sp_menu.py
# CRUD básico con Procedimientos Almacenados (MySQL) desde Python
# Base de datos: ciclovias_db
# ==========================================

import mysql.connector

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234",  # reemplaza aquí
    "database": "ciclovias_db"
}

# ---------- FUNCIÓN DE CONEXIÓN ----------
def conectar():
    """Crea y devuelve una conexión a MySQL."""
    return mysql.connector.connect(**DB_CONFIG)


# ==========================================
# FUNCIONES CRUD POR TABLA
# ==========================================

# ---------- PERSONA ----------
def persona_insertar(rut, nombre, apellido, correo, telefono):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_persona_insertar", [rut, nombre, apellido, correo, telefono])
        cnx.commit()
        print("✅ Persona insertada correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error persona_insertar:", e)
        if cnx and cnx.is_connected():
            cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def persona_listar():
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("CALL sp_persona_listar()")
        filas = cur.fetchall()
        print("=== PERSONAS ACTIVAS ===")
        for fila in filas:
            print(f"ID:{fila[0]} | RUT:{fila[1]} | Nombre:{fila[2]} {fila[3]} | Correo:{fila[4]} | Tel:{fila[5]}")
    except mysql.connector.Error as e:
        print("❌ Error persona_listar:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def persona_borrado_logico(id_persona):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_persona_borrado_logico", [id_persona])
        cnx.commit()
        print(f"✅ Persona ID {id_persona} eliminada lógicamente.")
    except mysql.connector.Error as e:
        print("❌ Error persona_borrado_logico:", e)
        if cnx and cnx.is_connected():
            cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


# ---------- USUARIO ----------
def usuario_insertar(id_persona, id_rol, id_comuna, contraseña):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_usuario_insertar", [id_persona, id_rol, id_comuna, contraseña])
        cnx.commit()
        print("✅ Usuario insertado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error usuario_insertar:", e)
        if cnx and cnx.is_connected(): cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def usuario_listar():
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("CALL sp_usuario_listar()")
        filas = cur.fetchall()
        print("=== USUARIOS ACTIVOS ===")
        for fila in filas:
            print(f"ID:{fila[0]} | Nombre:{fila[1]} {fila[2]} | Rol:{fila[3]} | Comuna:{fila[4]}")
    except mysql.connector.Error as e:
        print("❌ Error usuario_listar:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def usuario_borrado_logico(id_usuario):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_usuario_borrado_logico", [id_usuario])
        cnx.commit()
        print(f"✅ Usuario ID {id_usuario} eliminado lógicamente.")
    except mysql.connector.Error as e:
        print("❌ Error usuario_borrado_logico:", e)
        if cnx and cnx.is_connected(): cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


# ---------- RUTA CICLOVÍA ----------
def ruta_insertar(nombre_ruta, descripcion, id_comuna, estado):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_ruta_insertar", [nombre_ruta, descripcion, id_comuna, estado])
        cnx.commit()
        print("✅ Ruta insertada correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error ruta_insertar:", e)
        if cnx and cnx.is_connected(): cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def ruta_listar():
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("CALL sp_ruta_listar()")
        filas = cur.fetchall()
        print("=== RUTAS ACTIVAS ===")
        for fila in filas:
            print(f"ID:{fila[0]} | Ruta:{fila[1]} | Comuna:{fila[2]} | Estado:{fila[3]}")
    except mysql.connector.Error as e:
        print("❌ Error ruta_listar:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def ruta_borrado_logico(id_ruta):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_ruta_borrado_logico", [id_ruta])
        cnx.commit()
        print(f"✅ Ruta ID {id_ruta} eliminada lógicamente.")
    except mysql.connector.Error as e:
        print("❌ Error ruta_borrado_logico:", e)
        if cnx and cnx.is_connected(): cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


# ---------- REPORTE ----------
def reporte_insertar(id_usuario, id_ruta, tipo_reporte, detalle):
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.callproc("sp_reporte_insertar", [id_usuario, id_ruta, tipo_reporte, detalle])
        cnx.commit()
        print("✅ Reporte insertado correctamente.")
    except mysql.connector.Error as e:
        print("❌ Error reporte_insertar:", e)
        if cnx and cnx.is_connected(): cnx.rollback()
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()

def reporte_listar():
    cnx = cur = None
    try:
        cnx = conectar()
        cur = cnx.cursor()
        cur.execute("CALL sp_reporte_listar()")
        filas = cur.fetchall()
        print("=== REPORTES ===")
        for fila in filas:
            print(f"ID:{fila[0]} | Usuario:{fila[1]} | Ruta:{fila[2]} | Tipo:{fila[3]} | Fecha:{fila[4]}")
    except mysql.connector.Error as e:
        print("❌ Error reporte_listar:", e)
    finally:
        if cur: cur.close()
        if cnx and cnx.is_connected(): cnx.close()


# ==========================================
# MENÚ PRINCIPAL
# ==========================================
def menu():
    while True:
        print("\n===== MENÚ CICLOVÍAS (MySQL + SP) =====")
        print("1) Insertar Persona")
        print("2) Listar Personas")
        print("3) Borrado lógico Persona")
        print("4) Insertar Usuario")
        print("5) Listar Usuarios")
        print("6) Borrado lógico Usuario")
        print("7) Insertar Ruta")
        print("8) Listar Rutas")
        print("9) Borrado lógico Ruta")
        print("10) Insertar Reporte")
        print("11) Listar Reportes")
        print("0) Salir")

        opcion = input("Selecciona una opción: ").strip()

        if opcion == "1":
            rut = input("RUT: ").strip()
            nombre = input("Nombre: ").strip()
            apellido = input("Apellido: ").strip()
            correo = input("Correo: ").strip()
            telefono = input("Teléfono: ").strip()
            persona_insertar(rut, nombre, apellido, correo, telefono)
        elif opcion == "2":
            persona_listar()
        elif opcion == "3":
            try: pid = int(input("ID Persona a eliminar: "))
            except: print("ID inválido"); continue
            persona_borrado_logico(pid)
        elif opcion == "4":
            try:
                pid = int(input("ID Persona: "))
                rid = int(input("ID Rol: "))
                cid = int(input("ID Comuna: "))
            except: print("ID inválido"); continue
            contraseña = input("Contraseña: ").strip()
            usuario_insertar(pid, rid, cid, contraseña)
        elif opcion == "5":
            usuario_listar()
        elif opcion == "6":
            try: uid = int(input("ID Usuario a eliminar: "))
            except: print("ID inválido"); continue
            usuario_borrado_logico(uid)
        elif opcion == "7":
            nombre_ruta = input("Nombre Ruta: ").strip()
            descripcion = input("Descripción: ").strip()
            try: cid = int(input("ID Comuna: "))
            except: print("ID inválido"); continue
            estado = input("Estado (Activa/Inactiva): ").strip()
            ruta_insertar(nombre_ruta, descripcion, cid, estado)
        elif opcion == "8":
            ruta_listar()
        elif opcion == "9":
            try: rid = int(input("ID Ruta a eliminar: "))
            except: print("ID inválido"); continue
            ruta_borrado_logico(rid)
        elif opcion == "10":
            try:
                uid = int(input("ID Usuario: "))
                rid = int(input("ID Ruta: "))
            except: print("ID inválido"); continue
            tipo = input("Tipo Reporte (Accidente/Problema/Cambio Contraseña/Inicio Sesion): ").strip()
            detalle = input("Detalle: ").strip()
            reporte_insertar(uid, rid, tipo, detalle)
        elif opcion == "11":
            reporte_listar()
        elif opcion == "0":
            print("Saliendo del sistema...")
            break
        else:
            print("Opción inválida, intenta nuevamente.")

# Punto de entrada
if __name__ == "__main__":
    menu()
