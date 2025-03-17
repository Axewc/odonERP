-- init.sql
-- Database initialization script for odontoERP

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS odonto_erp;

-- Connect to the database
\c odonto_erp;

-- Create usuarios table
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add comments for educational purposes
COMMENT ON TABLE usuarios IS 'Tabla para almacenar información de usuarios del sistema';
COMMENT ON COLUMN usuarios.id IS 'Identificador único del usuario (auto-incrementable)';
COMMENT ON COLUMN usuarios.nombre IS 'Nombre completo del usuario';
COMMENT ON COLUMN usuarios.email IS 'Correo electrónico (único) usado para login';
COMMENT ON COLUMN usuarios.contraseña IS 'Contraseña hasheada usando bcrypt';
COMMENT ON COLUMN usuarios.fecha_registro IS 'Fecha y hora de registro del usuario';
