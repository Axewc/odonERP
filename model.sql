-- 🏥 Tabla de Sucursales
-- Cada doctor e inventario pertenece a una sucursal.

CREATE TABLE sucursales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL
);
-- 👨‍⚕️ Tabla de Doctores
-- Se elimina la columna especialidad porque ahora se gestiona en la tabla doctor_especialidad.

CREATE TABLE doctores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sucursal_id INT REFERENCES sucursales(id)
);
-- 📋 Tabla de Especialidades
-- Lista todas las especialidades médicas disponibles.

CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);
-- 🔗 Relación Doctor - Especialidad
-- Define la relación muchos a muchos entre doctores y especialidades.

CREATE TABLE doctor_especialidad (
    doctor_id INT REFERENCES doctores(id) ON DELETE CASCADE,
    especialidad_id INT REFERENCES especialidades(id) ON DELETE CASCADE,
    PRIMARY KEY (doctor_id, especialidad_id)
);
-- 🧑‍⚕️ Tabla de Pacientes
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);
-- 📅 Tabla de Citas
CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctores(id) ON DELETE SET NULL,
    fecha TIMESTAMP NOT NULL
);
-- 💰 Tabla de Facturación
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    fecha TIMESTAMP DEFAULT current_timestamp,
    total DECIMAL(10,2) CHECK (total >= 0),
    estado_pago VARCHAR(50) CHECK (estado_pago IN ('pendiente', 'pagado')) DEFAULT 'pendiente'
);
-- 📦 Tabla de Inventarios
CREATE TABLE inventarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad INT CHECK (cantidad >= 0),
    precio DECIMAL(10,2) CHECK (precio >= 0),
    controlado BOOLEAN DEFAULT FALSE,
    sucursal_id INT REFERENCES sucursales(id) ON DELETE CASCADE
);
-- 📊 Movimientos de Inventario
CREATE TABLE movimientos_inventario (
    id SERIAL PRIMARY KEY,
    inventario_id INT REFERENCES inventarios(id) ON DELETE CASCADE,
    cantidad INT NOT NULL,
    tipo_movimiento VARCHAR(50) CHECK (tipo_movimiento IN ('entrada', 'salida')),
    fecha TIMESTAMP DEFAULT current_timestamp
);
-- 💊 Tabla de Recetas Médicas
CREATE TABLE recetas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctores(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT current_timestamp
);
-- 📑 Tabla de Historia Clínica
CREATE TABLE historia_clinica (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctores(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT current_timestamp,
    diagnostico TEXT,
    tratamiento TEXT
);
-- 💉 Administración de Medicamentos
CREATE TABLE administracion_medicamentos (
    id SERIAL PRIMARY KEY,
    receta_id INT REFERENCES recetas(id) ON DELETE CASCADE,
    inventario_id INT REFERENCES inventarios(id) ON DELETE SET NULL,
    doctor_id INT REFERENCES doctores(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT current_timestamp,
    cantidad INT CHECK (cantidad > 0)
);