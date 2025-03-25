-- Tabla de Sucursales
CREATE TABLE sucursales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL
);

-- Tabla de Pacientes
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

-- Tabla de Doctores
CREATE TABLE doctores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    sucursal_id INT REFERENCES sucursales(id)
);

-- Tabla de Citas
CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id),
    doctor_id INT REFERENCES doctores(id),
    fecha TIMESTAMP NOT NULL
);

-- Tabla de Facturación
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id),
    fecha TIMESTAMP DEFAULT current_timestamp,
    total DECIMAL(10,2) CHECK (total >= 0),
    estado_pago VARCHAR(50) CHECK (estado_pago IN ('pendiente', 'pagado')) DEFAULT 'pendiente'
);

-- Tabla de Inventarios
CREATE TABLE inventarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad INT CHECK (cantidad >= 0),
    precio DECIMAL(10,2) CHECK (precio >= 0),
    controlado BOOLEAN DEFAULT FALSE,
    sucursal_id INT REFERENCES sucursales(id)
);

-- Movimientos de Inventario
CREATE TABLE movimientos_inventario (
    id SERIAL PRIMARY KEY,
    inventario_id INT REFERENCES inventarios(id),
    cantidad INT NOT NULL,
    tipo_movimiento VARCHAR(50) CHECK (tipo_movimiento IN ('entrada', 'salida')),
    fecha TIMESTAMP DEFAULT current_timestamp
);

-- Tabla de Recetas Médicas
CREATE TABLE recetas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id),
    doctor_id INT REFERENCES doctores(id),
    fecha TIMESTAMP DEFAULT current_timestamp
);

-- Tabla de Historia Clínica
CREATE TABLE historia_clinica (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id),
    doctor_id INT REFERENCES doctores(id),
    fecha TIMESTAMP DEFAULT current_timestamp,
    diagnostico TEXT,
    tratamiento TEXT
);

-- Registro de Administración de Medicamentos
CREATE TABLE administracion_medicamentos (
    id SERIAL PRIMARY KEY,
    receta_id INT REFERENCES recetas(id),
    inventario_id INT REFERENCES inventarios(id),
    doctor_id INT REFERENCES doctores(id),
    fecha TIMESTAMP DEFAULT current_timestamp,
    cantidad INT CHECK (cantidad > 0)
);