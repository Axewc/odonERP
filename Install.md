# Guía de Instalación del Entorno de Desarrollo - odonERP

Esta guía detalla el proceso de instalación y configuración del entorno de desarrollo necesario para trabajar en el ERP para clínicas y consultorios (odonERP) en diferentes sistemas operativos.

## Requisitos Previos

Para desarrollar el MVP de odonERP, necesitarás instalar:

1. **PostgreSQL 15** - Sistema de gestión de base de datos
2. **Python 3.11** - Lenguaje de programación para el backend
3. **Node.js 18.x** - Entorno de ejecución para JavaScript (frontend)
4. **Git** - Sistema de control de versiones

## Instalación en Ubuntu

### 1. Actualizar el Sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Instalar PostgreSQL 15

```bash
# Añadir repositorio de PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update

# Instalar PostgreSQL 15
sudo apt install -y postgresql-15 postgresql-contrib-15

# Iniciar y habilitar el servicio
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Verificar la instalación
sudo -u postgres psql -c "SELECT version();"
```

#### Configurar PostgreSQL

```bash
# Configurar contraseña para usuario postgres
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

# Crear base de datos para desarrollo
sudo -u postgres createdb clinica_erp_dev
```

### 3. Instalar Python 3.11

```bash
# Añadir repositorio para Python 3.11
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# Instalar Python 3.11 y herramientas relacionadas
sudo apt install -y python3.11 python3.11-dev python3.11-venv python3-pip

# Establecer Python 3.11 como predeterminado (opcional)
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Verificar la instalación
python3 --version
```

### 4. Instalar Node.js 18.x

```bash
# Añadir repositorio de Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Instalar Node.js
sudo apt install -y nodejs

# Verificar la instalación
node --version
npm --version
```

### 5. Instalar Git

```bash
sudo apt install -y git

# Verificar la instalación
git --version
```

### 6. Configurar el Entorno de Desarrollo

```bash
# Clonar el repositorio
git clone https://github.com/axew/odonERP.git
cd odonERP

# Configurar entorno virtual de Python para el backend
python3 -m venv venv
source venv/bin/activate
pip install -r backend/requirements.txt

# Instalar dependencias del frontend
cd frontend
npm install
```

Si más adelante necesitas agregar nuevas dependencias, simplemente actualiza este archivo. Si estás trabajando en el proyecto y has instalado nuevas dependencias, puedes actualizar el archivo ejecutando:

```bash
pip freeze > requirements.txt
```

Pero ten cuidado, ya que esto incluirá absolutamente todas las dependencias instaladas en tu entorno virtual, incluso las que no estén directamente relacionadas con tu proyecto.

## Instalación en Windows

### 1. Instalar PostgreSQL 15

1. Descargar el instalador de [PostgreSQL 15 para Windows](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)
2. Ejecutar el instalador y seguir las instrucciones:
   - Seleccionar los componentes: PostgreSQL Server, pgAdmin 4, Command Line Tools
   - Establecer la contraseña para el usuario postgres: 'postgres'
   - Mantener el puerto predeterminado: 5432
   - Seleccionar la configuración regional predeterminada
3. Al finalizar, abrir pgAdmin 4 y crear una nueva base de datos llamada `clinica_erp_dev`

### 2. Instalar Python 3.11

1. Descargar el instalador de [Python 3.11 para Windows](https://www.python.org/downloads/release/python-3117/)
2. Ejecutar el instalador:
   - Marcar "Add Python 3.11 to PATH"
   - Seleccionar "Install Now" para una instalación estándar
3. Verificar la instalación abriendo el Símbolo del Sistema (CMD) o PowerShell:

```powershell
python --version
```

### 3. Instalar Node.js 18.x

1. Descargar el instalador de [Node.js 18.x para Windows](https://nodejs.org/download/release/latest-v18.x/)
2. Ejecutar el instalador y seguir las instrucciones predeterminadas
3. Verificar la instalación:

```powershell
node --version
npm --version
```

### 4. Instalar Git

1. Descargar el instalador de [Git para Windows](https://git-scm.com/download/win)
2. Ejecutar el instalador con las opciones predeterminadas
3. Verificar la instalación:

```powershell
git --version
```

### 5. Configurar el Entorno de Desarrollo

```powershell
# Clonar el repositorio
git clone https://github.com/axew/odonERP.git
cd odonERP

# Configurar entorno virtual de Python para el backend
python -m venv venv
.\venv\Scripts\activate
pip install -r backend\requirements.txt

# Instalar dependencias del frontend
cd frontend
npm install
```

## Instalación en macOS

### 1. Instalar Homebrew (si no está instalado)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Instalar PostgreSQL 15

```bash
# Instalar PostgreSQL
brew install postgresql@15

# Añadir PostgreSQL al PATH
echo 'export PATH="/usr/local/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc  # o ~/.bash_profile si usas Bash

# Iniciar el servicio
brew services start postgresql@15

# Crear usuario y base de datos
createuser -s postgres
psql postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
createdb clinica_erp_dev
```

### 3. Instalar Python 3.11

```bash
brew install python@3.11

# Verificar la instalación
python3 --version
```

### 4. Instalar Node.js 18.x

```bash
brew install node@18

# Añadir Node.js al PATH si es necesario
echo 'export PATH="/usr/local/opt/node@18/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc  # o ~/.bash_profile si usas Bash

# Verificar la instalación
node --version
npm --version
```

### 5. Instalar Git

```bash
brew install git

# Verificar la instalación
git --version
```

### 6. Configurar el Entorno de Desarrollo

```bash
# Clonar el repositorio
git clone https://github.com/axew/odonERP.git
cd odonERP

# Configurar entorno virtual de Python para el backend
python3 -m venv venv
source venv/bin/activate
pip install -r backend/requirements.txt

# Instalar dependencias del frontend
cd frontend
npm install
```

## Configuración del Proyecto

### Configuración del Backend

1. **Configurar Variables de Entorno**:
   Crear un archivo `.env` en el directorio `backend/`:

```
FLASK_APP=run.py
FLASK_ENV=development
FLASK_DEBUG=1
SECRET_KEY=tu_clave_secreta_aqui
JWT_SECRET_KEY=tu_clave_jwt_aqui
DATABASE_URL=postgresql://postgres:postgres@localhost/clinica_erp_dev
```

2. **Inicializar la Base de Datos**:

```bash
# Desde el directorio backend/ con el entorno virtual activado
flask db init
flask db migrate -m "Estructura inicial de la base de datos"
flask db upgrade
```

### Configuración del Frontend

1. **Configurar API Endpoint**:
   Crear un archivo `.env.local` en el directorio `frontend/`:

```
REACT_APP_API_URL=http://localhost:5000/api
```

## Ejecución en Modo Desarrollo

### Ejecutar el Backend

```bash
# En el directorio raíz con el entorno virtual activado
cd backend
flask run
```

### Ejecutar el Frontend

```bash
# En otro terminal, en el directorio frontend/
npm start
```

## Extensiones Recomendadas para VS Code

- Python (ms-python.python)
- SQLTools (mtxr.sqltools)
- SQLTools PostgreSQL/Redshift Driver (mtxr.sqltools-driver-pg)
- ES7+ React/Redux/React-Native snippets (dsznajder.es7-react-js-snippets)
- ESLint (dbaeumer.vscode-eslint)
- Prettier (esbenp.prettier-vscode)
- GitLens (eamodio.gitlens)

## Solución de Problemas Comunes

### PostgreSQL no se inicia

**Ubuntu**:
```bash
sudo systemctl status postgresql
sudo journalctl -u postgresql
```

**Windows**:
Verificar en Servicios (services.msc) que el servicio "postgresql-x64-15" esté en ejecución.

**macOS**:
```bash
brew services restart postgresql@15
```

### Problemas de Conexión a la Base de Datos

Verificar credenciales en `config.py` o archivo `.env`. Asegurarse de que:
- El usuario postgres tenga la contraseña correcta
- La base de datos exista
- PostgreSQL esté escuchando en localhost:5432

### Problemas con las Dependencias de Python

Si hay errores al instalar paquetes, intenta:

```bash
pip install --upgrade pip
pip install wheel
```

Y luego vuelve a instalar las dependencias:

```bash
pip install -r backend/requirements.txt
```

### Problemas con Node.js / npm

Si hay errores de dependencias en el frontend:

```bash
# Limpiar caché de npm
npm cache clean --force

# Reinstalar node_modules
rm -rf node_modules
npm install
```

## Buenas Prácticas para el Desarrollo

1. **Control de Versiones**:
   - Crear una rama por cada característica nueva
   - Hacer commits frecuentes con mensajes descriptivos
   - Fusionar mediante Pull Requests después de revisión

2. **Estilo de Código**:
   - Backend: Seguir PEP 8 para Python
   - Frontend: Usar ESLint y Prettier para mantener consistencia

3. **Pruebas**:
   - Escribir pruebas unitarias para los servicios y modelos
   - Ejecutar pruebas antes de cada commit

4. **Documentación**:
   - Documentar APIs con docstrings y comentarios
   - Mantener actualizado el README con instrucciones

5. **Seguridad**:
   - No almacenar secretos ni contraseñas en el código
   - Utilizar variables de entorno para configuraciones sensibles