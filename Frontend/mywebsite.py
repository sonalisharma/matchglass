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
        name = request.form['txt_name']
        print name
        radio  = request.form['group1']
        colorbox = request.form['color']
        print colorbox
        data = [] 
        #name= "dummyuser"
        data.append(name)
        data.append("active")
        data.append(colorbox)
        data.append("follow")
        data.append("matchpin")
        data.append("expinterest")
        data.append(radio)
        data.append("test@abc.com")
        active_users = getusers()
        print len(active_users)
        if len(active_users)>=3:
            updateuser()
        matchdata = Matchglass(str(data[0]),str(data[1]),str(data[2]),str(data[3]),str(data[4]),str(data[5]),str(data[6]),str(data[7]))
        db.session.add(matchdata)
        db.session.commit()
        return redirect(url_for('makematch')) 
    return render_template('main.html',options=options)

def getusers():
    con =  eng.connect()
    query_template = "select * from matchglass WHERE status = 'active'"
    active_users = con.execute(query_template)
    return active_users.fetchall()

def updateuser():
    print "Inside commit"
    con =  eng.connect()
    rows_changed = Matchglass.query.filter_by(status='active').update(dict(status='inactive'))
    db.session.commit()

@app.route('/makematch')
def makematch():
    users = getusers()
    print users
    return render_template('makematch.html',users=users)

@app.route('/expressinterest',methods=['GET', 'POST'])
def expressinterest():
    users=[]
    if request.method == 'POST':
        users = request.form.getlist('user')
        print "------"
        print len(users)
        print users
        print "------"
        if len(users)==1:
            rows_changed = Matchglass.query.filter_by(id=users[0].split("_")[0],status='active').update(dict(expressinterest=users[0].split("_")[1]))
        else:
            rows_changed = Matchglass.query.filter_by(id=users[0].split("_")[0],status='active').update(dict(expressinterest=users[0].split("_")[1]))
            rows_changed = Matchglass.query.filter_by(id=users[1].split("_")[0],status='active').update(dict(expressinterest=users[1].split("_")[1]))
        db.session.commit()
    return render_template('main.html',options=["Bird","Face"])


@app.route('/updatematch',methods=['GET', 'POST'])
def updatematch():
    users=[]
    con = eng.connect()
    if request.method == 'POST':
        users = request.form.getlist('user')
        print "------"
        print users
        print "------"
        rows_changed = Matchglass.query.filter_by(id=users[0]).update(dict(matchpin='1'))
        rows_changed = Matchglass.query.filter_by(id=users[1]).update(dict(matchpin='1'))
        db.session.commit()
    query_template = "select * from matchglass WHERE id in ({})".format(",".join(users))
    print query_template
    active_users = con.execute(query_template)
    users = active_users.fetchall()
    temp = users
    retval =[]
    row = (str(temp[0][0])+"_"+str(temp[1][0]) , users[0])
    retval.append(row)
    row = (str(temp[1][0])+"_"+str(temp[0][0]) , users[1])
    retval.append(row)
    print retval
    return render_template('expressinterest.html',users=retval)

@app.route('/user/<name>')
def thanks(name):
    message = "Thanks! Collect your glass and prepare to find your match."
    return render_template('thankyou.html',status = message)

@app.route('/check', methods=['GET', 'POST'])
def checkinterest():
    data="Checking"
    if request.method == 'POST':
        users = request.form['txt_user']
        con = eng.connect()
        query = con.execute("select * from matchglass where expressinterest=(select id from matchglass where name='{}')".format(users))
        print query
        result = query.fetchall()
        print result
        if len(result)>0:
            data = result[0][1]+" expressed interest in you :)"
        else:
            data = "Sorry your date did not express interest"
    return render_template('thankyou.html',data=data)
if __name__ == "__main__":
    global name
    global email
    global radio
    global colorbox
    #db.drop_all()
    #db.create_all()
    app.run()

