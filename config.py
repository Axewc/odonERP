import os

class Config:
    SECRET_KEY = 'clave_secreta'
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost/erp_clinico')   
    SQLALCHEMY_TRACK_MODIFICATIONS = False