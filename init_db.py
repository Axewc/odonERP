from app import app
from models import db

# Inicializa la base de datos dentro del contexto de la aplicación Flask
with app.app_context():
    db.create_all()
    print("📌 Base de datos creada con éxito.")
# Para ejecutar este script, ejecute el siguiente comando en la terminal:
# python init_db.py
