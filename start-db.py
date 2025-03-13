# db_init.py
import os
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from psycopg2 import sql
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate, MigrateCommand
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Configuración de la conexión a PostgreSQL
DB_NAME = "clinica_erp_dev"
DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_HOST = "localhost"
DB_PORT = "5432"

def create_database():
    """Crear la base de datos si no existe"""
    try:
        # Conectar a postgres para poder crear base de datos
        conn = psycopg2.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT,
            database="postgres"
        )
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        
        # Verificar si la base de datos ya existe
        cursor.execute("SELECT 1 FROM pg_catalog.pg_database WHERE datname = %s", (DB_NAME,))
        exists = cursor.fetchone()
        
        if not exists:
            cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(DB_NAME)))
            logger.info(f"Base de datos {DB_NAME} creada exitosamente")
        else:
            logger.info(f"La base de datos {DB_NAME} ya existe")
            
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        logger.error(f"Error al crear la base de datos: {e}")
        return False

def execute_sql_script(sql_file_path):
    """Ejecutar script SQL en la base de datos"""
    try:
        conn = psycopg2.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME
        )
        cursor = conn.cursor()
        
        # Leer el archivo SQL
        with open(sql_file_path, 'r') as file:
            sql_script = file.read()
        
        # Ejecutar el script
        cursor.execute(sql_script)
        conn.commit()
        
        cursor.close()
        conn.close()
        logger.info(f"Script SQL ejecutado exitosamente: {sql_file_path}")
        return True
    except Exception as e:
        logger.error(f"Error al ejecutar script SQL: {e}")
        return False

def init_flask_migrations():
    """Inicializar Flask y las migraciones"""
    try:
        # Crear aplicación Flask básica para migraciones
        app = Flask(__name__)
        app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
        app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
        
        # Inicializar SQLAlchemy y Migrate
        db = SQLAlchemy(app)
        migrate = Migrate(app, db)
        
        # Importar modelos después de inicializar db para que sean reconocidos
        # (Ajusta la ruta de importación según la estructura de tu proyecto)
        sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
        from app.models.usuario import Usuario, Rol
        from app.models.paciente import Paciente
        from app.models.medico import Medico, HorarioMedico
        from app.models.cita import Cita, EstadoCita
        from app.models.historial import HistorialMedico
        from app.models.facturacion import Servicio, Factura, DetalleFactura
        
        # Configurar el contexto de la aplicación
        with app.app_context():
            # Crear todas las tablas si no existen
            db.create_all()
            logger.info("Estructura de base de datos creada con Flask-SQLAlchemy")
            
            # Si quieres utilizar Alembic (Flask-Migrate) para gestionar migraciones
            os.system('flask db init')  # Inicializa la estructura de migraciones
            os.system('flask db migrate -m "Estructura inicial de la base de datos"')  # Crea la migración inicial
            os.system('flask db upgrade')  # Aplica la migración
            
        return True
    except Exception as e:
        logger.error(f"Error al inicializar Flask y migraciones: {e}")
        return False

if __name__ == "__main__":
    logger.info("Iniciando configuración de la base de datos...")
    
    # 1. Crear la base de datos
    if create_database():
        # 2. Ejecutar el script SQL principal
        sql_script_path = "database-setup-script.sql"  # Ajusta la ruta según sea necesario
        if os.path.exists(sql_script_path):
            execute_sql_script(sql_script_path)
        else:
            logger.error(f"El archivo {sql_script_path} no existe")
        
        # 3. Inicializar Flask y migraciones (opcional - depende de tu enfoque)
        # Comentar esta parte si prefieres utilizar solo SQL puro
        # init_flask_migrations()
    
    logger.info("Proceso de configuración de base de datos completado")