"""
Configuración de la aplicación Flask y conexión a la base de datos.
Este módulo centraliza las configuraciones del backend.
"""

import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

class Config:
    # Configuración de la base de datos PostgreSQL
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost/odonto_erp')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Clave secreta para sesiones y tokens
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    
    # Configuración CORS para desarrollo
    CORS_HEADERS = 'Content-Type'
