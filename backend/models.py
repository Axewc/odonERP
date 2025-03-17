"""
Modelos SQLAlchemy para la aplicación.
Define la estructura de datos y relaciones en la base de datos.
"""

from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class Usuario(db.Model):
    """
    Modelo de Usuario para la tabla 'usuarios'.
    Representa a los usuarios del sistema con sus credenciales y datos básicos.
    """
    __tablename__ = 'usuarios'

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    contraseña = db.Column(db.String(100), nullable=False)
    fecha_registro = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        """
        Convierte el objeto Usuario a un diccionario para la API.
        Excluye la contraseña por seguridad.
        """
        return {
            'id': self.id,
            'nombre': self.nombre,
            'email': self.email,
            'fecha_registro': self.fecha_registro.isoformat()
        }

    def __repr__(self):
        return f'<Usuario {self.email}>'
