from flask import Flask, request
from flask_cors import CORS
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

import localconst # Save your sql connection data into localconst.py
user = localconst.user
password = localconst.password
hostname = localconst.hostname
database_name = localconst.database_name

engine = create_engine(f"postgresql+psycopg2://{user}:{password}@{hostname}/{database_name}")
print(engine)

app = Flask(__name__)
# CORS(app)

@app.route('/')
def hello():
    return 'Hello world!'
    
if __name__ == '__main__':
    app.run()