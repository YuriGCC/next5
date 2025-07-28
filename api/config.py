from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os
from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass

from flask_cors import CORS
app = Flask(__name__)
CORS(app)  

path = os.path.dirname(os.path.abspath(__file__))
arquivobd = os.path.join(path, 'teste.db')

app.config['SQLALCHEMY_DATABASE_URI'] = "sqlite:///"+arquivobd
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  
db = SQLAlchemy(app)

