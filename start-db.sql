-- Script de configuración de base de datos para odonERP
-- Este script crea los esquemas, tablas, relaciones, índices y datos iniciales

-- Conectarse a la base de datos (ejecutar esto antes si estás en psql)
-- \c clinica_erp_dev

-- Eliminar esquemas si existen (para reinstalación limpia)
DROP SCHEMA IF EXISTS medical CASCADE;
DROP SCHEMA IF EXISTS billing CASCADE;
DROP SCHEMA IF EXISTS security CASCADE;

-- Crear esquemas
CREATE SCHEMA medical;
CREATE SCHEMA billing;
CREATE SCHEMA security;

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- ESQUEMA SECURITY --

-- Tabla de roles de usuario
CREATE TABLE security.roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de sucursales/clínicas (se crea primero porque es referenciada por usuarios)
CREATE TABLE medical.sucursales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
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

-- ESQUEMA MEDICAL --

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

-- ESQUEMA BILLING --

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

-- Crear índices para mejorar el rendimiento de consultas frecuentes
CREATE INDEX idx_pacientes_nombre_apellido ON medical.pacientes(nombre, apellido);
CREATE INDEX idx_citas_fecha ON medical.citas(fecha);
CREATE INDEX idx_citas_medico ON medical.citas(medico_id);
CREATE INDEX idx_citas_paciente ON medical.citas(paciente_id);
CREATE INDEX idx_historial_paciente ON medical.historial_medico(paciente_id);
CREATE INDEX idx_facturas_paciente ON billing.facturas(paciente_id);
CREATE INDEX idx_facturas_estado ON billing.facturas(estado);

-- Insertar datos iniciales

-- Roles de usuario
INSERT INTO security.roles (nombre, descripcion) VALUES 
('Administrador', 'Acceso completo al sistema'),
('Médico', 'Acceso a módulos médicos y consultas'),
('Recepcionista', 'Gestión de citas y pacientes'),
('Facturación', 'Acceso a módulos de facturación');

-- Sucursal predeterminada
INSERT INTO medical.sucursales (nombre, direccion, telefono, email) VALUES
('Sede Principal', 'Av. Principal 123', '555-1234', 'contacto@clinica.com');

-- Usuario administrador predeterminado (contraseña: admin123)
INSERT INTO security.usuarios (nombre, apellido, email, password_hash, rol_id, sucursal_id) 
VALUES ('Admin', 'Sistema', 'admin@clinica.com', 
        crypt('admin123', gen_salt('bf')), 
        1, 1);

-- Estados de cita
INSERT INTO medical.estados_cita (nombre, descripcion) VALUES 
('Nueva', 'Cita recién agendada'),
('Confirmada', 'Cita confirmada por el paciente'),
('En Espera', 'Paciente en sala de espera'),
('En Consulta', 'Paciente atendido por el médico'),
('Completada', 'Consulta finalizada'),
('Cancelada', 'Cita cancelada');

-- Especialidades médicas comunes
INSERT INTO medical.especialidades (nombre, descripcion) VALUES
('Odontología General', 'Tratamientos dentales básicos y preventivos'),
('Ortodoncia', 'Corrección de la posición dental y maxilar'),
('Endodoncia', 'Tratamiento de conductos y problemas de pulpa dental'),
('Periodoncia', 'Tratamiento de encías y tejidos de soporte'),
('Odontopediatría', 'Atención dental para niños'),
('Cirugía Oral', 'Extracciones y procedimientos quirúrgicos orales'),
('Prostodoncia', 'Prótesis dentales fijas y removibles'),
('Estética Dental', 'Procedimientos para mejorar la apariencia dental');

-- Servicios básicos para facturación
INSERT INTO billing.servicios (nombre, descripcion, precio, impuesto_porcentaje) VALUES
('Consulta inicial', 'Evaluación y diagnóstico inicial', 50.00, 12.00),
('Limpieza dental', 'Profilaxis dental profesional', 75.00, 12.00),
('Radiografía panorámica', 'Imagen completa de mandíbula y dientes', 60.00, 12.00),
('Empaste simple', 'Restauración dental con resina para una superficie', 80.00, 12.00),
('Empaste compuesto', 'Restauración dental con resina para múltiples superficies', 120.00, 12.00),
('Extracción simple', 'Extracción de diente sin complicaciones', 90.00, 12.00),
('Tratamiento de conducto', 'Endodoncia en un conducto', 250.00, 12.00),
('Blanqueamiento dental', 'Procedimiento de blanqueamiento en consultorio', 200.00, 12.00);