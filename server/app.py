from flask import Flask, request
from flask_cors import CORS
import pandas as pd
from sqlalchemy import create_engine, delete
from sqlalchemy.engine import URL
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy import Boolean, Column, ForeignKey, BigInteger, Integer, String, TIMESTAMP, Table, MetaData, update, text

import localconst # Save your sql connection data into localconst.py
db_user = localconst.user
db_password = localconst.password
db_hostname = localconst.hostname
db_database_name = localconst.database_name

engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_password}@{db_hostname}/{db_database_name}", future=True)
metadata = MetaData()
conn = engine.raw_connection()
cursor = conn.cursor()
print(engine)

users = Table(
    "users", metadata,
    Column("id", BigInteger, primary_key=True),
    Column("username", String), 
    Column("email", String), 
    Column("password", String)
)
metadata.create_all(engine)

app = Flask(__name__)
# CORS(app)

@app.route('/')
def hello():
    return 'Hello world!'

@app.route('/connect', methods=['POST'])
def connect():
    status = request.get_data()
    return status

@app.route("/login", methods=['POST'])
def login():
    user_info = request.get_json(force=True)
    # status = request.get_json(force=True)
    # l_username = status['username']
    # l_password = status['password']
    # return ""
    user_username = user_info["username"]
    user_password = user_info["password"]
    cursor.execute(f"SELECT password FROM users WHERE username = '{user_username}' OR email = '{user_username}'")
    correct_password = cursor.fetchone()
    print(correct_password)
    try:
        correct_password = correct_password[0]
    except:
        pass
    print(correct_password)
    status = ""
    if(correct_password == user_password):
        status = "Login Success"
    elif(correct_password == None):
        status = "User not found"
    else:
        status = "Password not correct"
    return status

if __name__ == '__main__':
    app.run()