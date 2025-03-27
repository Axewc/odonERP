from flask import Flask, render_template, redirect, url_for, request
from models.models import db, Paciente
from models.forms import PacienteForm # importar el formulario en models/forms.py
from dotenv import load_dotenv
import os

# Cargar las variables de entorno desde el archivo .env
load_dotenv()

app = Flask(__name__)

# Configurar la URI de la base de datos usando las variables de entorno
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db.init_app(app)

# crear la base de datos
with app.app_context():
    db.create_all()
    
@app.route('/pacientes/nuevo', methods=['GET', 'POST'])
def agregar_paciente():
    form = PacienteForm()
    if form.validate_on_submit():
        nuevo_paciente = Paciente(nombre=form.nombre.data, apellido = form.apellido.data, fecha_nacimiento=form.fecha_nacimiento.data)
        db.session.add(nuevo_paciente) # Usar la sesión de la base de datos para agregar el nuevo paciente
        db.session.commit() # Guardar los cambios en la base de datos
        return redirect(url_for('mostrar_pacientes'))
    return render_template('agregar_paciente.html', form=form)
    

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/pacientes')
def mostrar_pacientes():
    pacientes = Paciente.query.all() # Obtener todos los pacientes
    return render_template('pacientes.html', pacientes=pacientes)

@app.route('/pacientes/editar/<int:id>', methods=['GET', 'POST'])
def editar_paciente(id):
    paciente = Paciente.query.get(id)
    form = PacienteForm(obj=paciente)
    
    if form.validate_on_submit():
        paciente.nombre = form.nombre.data
        paciente.apellido = form.apellido.data
        paciente.fecha_nacimiento = form.fecha_nacimiento.data
        db.session.commit()
        return redirect(url_for('mostrar_pacientes'))
    
    return render_template('editar_paciente.html', form=form)
  
@app.route('/pacientes/eliminar/<int:id>', methods=['POST'])
def eliminar_paciente(id):
    paciente = Paciente.query.get_or_404(id)
    db.session.delete(paciente)
    db.session.commit()
    return redirect(url_for('mostrar_pacientes'))
      
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)