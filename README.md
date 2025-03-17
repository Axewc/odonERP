# odontoERP

Sistema de gestión para clínicas dentales diseñado como guía educativa para estudiantes universitarios.

## Tecnologías Utilizadas

- **Frontend**: React, React Router, Axios
- **Backend**: Python, Flask, SQLAlchemy
- **Base de Datos**: PostgreSQL

## Guía de Instalación y Ejecución

### 1. Requisitos Previos

Asegúrate de tener instalado:
- Python 3.8 o superior
- Node.js 14 o superior
- PostgreSQL 12 o superior
- npm (viene con Node.js)

### 2. Configuración de la Base de Datos

1. Inicia PostgreSQL:
   ```bash
   sudo service postgresql start
   ```

2. Crea la base de datos y el usuario:
   ```bash
   sudo -u postgres psql
   ```

3. En la consola de PostgreSQL:
   ```sql
   CREATE DATABASE odonto_erp;
   CREATE USER odonto_admin WITH PASSWORD 'tu_contraseña';
   GRANT ALL PRIVILEGES ON DATABASE odonto_erp TO odonto_admin;
   \q
   ```

4. Ejecuta el script de inicialización:
   ```bash
   sudo -u postgres psql -d odonto_erp -f backend/init.sql
   ```

### 3. Configuración del Backend

1. Clona el repositorio (si aún no lo has hecho):
   ```bash
   git clone <url-del-repositorio>
   cd odonERP
   ```

2. Crea y activa el entorno virtual:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # En Linux/Mac
   # O en Windows:
   # .\venv\Scripts\activate
   ```

3. Instala las dependencias:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. Configura las variables de entorno:
   ```bash
   # Crea un archivo .env en la carpeta backend
   echo "DATABASE_URL=postgresql://odonto_admin:tu_contraseña@localhost/odonto_erp" > .env
   echo "SECRET_KEY=tu_clave_secreta" >> .env
   ```

5. Inicia el servidor Flask:
   ```bash
   python app.py
   # El servidor estará disponible en http://localhost:5000
   ```

### 4. Configuración del Frontend

1. Instala las dependencias:
   ```bash
   cd frontend
   npm install
   ```

2. Configura las variables de entorno:
   ```bash
   # Crea un archivo .env en la carpeta frontend
   echo "REACT_APP_API_URL=http://localhost:5000" > .env
   ```

3. Inicia el servidor de desarrollo:
   ```bash
   npm start
   # La aplicación estará disponible en http://localhost:3000
   ```

## Estructura del Proyecto

```
odontoERP/
├── backend/
│   ├── app.py           # Aplicación Flask principal
│   ├── config.py        # Configuración de la aplicación
│   ├── models.py        # Modelos SQLAlchemy
│   ├── init.sql         # Script de inicialización de la base de datos
│   ├── requirements.txt # Dependencias del backend
│   └── .env            # Variables de entorno (crear manualmente)
└── frontend/
    ├── src/
    │   ├── components/  # Componentes React
    │   ├── App.js       # Componente principal
    │   └── index.js     # Punto de entrada
    ├── package.json     # Dependencias del frontend
    └── .env            # Variables de entorno (crear manualmente)
```

## Verificación de la Instalación

1. **Backend**:
   - Accede a http://localhost:5000 en tu navegador
   - Deberías ver un mensaje "API is running"

2. **Frontend**:
   - Accede a http://localhost:3000
   - Deberías ver la página de inicio de odontoERP

## Solución de Problemas Comunes

1. **Error de conexión a la base de datos**:
   - Verifica que PostgreSQL esté corriendo: `sudo service postgresql status`
   - Confirma las credenciales en el archivo `.env`
   - Asegúrate de que la base de datos existe: `sudo -u postgres psql -l`

2. **Error al instalar dependencias de Python**:
   - Actualiza pip: `pip install --upgrade pip`
   - Instala las herramientas de desarrollo: `sudo apt-get install python3-dev`

3. **Error al iniciar el frontend**:
   - Limpia la caché de npm: `npm clean-cache --force`
   - Borra node_modules: `rm -rf node_modules`
   - Reinstala dependencias: `npm install`

## Módulos del Sistema

1. **Pacientes**
   - Registro de pacientes
   - Historial médico

2. **Doctores**
   - Registro de doctores
   - Especialidades

3. **Citas**
   - Agendamiento
   - Disponibilidad de doctores

4. **Facturación**
   - Control de pagos
   - Reportes financieros

5. **Inventarios**
   - Administración de insumos médicos

### Registro y Autenticación

#### 1. Registro de Usuario

- **Endpoint**: `POST /register`
- **Descripción**: Permite a un nuevo usuario registrarse en el sistema.
- **Cuerpo de la Solicitud**:
  ```json
  {
    "nombre": "Nombre del Usuario",
    "email": "correo@ejemplo.com",
    "contraseña": "contraseña"
  }
  ```
- **Respuesta**: Devuelve los datos del usuario creado (sin la contraseña).

#### 2. Inicio de Sesión

- **Endpoint**: `POST /login`
- **Descripción**: Permite a un usuario existente iniciar sesión.
- **Cuerpo de la Solicitud**:
  ```json
  {
    "email": "correo@ejemplo.com",
    "contraseña": "contraseña"
  }
  ```
- **Respuesta**: Devuelve los datos del usuario si la autenticación es exitosa; de lo contrario, un mensaje de error.

#### 3. Implementación en el Frontend

- **Login.js**: Componente que maneja el inicio de sesión del usuario. Utiliza `axios` para enviar una solicitud POST al endpoint `/login`. Si el inicio de sesión es exitoso, almacena los datos del usuario en `localStorage` y redirige a la página del dashboard.

- **Register.js**: Componente que maneja el registro de nuevos usuarios. Utiliza `axios` para enviar una solicitud POST al endpoint `/register`. Si el registro es exitoso, redirige a la página de inicio de sesión.

## Propósito Educativo

Este proyecto está diseñado como una guía práctica para estudiantes, demostrando:

- Integración de Flask con PostgreSQL usando SQLAlchemy
- Autenticación básica con bcrypt
- Arquitectura frontend con React y React Router
- Comunicación cliente-servidor con Axios
- Diseño de UI/UX básico con CSS puro

## Contribución

Este es un proyecto educativo abierto. Se anima a los estudiantes a:

1. Implementar los módulos pendientes
2. Mejorar la seguridad
3. Añadir validaciones
4. Mejorar la interfaz de usuario
5. Agregar tests
