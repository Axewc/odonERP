# 🛠 **Taller Práctico: Construyendo la Base del Proyecto en Flask con PostgreSQL**  

## 🎯 **Objetivo de la Clase**  

- Configurar correctamente **Flask** y su entorno virtual.  
- Integrar **Flask con PostgreSQL** utilizando **SQLAlchemy**.  
- Construir los primeros modelos de datos y probar consultas desde Flask.  
- Comprender la estructura de archivos de un proyecto Flask.  

---

## **🔷 1. Preparando el Entorno**  

### 📌 **Instalación de Dependencias**  

Antes de comenzar, debemos instalar los paquetes necesarios. Asegúrate de estar dentro de un entorno virtual.  

```bash
# Crear el entorno virtual (si aún no lo hiciste)
python -m venv venv

# Activarlo
source venv/bin/activate  # En macOS/Linux
venv\Scripts\activate  # En Windows

# Instalar Flask y dependencias
pip install flask flask-sqlalchemy psycopg2-binary
```

### 📌 **Estructura del Proyecto**  

La estructura de archivos será la siguiente:  

```
/erp_clinico
├── app.py                 # Archivo principal de la aplicación
├── models.py              # Definición de los modelos de datos
├── config.py              # Configuración de Flask y PostgreSQL
├── templates/             # Archivos HTML con Jinja
│   ├── base.html
│   ├── index.html
│   ├── pacientes.html
├── static/                # Archivos estáticos (CSS, JS, imágenes)
│   ├── styles.css
├── requirements.txt       # Dependencias del proyecto
```

✅ **¿Por qué esta estructura?**  
Organizar el proyecto de esta manera facilita la **modularidad** y la **mantenibilidad**, permitiendo escalabilidad en futuras versiones.

---

## **🔷 2. Configuración de Flask y PostgreSQL**  

### 📌 **Configurando `config.py`**  

Este archivo contendrá la configuración de Flask y la conexión con PostgreSQL.  

```python
import os

class Config:
    SECRET_KEY = 'clave_secreta'
    SQLALCHEMY_DATABASE_URI = 'postgresql://usuario:password@localhost/erp_clinico'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
```

### 📌 **Creando la Aplicación en `app.py`**  

```python
from flask import Flask
from models import db

app = Flask(__name__)
app.config.from_object('config.Config')

db.init_app(app)

if __name__ == '__main__':
    app.run(debug=True)
```

✅ **¿Qué hicimos aquí?**  

- Creamos la aplicación Flask.  
- Importamos la configuración desde `config.py`.  
- Inicializamos SQLAlchemy con Flask.  
- Configuramos el servidor en **modo debug**.  

---

## **🔷 3. Creando los Modelos de Datos en SQLAlchemy**  

En el archivo `models.py`, definiremos las **tablas** usando SQLAlchemy.  

```python
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Paciente(db.Model):
    __tablename__ = 'pacientes'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    apellido = db.Column(db.String(100), nullable=False)
    fecha_nacimiento = db.Column(db.Date, nullable=False)

class Doctor(db.Model):
    __tablename__ = 'doctores'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    especialidad = db.Column(db.String(100), nullable=False)
```

### 📌 **Creando la Base de Datos**  

Antes de ejecutar la aplicación, debemos crear la base de datos y generar las tablas.  

1️⃣ **Abrir PostgreSQL y crear la base de datos**  

```sql
CREATE DATABASE erp_clinico;
```

2️⃣ **Inicializar la base de datos desde Flask**  

```python
from app import app
from models import db

with app.app_context():
    db.create_all()
```

✅ **¿Qué logramos?**  

- Creamos las tablas necesarias en PostgreSQL.  
- Establecimos la conexión entre Flask y SQLAlchemy.  

---

## **🔷 4. Implementando la Primera Ruta: Listar Pacientes**  

### 📌 **Definiendo la Vista en `app.py`**  

```python
from flask import Flask, render_template
from models import db, Paciente

@app.route('/pacientes')
def mostrar_pacientes():
    pacientes = Paciente.query.all()
    return render_template('pacientes.html', pacientes=pacientes)
```

### 📌 **Creando el Template en Jinja (`templates/pacientes.html`)**  

```html
{% extends "base.html" %}

{% block content %}
<h1>Lista de Pacientes</h1>
<ul>
    {% for paciente in pacientes %}
        <li>{{ paciente.nombre }} {{ paciente.apellido }} - {{ paciente.fecha_nacimiento }}</li>
    {% endfor %}
</ul>
{% endblock %}
```

### 📌 **Ejecutando la Aplicación y Probando la Ruta**  

```bash
flask run
```

🔹 **Abrir en el navegador**:  
<http://127.0.0.1:5000/pacientes>  

✅ **¿Qué hicimos?**  

- Creamos una ruta en Flask que consulta los pacientes en la base de datos.  
- Construimos una plantilla HTML dinámica con Jinja.  

---

## **🔷 5. Actividades en Clase 🚀**  

✅ **Ejercicio 1:** Agregar una tabla en `pacientes.html` en lugar de una lista.  
✅ **Ejercicio 2:** Agregar un campo "teléfono" a la tabla `pacientes` y modificar el modelo en SQLAlchemy.  
✅ **Ejercicio 3:** Agregar una nueva ruta `/doctores` y un template similar para mostrar los médicos.  

---

## **📌 Reflexión Final**  

🎯 En esta sesión:  
✅ Configuramos Flask y PostgreSQL correctamente.  
✅ Creamos modelos con SQLAlchemy y conectamos la base de datos.  
✅ Construimos nuestra primera ruta en Flask con Jinja.  

📅 **Próxima Clase:** **CRUD Completo con Flask-WTF y Formularios Dinámicos**  
🚀 **Tarea:** Subir el código al repositorio de GitHub y realizar los ejercicios.  

---