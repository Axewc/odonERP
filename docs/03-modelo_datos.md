# 📊 Modelo de Datos del ERP  

## 🔹 **Módulos Principales de Nuestro ERP**  

| Módulo       | Funcionalidad |
|-------------|--------------|
| **Pacientes** | Registro de pacientes, historial médico, datos de contacto. |
| **Citas** | Agendamiento, disponibilidad de doctores. |
| **Doctores** | Registro de médicos, especialidades y horarios. |
| **Facturación** | Control de pagos, facturas y reportes financieros. |
| **Inventarios** | Administración de insumos médicos, medicamentos y compras. |

---

### **Enfoque Especial: Módulo de Inventarios 📦**  

📌 **¿Por qué es crucial en un ERP de salud?**  

- **Control de medicamentos e insumos médicos** (ej. guantes, jeringas, soluciones intravenosas).  
- **Relación con facturación y proveedores**.  
- **Optimización de costos** con reportes de uso y predicción de compras.  
- **Seguridad y trazabilidad** en la administración de medicamentos controlados.  

📌 **Relaciones clave del módulo de Inventarios**  
🔹 **Doctores** → Consumen insumos en procedimientos médicos.  
🔹 **Pacientes** → Se les administran medicamentos e insumos.  
🔹 **Facturación** → Cada insumo utilizado debe reflejarse en la cuenta del paciente.  
🔹 **Proveedores** → Se encargan de suministrar insumos y medicamentos.  

📌 **Ejemplo de Uso en la Clínica**  
1️⃣ Se atiende a un paciente y se usa un medicamento.  
2️⃣ El medicamento se descuenta del inventario.  
3️⃣ Se genera un cobro en la facturación.  
4️⃣ Si el stock es bajo, se genera automáticamente una orden de compra.  

---

## 🔹 **Tablas Principales**  

1️⃣ **Pacientes** → Almacena datos de pacientes.  
2️⃣ **Doctores** → Registro de médicos y especialidades.  
3️⃣ **Citas** → Maneja los turnos de consulta.  
4️⃣ **Facturación** → Registra pagos y transacciones.  
5️⃣ **Inventario** → Control de suministros médicos.  

## **Definiendo y Refinando el Modelo de Datos Inicial**  


📌 **Tablas Clave del ERP**  

```sql
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

CREATE TABLE doctores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL
);

CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id),
    doctor_id INT REFERENCES doctores(id),
    fecha TIMESTAMP NOT NULL
);

CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id),
    fecha TIMESTAMP DEFAULT current_timestamp,
    total DECIMAL(10,2) CHECK (total >= 0)
);

CREATE TABLE inventarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad INT CHECK (cantidad >= 0),
    precio DECIMAL(10,2) CHECK (precio >= 0)
);

CREATE TABLE movimientos_inventario (
    id SERIAL PRIMARY KEY,
    inventario_id INT REFERENCES inventarios(id),
    cantidad INT NOT NULL,
    tipo_movimiento VARCHAR(50) CHECK (tipo_movimiento IN ('entrada', 'salida')),
    fecha TIMESTAMP DEFAULT current_timestamp
);
```

📌 **Explicación del Modelo**  
🔹 `inventarios`: Almacena los productos médicos disponibles.  
🔹 `movimientos_inventario`: Registra **entradas y salidas** de productos.  
🔹 `citas`: Relaciona **pacientes con doctores**.  
🔹 `facturas`: Conecta **pacientes con pagos y consumos de insumos**.  

📌 **Ejemplo de Consulta**:  
Obtener los **productos más usados en la clínica**.  

```sql
SELECT i.nombre, SUM(m.cantidad) AS total_usado
FROM movimientos_inventario m
JOIN inventarios i ON m.inventario_id = i.id
WHERE m.tipo_movimiento = 'salida'
GROUP BY i.nombre
ORDER BY total_usado DESC
LIMIT 5;
```
📌 **Explicación del Modelo**  
🔹 `inventarios`: Almacena los productos médicos disponibles.  
🔹 `movimientos_inventario`: Registra **entradas y salidas** de productos.  
🔹 `citas`: Relaciona **pacientes con doctores**.  
🔹 `facturas`: Conecta **pacientes con pagos y consumos de insumos**.  

📌 **Ejemplo de Consulta**:  
Obtener los **productos más usados en la clínica**.  

```sql
SELECT i.nombre, SUM(m.cantidad) AS total_usado
FROM movimientos_inventario m
JOIN inventarios i ON m.inventario_id = i.id
WHERE m.tipo_movimiento = 'salida'
GROUP BY i.nombre
ORDER BY total_usado DESC
LIMIT 5;
```
📌 **Explicación del Modelo**  
🔹 `inventarios`: Almacena los productos médicos disponibles.  
🔹 `movimientos_inventario`: Registra **entradas y salidas** de productos.  
🔹 `citas`: Relaciona **pacientes con doctores**.  
🔹 `facturas`: Conecta **pacientes con pagos y consumos de insumos**.  

📌 **Ejemplo de Consulta**:  
Obtener los **productos más usados en la clínica**.  

```sql
SELECT i.nombre, SUM(m.cantidad) AS total_usado
FROM movimientos_inventario m
JOIN inventarios i ON m.inventario_id = i.id
WHERE m.tipo_movimiento = 'salida'
GROUP BY i.nombre
ORDER BY total_usado DESC
LIMIT 5;
```

###**Refinamiento del Modelo**
1️⃣ ¿Cómo podríamos manejar múltiples sucursales en este modelo?  
2️⃣ ¿Qué ocurre si un paciente no paga una factura?  
3️⃣ ¿Deberíamos registrar qué doctor administra un medicamento?  

📌 **Actividades**:  
✅ Revisar el modelo propuesto y sugerir cambios.  
✅ Crear una consulta SQL para obtener el inventario con menos stock.  
✅ Plantear cómo automatizar la reposición de insumos.  

---

### Modelo de datos actualizado 20/03/2025

```sql
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
```
