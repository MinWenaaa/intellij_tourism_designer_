import json
import os
from flask import Blueprint, jsonify, request, send_from_directory
from sqlalchemy.orm.exc import NoResultFound
from model.db_model import Event, Record, Users
from create_app import db
from parser.models_parser import to_dict
from parser.msg_parser import args_missing, data_not_exist, success


user_bp = Blueprint('user', __name__, url_prefix='/user')

@user_bp.route("/")
def home():
    return "???"

@user_bp.route("/login", methods=['GET'])
def login():
    name = request.args.get('name')
    password = request.args.get('password')

    query = db.session.query(
        Users.uid, Users.unickname, Users.upic
    ).filter(
        Users.uname == name,
        Users.upassword == password
    ).limit(1)
    # <class 'sqlalchemy.engine.row.Row'>

    try:
        result = query.one()
        Dict = {key: value for key, value in result._asdict().items()}
        return jsonify(success(Dict))
    except NoResultFound:
        return jsonify(data_not_exist())

    

@user_bp.route("/signup")
def add_user():
    name = request.args.get('name')
    password = request.args.get('password')

    query = Users.query.filter_by(
        uname = name).first()
    
    print(query)
    
    if not query:
        user = Users(uname=name, upassword=password)
        db.session.add(user)
        db.session.commit()
        result = to_dict(user)
        return jsonify(success(result))
    
    else:
        return jsonify(data_not_exist())


@user_bp.route("/create_record", methods=['POST'])
def create_record():

    data = request.get_json()
    print(data)
    id = data['id']
    point = data['start']
    name = data['name']
    print(name)

    record = Record(uid = id, point = [point], name=name)
    print(record.name)

    db.session.add(record)
    db.session.commit()

    return jsonify(success({"id": record.id}))



@user_bp.route("/records", methods=['GET'])
def get_records():
    id = request.args.get('id')

    record_list =  db.session.query(
        Record.id, Record.name,
    ).filter_by(uid=id).all()
    #print(type(record_list[0]))

    result_list = []
    for record in record_list:
        Dict = {key: value for key, value in record._asdict().items()}
        print(dict)

        result_list.append(Dict)

    print(result_list)
    return jsonify(success(result_list))

@user_bp.route("/recordDetail", methods=['GET'])
def get_record_detail():
    id = request.args.get('id')

    record = Record.query.filter_by(id=id).first()


    query = Event.query.filter_by(rid=id).all()

    event_list = []
    for event in query:
        Dict = to_dict(event)
        event_list.append(Dict)
    #print(type(result), type(event_list))

    print(record.point)
    result = {"points": record.point,
              "events": event_list}

    return jsonify(success(result))



@user_bp.route("/push_point", methods=['POST'])
def push_point():

    data = request.get_json()
    id = data['id']
    print(id)
    newPoint = data['point']

    record = Record.query.get(id)
    
    #print(record.point)
    record.point = record.point + [newPoint]
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
    print(record.point)
    return jsonify(success({}))


@user_bp.route('/insertEvent', methods=['POST'])
def upload_image():
 
    if 'file' not in request.files:
        return jsonify(args_missing())
    
    file = request.files['file']
    
    if file.filename == '':
        return jsonify(args_missing())
    
    if file:
        rid = request.form.get('id')
        point = request.form.get('point')
        text = request.form.get('text')

        event = Event(rid=rid, point=point, text=text)
        db.session.add(event)
        db.session.commit()

        id = event.id
        
        filename = str(id)+".jpg"
        file.save(os.path.join('C:\\photos', filename))
        
        return jsonify(success({'id':id}))
    

@user_bp.route('/download/<filename>', methods=['GET'])
def download_file(filename):
    try:

        return send_from_directory(directory='C:\\photos',
                                   path=filename,
                                   as_attachment=True)  # 设置为附件，以便下载
    except FileNotFoundError:
        return jsonify