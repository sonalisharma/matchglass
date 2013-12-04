import os
from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from flask import render_template
from werkzeug import secure_filename
from flask import Flask, request, redirect, url_for
from flask import send_from_directory   
from pybtex.database.input import bibtex
from sqlalchemy import distinct
from itertools import izip


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///matchglass.db'
#app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

db = SQLAlchemy(app)
eng = db.create_engine("sqlite:///matchglass.db")
db.drop_all()
db.create_all()
app.debug = True


class Matchglass(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    status = db.Column(db.String(1500))
    pin = db.Column(db.String(1500))
    follow = db.Column(db.Integer)
    matchpin = db.Column(db.String(1500))
    expressinterest = db.Column(db.String(1500))
    answer = db.Column(db.String(1500))
    email = db.Column(db.String(1500))

    def __init__(self, name, status,pin,follow,matchpin,expressinterest,answer,email):
        self.name = name
        self.status = status
        self.pin = pin
        self.follow = follow
        self.matchpin = matchpin
        self.expressinterest = expressinterest
        self.answer = answer
        self.email = email

    def __repr__(self):
        return 'Yo, my name is %r' % self.name

@app.route("/", methods=['GET', 'POST'])
def getuser():
    options=["Bird","Face"]
    print options
    if request.method == 'POST':
        #try:
        print "I am here"
        name = request.form['fname']
        print name
        #name = "SonaliTest"
       # print name
        #print request.form['txt_name']
        #print email
        #email = request.form['txt_email']
        radio  = "1"
        colorbox = request.form['color']
        print colorbox
        data = [] 
        #name= "dummyuser"
        data.append(name)
        data.append("active")
        data.append(radio)
        data.append(colorbox)
        data.append("follow")
        data.append("matchpin")
        data.append("expinterest")
        data.append("test@abc.com")
        print data
        matchdata = Matchglass(str(data[0]),str(data[1]),str(data[2]),str(data[3]),str(data[4]),str(data[5]),str(data[6]),str(data[7]))
        db.session.add(matchdata)
        db.session.commit()
        #print active_users
        #except Exception,e:
        #    flag = "failure"
        #    print e
        return redirect(url_for('makematch')) 
    return render_template('main.html',options=options)

def getusers():
    con =  eng.connect()
    query_template = "select * from Matchglass WHERE status = active"
    active_users = con.execute(query)
    return active_users


@app.route('/makematch')
def makematch():
    users = getusers
    return render_template('makematch.html')

@app.route('/user/<name>')
def thanks(name):
    message = "Thanks! Collect your glass and prepare to find your match."
    return render_template('thankyou.html',status = message)

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    print "I am in upload"  
    try:
        data = [] 
        data.append(name)
        data.append("active")
        data.append(radio)
        data.append(colorbox)
        data.append("follow")
        data.append("matchpin")
        data.append("expinterest")
        data.append(email)
        print data
        matchdata = Matchglass(str(data[0]),str(data[1]),str(data[2]),str(data[3]),str(data[4]),str(data[5]),str(data[6]),str(data[7]))
        db.session.add(matchdata)
        db.session.commit()
    except Exception,e:
        flag = "failure"
        print e
    
    return redirect(url_for('thanks',name="dummy"))
if __name__ == "__main__":
    global name
    global email
    global radio
    global colorbox
    #db.drop_all()
    #db.create_all()
    app.run()

