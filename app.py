from flask import Flask
from models import db
from flask import Flask, render_template
from models import db, Paciente

app = Flask(__name__)
app.config.from_object('config.Config')

db.init_app(app)

if __name__ == '__main__':
    app.run(debug=True)

@app.route('/pacientes')
def mostrar_pacientes():
    pacientes = Paciente.query.all()
    return render_template('pacientes.html', pacientes=pacientes)

@app.route('/')
def index():
    return mostrar_pacientes()
