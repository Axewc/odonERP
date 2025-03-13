# **Manual de Desarrollo - ERP para Clínicas y Consultorios (MVP)**

[odonERP](https://github.com/axew/odonERP)

## **Introducción**

Este manual detalla las especificaciones técnicas para el desarrollo del MVP (Minimum Viable Product) del ERP para clínicas y consultorios. El sistema se desarrollará como una aplicación web que operará inicialmente en entorno local, con un enfoque en las funcionalidades críticas para la gestión médica.

## **Stack Tecnológico**

### **Base de Datos: PostgreSQL 15**

- **Justificación**: Seleccionado por su robustez, soporte para transacciones ACID y capacidades avanzadas de indexación y particionamiento.
- **Configuración**: Instalación local con esquemas separados para datos médicos, facturación y seguridad.
- **Extensiones requeridas**:
  - `pgcrypto` para cifrado de datos sensibles de pacientes
  - `pg_stat_statements` para análisis de rendimiento de consultas

### **Backend: Python 3.11 + Flask 2.3.x + SQLAlchemy 2.0.x**

- **Justificación**: Flask proporciona un framework liviano y fácil de configurar, ideal para un MVP. SQLAlchemy ofrece un ORM potente para interactuar con PostgreSQL.
- **Componentes clave**:
  - Flask-RESTful para estructurar la API
  - Flask-SQLAlchemy como integración ORM
  - Flask-Migrate (Alembic) para migraciones de base de datos
  - Flask-JWT-Extended para autenticación basada en tokens
  - Flask-Marshmallow para serialización/deserialización
  - psycopg2-binary como driver de conexión a PostgreSQL

### **Frontend: React 18.x**

- **Justificación**: Biblioteca eficiente para construcción de interfaces con componentes reutilizables.
- **Bibliotecas principales**:
  - React Router 6.x para navegación
  - Axios para comunicación con la API
  - React Hook Form para manejo de formularios
  - Recharts para visualizaciones básicas
  - Material-UI como sistema de diseño

## **Estructura del Proyecto**

### **Estructura de Carpetas Backend**

```
backend/
├── app/                      # Código principal de la aplicación
│   ├── __init__.py           # Inicialización de Flask
│   ├── models/               # Modelos SQLAlchemy
│   │   ├── __init__.py
│   │   ├── paciente.py
│   │   ├── medico.py
│   │   ├── cita.py
│   │   ├── historial.py
│   │   └── ...
│   ├── routes/               # Rutas de la API
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── pacientes.py
│   │   ├── citas.py
│   │   └── ...
│   ├── schemas/              # Esquemas de Marshmallow
│   │   ├── __init__.py
│   │   ├── paciente.py
│   │   ├── cita.py
│   │   └── ...
│   ├── services/             # Lógica de negocio
│   │   ├── __init__.py
│   │   ├── citas_service.py
│   │   ├── reportes_service.py
│   │   └── ...
│   └── utils/                # Utilidades
│       ├── __init__.py
│       ├── auth.py           # Funciones para autenticación
│       └── helpers.py        # Funciones auxiliares
├── config.py                 # Configuración del entorno
├── migrations/               # Migraciones de base de datos
├── tests/                    # Tests unitarios
├── requirements.txt          # Dependencias
└── run.py                    # Punto de entrada
```

### **Estructura de Carpetas Frontend**

```
frontend/
├── public/                   # Archivos estáticos
│   └── index.html
├── src/
│   ├── components/           # Componentes React
│   │   ├── common/           # Componentes reutilizables
│   │   ├── pacientes/        # Componentes específicos de pacientes
│   │   ├── citas/            # Componentes específicos de citas
│   │   └── ...
│   ├── services/             # Servicios de API
│   │   ├── api.js            # Configuración de Axios
│   │   ├── authService.js
│   │   ├── pacientesService.js
│   │   └── ...
│   ├── pages/                # Páginas/Vistas
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   ├── Pacientes.jsx
│   │   └── ...
│   ├── App.jsx               # Componente principal
│   ├── index.jsx             # Punto de entrada
│   └── config.js             # Configuración
├── package.json              # Dependencias
└── README.md                 # Documentación
```

## **Modelos de Base de Datos (MVP)**

Para el MVP, nos enfocaremos en las siguientes tablas principales:

```sql
-- Esquema para datos médicos
CREATE SCHEMA medical;
-- Esquema para facturación
CREATE SCHEMA billing;
-- Esquema para seguridad
CREATE SCHEMA security;

-- Tabla de sucursales/clínicas
CREATE TABLE medical.sucursales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de especialidades médicas
CREATE TABLE medical.especialidades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de pacientes
CREATE TABLE medical.pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(20),
    tipo_documento VARCHAR(20),
    numero_documento VARCHAR(20),
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    direccion TEXT,
    alergias TEXT,
    contacto_emergencia_nombre VARCHAR(200),
    contacto_emergencia_telefono VARCHAR(15),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT true
);

-- Tabla de médicos
CREATE TABLE medical.medicos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES security.usuarios(id),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    especialidad_id INTEGER REFERENCES medical.especialidades(id),
    activo BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de horarios de médicos
CREATE TABLE medical.horarios_medicos (
    id SERIAL PRIMARY KEY,
    medico_id INTEGER REFERENCES medical.medicos(id),
    sucursal_id INTEGER REFERENCES medical.sucursales(id),
    dia_semana SMALLINT NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    intervalo_citas INTEGER NOT NULL DEFAULT 30, -- minutos
    CONSTRAINT horario_valido CHECK (hora_fin > hora_inicio)
);

-- Tabla de estados de citas
CREATE TABLE medical.estados_cita (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla de citas
CREATE TABLE medical.citas (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER REFERENCES medical.pacientes(id),
    medico_id INTEGER REFERENCES medical.medicos(id),
    sucursal_id INTEGER REFERENCES medical.sucursales(id),
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado_id INTEGER REFERENCES medical.estados_cita(id),
    motivo TEXT,
    notas TEXT,
    creado_por INTEGER REFERENCES security.usuarios(id),
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de historial médico
CREATE TABLE medical.historial_medico (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER REFERENCES medical.pacientes(id),
    cita_id INTEGER REFERENCES medical.citas(id),
    medico_id INTEGER REFERENCES medical.medicos(id),
    fecha TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    creado_por INTEGER REFERENCES security.usuarios(id)
);

-- Tabla de roles de usuario
CREATE TABLE security.roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de usuarios
CREATE TABLE security.usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol_id INTEGER REFERENCES security.roles(id),
    sucursal_id INTEGER REFERENCES medical.sucursales(id),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de servicios (para facturación)
CREATE TABLE billing.servicios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    impuesto_porcentaje DECIMAL(5,2) DEFAULT 0.00,
    activo BOOLEAN DEFAULT true
);

-- Tabla de facturas
CREATE TABLE billing.facturas (
    id SERIAL PRIMARY KEY,
    numero_factura VARCHAR(20) UNIQUE NOT NULL,
    paciente_id INTEGER REFERENCES medical.pacientes(id),
    cita_id INTEGER REFERENCES medical.citas(id),
    fecha_emision TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL,
    impuesto DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL, -- 'pendiente', 'pagada', 'anulada'
    creado_por INTEGER REFERENCES security.usuarios(id)
);

-- Tabla de detalle de factura
CREATE TABLE billing.detalle_factura (
    id SERIAL PRIMARY KEY,
    factura_id INTEGER REFERENCES billing.facturas(id),
    servicio_id INTEGER REFERENCES billing.servicios(id),
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);

-- Datos iniciales para estados de cita
INSERT INTO medical.estados_cita (nombre, descripcion) VALUES 
('Nueva', 'Cita recién agendada'),
('Confirmada', 'Cita confirmada por el paciente'),
('En Espera', 'Paciente en sala de espera'),
('Completada', 'Consulta finalizada'),
('Cancelada', 'Cita cancelada');

-- Datos iniciales para roles
INSERT INTO security.roles (nombre, descripcion) VALUES 
('Administrador', 'Acceso completo al sistema'),
('Médico', 'Acceso a módulos médicos y consultas'),
('Recepcionista', 'Gestión de citas y pacientes'),
('Facturación', 'Acceso a módulos de facturación');

-- Índices para consultas frecuentes
CREATE INDEX idx_pacientes_nombre_apellido ON medical.pacientes(nombre, apellido);
CREATE INDEX idx_citas_fecha ON medical.citas(fecha);
CREATE INDEX idx_citas_medico ON medical.citas(medico_id);
CREATE INDEX idx_citas_paciente ON medical.citas(paciente_id);

```

## **Modelos SQLAlchemy**

Implementación de los modelos principales con SQLAlchemy:

```python
# app/models/__init__.py
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# app/models/usuario.py
from werkzeug.security import generate_password_hash, check_password_hash
from app.models import db
from datetime import datetime

class Usuario(db.Model):
    __tablename__ = 'usuarios'
    __table_args__ = {'schema': 'security'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    apellido = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    rol_id = db.Column(db.Integer, db.ForeignKey('security.roles.id'))
    sucursal_id = db.Column(db.Integer, db.ForeignKey('medical.sucursales.id'))
    activo = db.Column(db.Boolean, default=True)
    fecha_creacion = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    
    # Relaciones
    rol = db.relationship('Rol', backref='usuarios')
    sucursal = db.relationship('Sucursal', backref='usuarios')
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
        
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

class Rol(db.Model):
    __tablename__ = 'roles'
    __table_args__ = {'schema': 'security'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), unique=True, nullable=False)
    descripcion = db.Column(db.Text)

# app/models/sucursal.py
from app.models import db
from datetime import datetime

class Sucursal(db.Model):
    __tablename__ = 'sucursales'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    direccion = db.Column(db.Text, nullable=False)
    telefono = db.Column(db.String(15))
    email = db.Column(db.String(100))
    activo = db.Column(db.Boolean, default=True)
    fecha_creacion = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

# app/models/paciente.py
from app.models import db
from datetime import datetime

class Paciente(db.Model):
    __tablename__ = 'pacientes'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    apellido = db.Column(db.String(100), nullable=False)
    fecha_nacimiento = db.Column(db.Date, nullable=False)
    genero = db.Column(db.String(20))
    tipo_documento = db.Column(db.String(20))
    numero_documento = db.Column(db.String(20))
    telefono = db.Column(db.String(15))
    email = db.Column(db.String(100), unique=True)
    direccion = db.Column(db.Text)
    alergias = db.Column(db.Text)
    contacto_emergencia_nombre = db.Column(db.String(200))
    contacto_emergencia_telefono = db.Column(db.String(15))
    fecha_registro = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    activo = db.Column(db.Boolean, default=True)
    
    # Relaciones
    citas = db.relationship('Cita', backref='paciente', lazy='dynamic')
    historial = db.relationship('HistorialMedico', backref='paciente', lazy='dynamic')
    facturas = db.relationship('Factura', backref='paciente', lazy='dynamic')

# app/models/especialidad.py
from app.models import db

class Especialidad(db.Model):
    __tablename__ = 'especialidades'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), unique=True, nullable=False)
    descripcion = db.Column(db.Text)
    
    # Relaciones
    medicos = db.relationship('Medico', backref='especialidad', lazy='dynamic')

# app/models/medico.py
from app.models import db
from datetime import datetime

class Medico(db.Model):
    __tablename__ = 'medicos'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('security.usuarios.id'))
    nombre = db.Column(db.String(100), nullable=False)
    apellido = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True)
    telefono = db.Column(db.String(15))
    especialidad_id = db.Column(db.Integer, db.ForeignKey('medical.especialidades.id'))
    activo = db.Column(db.Boolean, default=True)
    fecha_registro = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    
    # Relaciones
    usuario = db.relationship('Usuario', backref='medico_perfil', uselist=False)
    horarios = db.relationship('HorarioMedico', backref='medico', lazy='dynamic')
    citas = db.relationship('Cita', backref='medico', lazy='dynamic')
    historial = db.relationship('HistorialMedico', backref='medico', lazy='dynamic')

class HorarioMedico(db.Model):
    __tablename__ = 'horarios_medicos'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    medico_id = db.Column(db.Integer, db.ForeignKey('medical.medicos.id'))
    sucursal_id = db.Column(db.Integer, db.ForeignKey('medical.sucursales.id'))
    dia_semana = db.Column(db.Integer, nullable=False)  # 1=Lunes, 7=Domingo
    hora_inicio = db.Column(db.Time, nullable=False)
    hora_fin = db.Column(db.Time, nullable=False)
    intervalo_citas = db.Column(db.Integer, default=30)  # minutos
    
    # Relaciones
    sucursal = db.relationship('Sucursal', backref='horarios_medicos')

# app/models/cita.py
from app.models import db
from datetime import datetime

class EstadoCita(db.Model):
    __tablename__ = 'estados_cita'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), unique=True, nullable=False)
    descripcion = db.Column(db.Text)
    
    # Relaciones
    citas = db.relationship('Cita', backref='estado', lazy='dynamic')

class Cita(db.Model):
    __tablename__ = 'citas'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    paciente_id = db.Column(db.Integer, db.ForeignKey('medical.pacientes.id'))
    medico_id = db.Column(db.Integer, db.ForeignKey('medical.medicos.id'))
    sucursal_id = db.Column(db.Integer, db.ForeignKey('medical.sucursales.id'))
    fecha = db.Column(db.Date, nullable=False)
    hora_inicio = db.Column(db.Time, nullable=False)
    hora_fin = db.Column(db.Time, nullable=False)
    estado_id = db.Column(db.Integer, db.ForeignKey('medical.estados_cita.id'))
    motivo = db.Column(db.Text)
    notas = db.Column(db.Text)
    creado_por = db.Column(db.Integer, db.ForeignKey('security.usuarios.id'))
    fecha_creacion = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    
    # Relaciones
    sucursal = db.relationship('Sucursal', backref='citas')
    usuario_creador = db.relationship('Usuario', backref='citas_creadas')
    historial = db.relationship('HistorialMedico', backref='cita', uselist=False)
    factura = db.relationship('Factura', backref='cita', uselist=False)

# app/models/historial.py
from app.models import db
from datetime import datetime

class HistorialMedico(db.Model):
    __tablename__ = 'historial_medico'
    __table_args__ = {'schema': 'medical'}
    
    id = db.Column(db.Integer, primary_key=True)
    paciente_id = db.Column(db.Integer, db.ForeignKey('medical.pacientes.id'))
    cita_id = db.Column(db.Integer, db.ForeignKey('medical.citas.id'))
    medico_id = db.Column(db.Integer, db.ForeignKey('medical.medicos.id'))
    fecha = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    diagnostico = db.Column(db.Text)
    tratamiento = db.Column(db.Text)
    observaciones = db.Column(db.Text)
    creado_por = db.Column(db.Integer, db.ForeignKey('security.usuarios.id'))
    
    # Relaciones
    usuario_creador = db.relationship('Usuario', backref='historiales_creados')

# app/models/facturacion.py
from app.models import db
from datetime import datetime

class Servicio(db.Model):
    __tablename__ = 'servicios'
    __table_args__ = {'schema': 'billing'}
    
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(200), nullable=False)
    descripcion = db.Column(db.Text)
    precio = db.Column(db.Numeric(10, 2), nullable=False)
    impuesto_porcentaje = db.Column(db.Numeric(5, 2), default=0)
    activo = db.Column(db.Boolean, default=True)
    
    # Relaciones
    detalles = db.relationship('DetalleFactura', backref='servicio', lazy='dynamic')

class Factura(db.Model):
    __tablename__ = 'facturas'
    __table_args__ = {'schema': 'billing'}
    
    id = db.Column(db.Integer, primary_key=True)
    numero_factura = db.Column(db.String(20), unique=True, nullable=False)
    paciente_id = db.Column(db.Integer, db.ForeignKey('medical.pacientes.id'))
    cita_id = db.Column(db.Integer, db.ForeignKey('medical.citas.id'))
    fecha_emision = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    subtotal = db.Column(db.Numeric(10, 2), nullable=False)
    impuesto = db.Column(db.Numeric(10, 2), default=0)
    total = db.Column(db.Numeric(10, 2), nullable=False)
    estado = db.Column(db.String(20), nullable=False)  # 'pendiente', 'pagada', 'anulada'
    creado_por = db.Column(db.Integer, db.ForeignKey('security.usuarios.id'))
    
    # Relaciones
    detalles = db.relationship('DetalleFactura', backref='factura', lazy='dynamic')
    usuario_creador = db.relationship('Usuario', backref='facturas_creadas')

class DetalleFactura(db.Model):
    __tablename__ = 'detalle_factura'
    __table_args__ = {'schema': 'billing'}
    
    id = db.Column(db.Integer, primary_key=True)
    factura_id = db.Column(db.Integer, db.ForeignKey('billing.facturas.id'))
    servicio_id = db.Column(db.Integer, db.ForeignKey('billing.servicios.id'))
    cantidad = db.Column(db.Integer, default=1)
    precio_unitario = db.Column(db.Numeric(10, 2), nullable=False)
    subtotal = db.Column(db.Numeric(10, 2), nullable=False)

```

## **Configuración de Flask y SQLAlchemy**

```python
# config.py
import os
from datetime import timedelta

class Config:
    # Configuración base
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'clave-secreta-desarrollo'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # JWT Config
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or 'jwt-clave-secreta-desarrollo'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=1)
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=30)
    
    # Otros ajustes generales
    ITEMS_PER_PAGE = 20
    
    @staticmethod
    def init_app(app):
        pass

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('DEV_DATABASE_URL') or \
        'postgresql://postgres:postgres@localhost/clinica_erp_dev'

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URL') or \
        'postgresql://postgres:postgres@localhost/clinica_erp_test'

class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'postgresql://postgres:postgres@localhost/clinica_erp'

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}

# app/__init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_marshmallow import Marshmallow
from flask_jwt_extended import JWTManager
from config import config

db = SQLAlchemy()
migrate = Migrate()
ma = Marshmallow()
jwt = JWTManager()

def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)
    
    # Inicializar extensiones
    db.init_app(app)
    migrate.init_app(app, db)
    ma.init_app(app)
    jwt.init_app(app)
    
    # Registrar blueprints
    from app.routes import auth_bp, pacientes_bp, citas_bp, medicos_bp, historial_bp, facturacion_bp
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(pacientes_bp, url_prefix='/api/pacientes')
    app.register_blueprint(citas_bp, url_prefix='/api/citas')
    app.register_blueprint(medicos_bp, url_prefix='/api/medicos')
    app.register_blueprint(historial_bp, url_prefix='/api/historial')
    app.register_blueprint(facturacion_bp, url_prefix='/api/facturacion')
    
    return app

# run.py
import os
from app import create_app, db
from app.models import Usuario, Rol, Paciente, Medico, Cita

app = create_app(os.getenv('FLASK_CONFIG') or 'default')

@app.shell_context_processor
def make_shell_context():
    return dict(
        db=db, 
        Usuario=Usuario, 
        Rol=Rol, 
        Paciente=Paciente,
        Medico=Medico,
        Cita=Cita
    )

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

```

## **Implementación de Rutas de API**

Ejemplo de implementación de rutas para el módulo de citas:

```python
# app/routes/citas.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from marshmallow import ValidationError
from sqlalchemy import and_
from datetime import datetime, time

from app.models import db, Cita, Medico, Paciente, Usuario, EstadoCita, HorarioMedico
from app.schemas.cita import cita_schema, citas_schema, cita_create_schema
from app.utils.auth import admin_required, role_required
from app.services.citas_service import check_disponibilidad_medico

citas_bp = Blueprint('citas', __name__)

@citas_bp.route('/', methods=['GET'])
@jwt_required()
def get_citas():
    """Obtener listado de citas con filtros opcionales"""
    # Parámetros de filtrado
    fecha_desde = request.args.get('fecha_desde')
    fecha_hasta = request.args.get('fecha_hasta')
    medico_id = request.args.get('medico_id', type=int)
    paciente_id = request.args.get('paciente_id', type=int)
    estado_id = request.args.get('estado_id', type=int)
    
    # Paginación
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    
    # Construir query base
    query = Cita.query
    
    # Aplicar filtros
    if fecha_desde:
        query = query.filter(Cita.fecha >= datetime.strptime(fecha_desde, '%Y-%m-%d').date())
    
```
