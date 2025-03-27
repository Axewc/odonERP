from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, SubmitField
from wtforms.validators import DataRequired, Length

class PacienteForm(FlaskForm):
    nombre = StringField('Nombre', validators=[DataRequired(), Length(min=2, max=100)])
    apellido = StringField('Apellido', validators=[DataRequired(), Length(min=2, max=100)])
    # fecha_nacimiento debe permitir seleccionar una fecha, date. 
    fecha_nacimiento = StringField('Fecha de Nacimiento', validators=[DataRequired()])
    
    enviar = SubmitField('Guardar')
