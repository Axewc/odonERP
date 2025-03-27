import os

class Config:
    SECRET_KEY = 'clave_secreta'
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:210622@localhost/erp_clinico'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
