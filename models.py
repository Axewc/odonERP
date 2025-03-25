from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Paciente(db.Model):
    __tablename__ = 'pacientes'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    apellido = db.Column(db.String(100), nullable=False)
    fecha_nacimiento = db.Column(db.Date, nullable=False)

class Sucursal(db.Model):
    __tablename__ = 'sucursales'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    direccion = db.Column(db.Text, nullable=False)

class Doctor(db.Model):
    __tablename__ = 'doctores'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    sucursal_id = db.Column(db.Integer, db.ForeignKey('sucursales.id'))
    
    # Relación con especialidades (Muchos a Muchos)
    especialidades = db.relationship('Especialidad', secondary='doctor_especialidad', back_populates='doctores')

class Especialidad(db.Model):
    __tablename__ = 'especialidades'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False, unique=True)

    # Relación con doctores
    doctores = db.relationship('Doctor', secondary='doctor_especialidad', back_populates='especialidades')

# Tabla intermedia para la relación N:M entre doctores y especialidades
doctor_especialidad = db.Table('doctor_especialidad',
    db.Column('doctor_id', db.Integer, db.ForeignKey('doctores.id'), primary_key=True),
    db.Column('especialidad_id', db.Integer, db.ForeignKey('especialidades.id'), primary_key=True)
)
