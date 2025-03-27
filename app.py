from flask import Flask, render_template
from models import db, Paciente  # Asegúrate de importar Paciente


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:210622@localhost/erp_clinico'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# app.config.from_object('config.Config')

db.init_app(app)

@app.route('/')
def index():
    return render_template('index.html')  # Ruta corregida

@app.route('/pacientes')
def mostrar_pacientes():
    pacientes = Paciente.query.all()
    return render_template('pacientes.html', pacientes=pacientes)  # Ruta corregida

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Asegúrate de que la base de datos está inicializada
    app.run(debug=True)