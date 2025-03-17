"""
Aplicación principal Flask.
Configura la app, registra las rutas y maneja la autenticación.
"""

from flask import Flask, request, jsonify
from flask_bcrypt import Bcrypt
from flask_cors import CORS
from models import db, Usuario
from config import Config
import re

app = Flask(__name__)
app.config.from_object(Config)

# Inicializar extensiones
db.init_app(app)
bcrypt = Bcrypt(app)
CORS(app)

def validar_email(email):
    """Valida formato de email usando expresión regular."""
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return re.match(pattern, email) is not None

@app.route('/register', methods=['POST'])
def register():
    """
    Endpoint para registrar nuevos usuarios.
    Recibe: nombre, email y contraseña
    Retorna: datos del usuario creado (sin contraseña)
    """
    data = request.get_json()
    
    # Validar datos requeridos
    if not all(k in data for k in ('nombre', 'email', 'contraseña')):
        return jsonify({'error': 'Faltan datos requeridos'}), 400
    
    # Validar formato de email
    if not validar_email(data['email']):
        return jsonify({'error': 'Formato de email inválido'}), 400
    
    # Verificar si el email ya existe
    if Usuario.query.filter_by(email=data['email']).first():
        return jsonify({'error': 'Email ya registrado'}), 409
    
    # Crear nuevo usuario
    hashed_password = bcrypt.generate_password_hash(data['contraseña']).decode('utf-8')
    nuevo_usuario = Usuario(
        nombre=data['nombre'],
        email=data['email'],
        contraseña=hashed_password
    )
    
    try:
        db.session.add(nuevo_usuario)
        db.session.commit()
        return jsonify(nuevo_usuario.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Error al crear usuario'}), 500

@app.route('/login', methods=['POST'])
def login():
    """
    Endpoint para autenticar usuarios.
    Recibe: email y contraseña
    Retorna: datos del usuario (sin contraseña) si la autenticación es exitosa
    """
    data = request.get_json()
    
    # Validar datos requeridos
    if not all(k in data for k in ('email', 'contraseña')):
        return jsonify({'error': 'Faltan datos requeridos'}), 400
    
    # Buscar usuario por email
    usuario = Usuario.query.filter_by(email=data['email']).first()
    if not usuario:
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    # Verificar contraseña
    if not bcrypt.check_password_hash(usuario.contraseña, data['contraseña']):
        return jsonify({'error': 'Contraseña incorrecta'}), 401
    
    return jsonify(usuario.to_dict()), 200

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Crear tablas si no existen
    app.run(debug=True)
