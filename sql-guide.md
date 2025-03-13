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
- Ejecutará el script SQL para crear la estructura
- (Opcional) Inicializará Flask-Migrate para gestionar migraciones futuras

## Estructura de la Base de Datos

La base de datos está organizada en tres esquemas:

1. **security**: Almacena información relacionada con usuarios, autenticación y permisos.
   - `roles`: Define los roles de usuario (Administrador, Médico, etc.)
   - `usuarios`: Almacena las cuentas de usuario del sistema

2. **medical**: Contiene todas las tablas relacionadas con la gestión clínica.
   - `sucursales`: Sedes o consultorios
   - `especialidades`: Especialidades médicas
   - `pacientes`: Datos de los pacientes
   - `medicos`: Información de los médicos
   - `horarios_medicos`: Disponibilidad de los médicos
   - `estados_cita`: Posibles estados de una cita
   - `citas`: Reservas de consultas médicas
   - `historial_medico`: Registros médicos de cada consulta

3. **billing**: Gestiona la facturación y pagos.
   - `servicios`: Catálogo de servicios con precios
   - `facturas`: Documentos de facturación
   - `detalle_factura`: Líneas de cada factura

## Datos Iniciales Cargados

Se han preconfigurado los siguientes datos iniciales:

1. **Roles de usuario**: Administrador, Médico, Recepcionista, Facturación
2. **Usuario administrador**: Email: admin@clinica.com, Contraseña: admin123
3. **Sucursal principal**: Sede predeterminada para el sistema
4. **Estados de cita**: Nueva, Confirmada, En Espera, En Consulta, Completada, Cancelada
5. **Especialidades médicas**: 8 especialidades odontológicas comunes
6. **Servicios**: 8 servicios odontológicos básicos con precios e impuestos

## Gestión de la Base de Datos

### Respaldo de la Base de Datos

Es recomendable realizar respaldos periódicos:

```bash
pg_dump -U postgres -d clinica_erp_dev > backup_clinica_erp_dev_$(date +"%Y%m%d").sql
```

### Restaurar un Respaldo

```bash
psql -U postgres -d clinica_erp_dev < archivo_backup.sql
```

### Para Trabajo en Equipo

Si varios desarrolladores están trabajando en el proyecto:

1. **Enfoque SQL**: Mantén un archivo de migraciones con los cambios incrementales
2. **Enfoque Flask**: Utiliza `flask db migrate` y `flask db upgrade` para gestionar cambios

## Recomendaciones para el Desarrollo

1. **Índices**: Se han creado índices para consultas frecuentes. Añade más según sea necesario.
2. **Integridad referencial**: La base de datos utiliza claves foráneas para mantener la integridad.
3. **Campos de auditoría**: Las tablas incluyen campos como `fecha_creacion` y `creado_por`.
4. **Seguridad**: Las contraseñas se almacenan cifradas usando la extensión pgcrypto.

## Solución de Problemas Comunes

### Error de Conexión a PostgreSQL

Verifica que:
- El servicio PostgreSQL esté en ejecución
- Las credenciales (usuario/contraseña) sean correctas
- El puerto 5432 esté disponible

### Error de Permisos

```bash
# Ajustar permisos en PostgreSQL
psql -U postgres
ALTER USER postgres WITH PASSWORD 'postgres';
\q
```

### Errores en las Migraciones Flask

Si las migraciones generan errores:

```bash
# Eliminar migraciones existentes y reiniciar
rm -rf migrations/
flask db init
flask db migrate -m "Estructura inicial"
flask db upgrade
```