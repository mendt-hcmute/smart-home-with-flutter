import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/foundation.dart';

class DatabaseManager extends ChangeNotifier {
  late mongo.Db db;
  late mongo.DbCollection collection;

  DatabaseManager() {}
  Future<void> connectToDatabase() async {
    db = await mongo.Db.create(
        "mongodb+srv://nguyenuser:Lamtraidung2910@cluster0.jwetr6j.mongodb.net/sensors_db");
    // db = await mongo.Db.create(
    //     "mongodb+srv://myuser:myuser@cluster1.eqcvw4o.mongodb.net/sensor_db");
    await db.open();
    if (db.isConnected) {
      print("Connected to database");
      collection = db.collection('sensor');
    } else {
      print("Error occurred and cannot connect to database");
    }
  }

  Future<double?> findTemperatureValue() async {
    var res = await collection.findOne(mongo.where.eq('sensor_id', 'dht22_1'));

    if (res != null &&
        res.containsKey('readings') &&
        res['readings'].containsKey('temperature')) {
      return res['readings']['temperature'] as double?;
    } else {
      print("khong tim thay nhiet do");
      return null;
    }
  }

  Future<double?> findHumidityValue() async {
    var res = await collection.findOne(mongo.where.eq('sensor_id', 'dht22_1'));

    if (res != null &&
        res.containsKey('readings') &&
        res['readings'].containsKey('humidity')) {
      return res['readings']['humidity'] as double?;
    } else {
      print("not found humidity");
      return null;
    }
  }

  Future<int?> findGasValue() async {
    var res = await collection.findOne(mongo.where.eq('sensor_id', 'mq2'));

    if (res != null && res.containsKey('readingGas')) {
      return res['readingGas'] as int?;
    } else {
      print('not found gas');
      return null;
    }
  }

  Future<String?> findAirConditionState() async {
    var res =
        await collection.findOne(mongo.where.eq('sensor_id', 'air_condition'));

    if (res != null && res.containsKey('status')) {
      return res['status'] as String?;
    } else {
      print('not found state aircondition');
      return null;
    }
  }

  Future<String?> findFanState() async {
    var res = await collection.findOne(mongo.where.eq('sensor_id', 'fan'));

    if (res != null && res.containsKey('status')) {
      return res['status'] as String?;
    } else {
      print('not found fan state');
      return null;
    }
  }

  Future<String?> findLight1State() async {
    var res = await collection.findOne(mongo.where.eq('sensor_id', 'light1'));

    if (res != null && res.containsKey('status')) {
      return res['status'] as String?;
    } else {
      print('not found light1 state');
      return null;
    }
  }

  Future<String?> findLight2State() async {
    var res = await collection.findOne(mongo.where.eq('sensor_id', 'light2'));

    if (res != null && res.containsKey('status')) {
      return res['status'] as String?;
    } else {
      print('not found light2 state');
      return null;
    }
  }

//AC : Air condition - Temperature too hot --> auto turn on AC
  Future<void> changeACToON() async {
    var res = await collection.updateOne(
        mongo.where.eq('sensor_id', 'air_condition'),
        mongo.modify.set('status', 'HIGH'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Air_condition status modified: ${res.nModified}'); // 1
  }

  Future<void> changeACToOFF() async {
    var res = await collection.updateOne(
        mongo.where.eq('sensor_id', 'air_condition'),
        mongo.modify.set('status', 'LOW'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Air_condition status modified: ${res.nModified}'); // 1
  }

//Fan - Gas too much --> turn on fan

  Future<void> changeFanToOFF() async {
    var res = await collection.updateOne(
        mongo.where.eq('sensor_id', 'fan'), mongo.modify.set('status', 'LOW'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Fan status modified: ${res.nModified}'); // 1
  }

  Future<void> changeFanToON() async {
    var res = await collection.updateOne(
        mongo.where.eq('sensor_id', 'fan'), mongo.modify.set('status', 'HIGH'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Fan status modified: ${res.nModified}'); // 1
  }

//Buzz: gas too much --> turn on buzz

  Future<void> changeBuzzToON() async {
    var res = await collection.updateOne(
        mongo.where.eq('sensor_id', 'buzz'), mongo.modify.set('status', 'HIGH'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Buzz status modified: ${res.nModified}');
  }

  Future<void> changeBuzzToOFF() async {
    var res = await collection.updateOne(
        mongo.where.eq('sensor_id', 'buzz'), mongo.modify.set('status', 'LOW'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Buzz status modified: ${res.nModified}');
  }

//Light 1: có chuyển động --> auto turn on
  Future<void> changeLight1ToON() async {
    var res = await collection.updateOne(mongo.where.eq('sensor_id', 'light1'),
        mongo.modify.set('status', 'HIGH'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Light1 status documents: ${res.nModified}');
  }

  Future<void> changeLight1ToOFF() async {
    var res = await collection.updateOne(mongo.where.eq('sensor_id', 'light1'),
        mongo.modify.set('status', 'LOW'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Light1 status documents: ${res.nModified}');
  }

//Light2: cường độ ánh sáng k đủ --> turn on
  Future<void> changeLight2ToON() async {
    var res = await collection.updateOne(mongo.where.eq('sensor_id', 'light2'),
        mongo.modify.set('status', 'HIGH'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Light2 status documents: ${res.nModified}');
  }

  Future<void> changeLight2ToOFF() async {
    var res = await collection.updateOne(mongo.where.eq('sensor_id', 'light2'),
        mongo.modify.set('status', 'LOW'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Light2 status documents: ${res.nModified}');
  }

  Future<void> updateEnegyOfAC(double newData, double oldData, int day) async {
    var res = await collection.updateOne(
      mongo.where.eq('name_device', 'air_condition'),
      mongo.modify.set('total_time_on_a_day.$day', oldData + newData),
      writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000),
    );
    print('Air_condition day modified: ${res.nModified}'); // 1
    print('Updated aircondition time consumed');
  }

  Future<void> updateEnegyOfFan(double newData, double oldData, int day) async {
    var res = await collection.updateOne(
      mongo.where.eq('name_device', 'fan'),
      mongo.modify.set('total_time_on_a_day.$day', oldData + newData),
      writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000),
    );
    print('Fan day modified: ${res.nModified}'); // 1
    print('Updated Fan time consumed');
  }

  Future<double?> findOldEnegyOfAC(int day) async {
    var res = await collection
        .findOne(mongo.where.eq('name_device', 'air_condition'));

    if (res != null && res.containsKey('total_time_on_a_day')) {
      print("found old enery of AC");
      return res['total_time_on_a_day'][day] as double?;
    } else {
      print('not found time of day');
      return null;
    }
  }

  Future<double?> findOldEnegyOfFan(int day) async {
    var res = await collection.findOne(mongo.where.eq('name_device', 'fan'));

    if (res != null && res.containsKey('total_time_on_a_day')) {
      print("found old enery of fan");
      return res['total_time_on_a_day'][day] as double?;
    } else {
      print('not found time of day');
      return null;
    }
  }

  Future<double?> findOldEnegyOfLight1(int day) async {
    var res = await collection.findOne(mongo.where.eq('name_device', 'light1'));

    if (res != null && res.containsKey('total_time_on_a_day')) {
      print("found old enery of light1");
      return res['total_time_on_a_day'][day] as double?;
    } else {
      print('not found time of day');
      return null;
    }
  }

  Future<void> updateEnegyOfLight1(
      double newData, double oldData, int day) async {
    var res = await collection.updateOne(
      mongo.where.eq('name_device', 'light1'),
      mongo.modify.set('total_time_on_a_day.$day', oldData + newData),
      writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000),
    );
    print('light1 day modified: ${res.nModified}'); // 1
    print('Updated light1 time consumed');
  }
}
