import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv

# Cargar variables de entorno desde el archivo .env
load_dotenv()

app = Flask(__name__)

# Configuración de la base de datos
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Modelo de ejemplo
class Paciente(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)

@app.route('/')
def index():
    return mostrar_pacientes()

def mostrar_pacientes():
    try:
        pacientes = Paciente.query.all()
        return f"Pacientes: {[p.nombre for p in pacientes]}"
    except Exception as e:
        return f"Error: {e}"

if __name__ == '__main__':
    app.run()
