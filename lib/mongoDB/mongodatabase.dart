import 'package:mongo_dart/mongo_dart.dart';
import 'package:uberdrivernew/mongoDB/constant.dart';

class MongoDatabase {
  static Db? _db;
  static DbCollection? _collection;
  static DateTime? time;

  static Future<void> connect() async {
    _db = await Db.create(MONGO_URL);
    await _db!.open();
    _collection = _db!.collection(COLLECTION_NAME);
  }

  static Future<void> insertDriver(
      String? name, String? email, String? phone, String? password) async {
    if (_db == null) {
      await connect();
    }

    await _collection!.insert({
      'id': time!.millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    });
  }
  static Future<void> insertCarDetail(
      String? carColor,String? email, String? carNumber, String? carModel, String? carType) async {
    if (_db == null) {
      await connect();
    }

    var collectionCarDetail = _db!.collection(COLLECTIONCARDETAIL);

    await collectionCarDetail.insert({
      'id': time!.millisecondsSinceEpoch.toString(),
      'email': email,
      'car_color': carColor,
      'car_number': carNumber,
      'car_model': carModel,
      'car_type': carType,
    });
  }
  static checkDriverisValid(String? email, String? password) async {
    if (_db == null) {
      await connect();
    }
    var query = where.eq('email', email).eq('password', password);
    var user = await _collection!.findOne(query);
    return user;
  }

  static checkCarIsValid(String? email) async {
    if (_db == null) {
      await connect();
    }
    var query = where.eq('email', email);
    var collectionCarDetail = _db!.collection(COLLECTIONCARDETAIL);
    var car = await collectionCarDetail.findOne(query);
    return car;
  }
}
