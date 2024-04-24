# Python serverside login and forum system for android studio project: [KaptureAIO](https://github.com/wingyeung0317/KaptureAIO).
# KaptureAIO: a project that aim to build an android app that provide different photographic informations for Hong Konger, such as Weather, Place, Forum etc.
# By Wing (github: [wingyeung0317](https://github.com/wingyeung0317))

# The server will provide the following functions:
# 1. Connect to the database.
# 2. Login to the system.
# 3. Register a new user.
# 4. Get the forum data from the database.
# 5. Write a new forum.
# 6. Add a reply to a forum.
# 7. Forget password.
# 8. Like a forum.

from flask import Flask, request
from flask_cors import CORS
import pandas as pd
from sqlalchemy import create_engine, delete
from sqlalchemy.engine import URL
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy import Boolean, Column, ForeignKey, BigInteger, Integer, String, TIMESTAMP, Table, MetaData, update, text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
import uuid
import arrow

import localconst # Save your sql connection data into localconst.py
db_user = localconst.user
db_password = localconst.password
db_hostname = localconst.hostname
db_database_name = localconst.database_name

app = Flask(__name__)
# CORS(app)

if __name__ == '__main__':
    app.run()

engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_password}@{db_hostname}/{db_database_name}", future=True)
metadata = MetaData()
conn = engine.raw_connection()
cursor = conn.cursor()
print(engine)

users = Table(
    "users", metadata,
    Column("id", Integer, primary_key=True, autoincrement=True),
    Column("username", String, unique=True), 
    Column("displayname", String), 
    Column("email", String), 
    Column("password", String),
    Column("role", String, default="rookie"),
    Column("img", String, default="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
)

forums = Table(
    "forums", metadata,
    Column("id", Integer, primary_key=True, autoincrement=True),
    Column("writer", None, ForeignKey("users.id")),
    Column("title", String),
    Column("content", String),
    Column("create_time", TIMESTAMP, server_default=text("now()")),
)

replies = Table(
    "replies", metadata,
    Column("id", Integer, primary_key=True, autoincrement=True),
    Column("writer", None, ForeignKey("users.id")),
    Column("content", String),
    Column("forum_id", None, ForeignKey("forums.id")),
    Column("create_time", TIMESTAMP, server_default=text("now()")),
)

likes = Table(
    "likes", metadata,
    Column("user_id", None, ForeignKey("users.id")),
    Column("forum_id", None, ForeignKey("forums.id")),
    Column("replies_id", None, ForeignKey("replies.id")),
    Column("like", Boolean),
    Column("create_time", TIMESTAMP, server_default=text("now()")),
    UniqueConstraint("user_id", "forum_id", "replies_id", name="likes_pk"),
)
metadata.create_all(engine)

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
    user_username = user_info["username"]
    user_password = user_info["password"]
    cursor.execute(f"SELECT password FROM users WHERE username = '{user_username}' OR email = '{user_username}'")
    correct_password = cursor.fetchone()
    print(user_password)
    try:
        correct_password = correct_password[0]
    except:
        print(f"Error: {correct_password}")
    returnJSON_df = pd.DataFrame()
    if(correct_password == user_password):
        userdf = pd.read_sql_query(f"SELECT id, username, displayname, email, img, role FROM users WHERE username = '{user_username}' OR email = '{user_username}'", con=engine)
        print(userdf)
        returnJSON_df = pd.DataFrame([['success']], columns=['status'])
        print(returnJSON_df)
        returnJSON_df = pd.concat([returnJSON_df, userdf], axis=1)
    elif(correct_password == None):
        returnJSON_df = pd.DataFrame([['User not found', 0, 'Visitor', 'Visitor', '', 'Visitor']], columns=['status', 'id', 'username', 'displayname', 'email', 'role'])
    else:
        returnJSON_df = pd.DataFrame([['Incorrect password', 0, 'Visitor', 'Visitor', '', 'Visitor']], columns=['status', 'id', 'username', 'displayname', 'email', 'role'])
    returnJSON = returnJSON_df.to_json(orient='records', lines=True)
    return f'{returnJSON}'

@app.route('/register', methods=['POST'])
def register():
    user_info = request.get_json(force=True)
    user_username = user_info["username"]
    user_displayname = user_info["displayname"]
    user_email = user_info["email"]
    user_password = user_info["password"]
    try:
        stmt = insert(users).values(username=user_username, displayname=user_displayname, email=user_email, password=user_password)
        with engine.connect() as conn:
            result = conn.execute(stmt)
            conn.commit()
        return "success"
    except Exception as e:
        print(e)
        return "Error: User Exists"


@app.route('/getforum', methods=['GET'])
def getforum():
    forumdf = pd.read_sql_query("SELECT create_time, displayname, title, content FROM forums AS f JOIN users AS u ON u.id = f.writer ORDER BY f.id DESC", con=engine)
    forumdf['create_time'] = forumdf['create_time'].apply(lambda x: arrow.get(x).strftime('%Y-%m-%d %H:%M'))
    returnJSON = forumdf.to_json(orient="values")
    return f'{returnJSON}'

@app.route('/writeforum', methods=['POST'])
def writeforum():
    forum_info = request.get_json(force=True)
    forum_writer = forum_info["writer"]
    forum_title = forum_info["title"]
    forum_content = forum_info["content"]
    try:
        stmt = insert(forums).values(writer=forum_writer, title=forum_title, content=forum_content)
        with engine.connect() as conn:
            result = conn.execute(stmt)
            conn.commit()
        return "Forum Created"
    except Exception as e:
        print(e)
        return "Error"

@app.route('/addreply', methods=['POST'])
def addreply():
    reply_info = request.get_json(force=True)
    reply_writer = reply_info["writer"]
    reply_content = reply_info["content"]
    reply_forum_id = reply_info["forum_id"]
    try:
        stmt = text(f"INSERT INTO replies VALUES({uuid.uuid4()}, '{reply_writer}', '{reply_content}', '{reply_forum_id}', NOW())")
        with engine.connect() as conn:
            result = conn.execute(stmt)
            conn.commit()
        return "Reply Created"
    except Exception as e:
        print(e)
        return "Error"
  
@app.route('/forgetpassword', methods=['POST'])
def forgetpassword():
    user_info = request.get_json(force=True)
    user_email = user_info["email"]
    user_password = user_info["password"]
    try:
        stmt = text(f"UPDATE users SET password = {user_password} WHERE email = {user_email}")
        with engine.connect() as conn:
            result = conn.execute(stmt)
            conn.commit()
        return "Password Updated"
    except Exception as e:
        print(e)
        return "Error"
    
@app.route('/likeforum', methods=['POST'])
def likeforum():
    like_info = request.get_json(force=True)
    like_user_id = like_info["user_id"]
    like_forum_id = like_info["forum_id"]
    like_reply_id = like_info["reply_id"]
    like = like_info["like"]
    try:
        stmt = text(f"INSERT INTO likes VALUES({like_user_id}, {like_forum_id}, {like_reply_id}, NULL, {like})")
        with engine.connect() as conn:
            result = conn.execute(stmt)
            conn.commit()
        return "Like Created"
    except Exception as e:
        print(e)
        return "Error"