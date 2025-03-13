# Guía para la Carga y Definición de la Base de Datos - odonERP

Esta guía explica cómo configurar, cargar y definir la base de datos PostgreSQL para el proyecto odonERP, utilizando los scripts proporcionados.

## Enfoque 1: Configuración con SQL Puro

Este enfoque utiliza SQL directo para crear la estructura de base de datos, lo que ofrece mayor control y es independiente del framework.

### Paso 1: Crear la Base de Datos

Primero, asegúrate de que PostgreSQL esté en ejecución y luego crea la base de datos:

```bash
# Conectarse a PostgreSQL
psql -U postgres

# Crear la base de datos
CREATE DATABASE clinica_erp_dev;

# Salir de psql
\q
```

### Paso 2: Ejecutar el Script SQL

1. Guarda el script SQL (`database-setup-script.sql`) que te proporcioné en tu directorio de trabajo.

2. Ejecuta el script:

```bash
psql -U postgres -d clinica_erp_dev -f database-setup-script.sql
```

3. Verifica que las tablas se hayan creado correctamente:

```bash
psql -U postgres -d clinica_erp_dev

# Listar los esquemas
\dn

# Listar las tablas de un esquema específico
\dt medical.*
\dt security.*
\dt billing.*

# Verificar los datos insertados
SELECT * FROM security.roles;
SELECT * FROM medical.especialidades;

# Salir de psql
\q
```

## Enfoque 2: Configuración con Python/Flask

Este enfoque utiliza Flask-SQLAlchemy y Flask-Migrate para gestionar la estructura de la base de datos, lo que facilita el seguimiento de cambios y migraciones.

### Paso 1: Configurar el Entorno

Asegúrate de que tu entorno virtual esté activado:

```bash
# En Linux/macOS
source venv/bin/activate

# En Windows
.\venv\Scripts\activate
```

### Paso 2: Instalar Dependencias

```bash
pip install flask flask-sqlalchemy flask-migrate psycopg2-binary
```

### Paso 3: Ejecutar el Script de Inicialización

1. Guarda el script Python (`db_init.py`) que te proporcioné en tu directorio de trabajo.

2. Ejecuta el script:

```bash
python db_init.py
```

Este script realizará las siguientes tareas:
- Creará la base de datos si no existe
- Ejecutará el scrip