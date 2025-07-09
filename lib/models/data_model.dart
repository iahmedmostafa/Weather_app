import 'package:intl/intl.dart';

class DataModel {
  int? visibility;
  String? name;
  int? id;
  List<WeatherModel>? weather;
  MainModel? main;
  WindModel? wind;
  SysModel? system;

  DataModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    id = map['id'];
    visibility = map['visibility'];
    main = MainModel.fromMap(map['main']);
    wind = WindModel.fromMap(map['wind']);
    system= SysModel.fromMap(map['sys']);
    weather = [];
    var mapList = map['weather'] as List;
    for (var element in mapList) {
      weather?.add(WeatherModel.fromMap(element));
    }
  }
}

class WeatherModel {
  String? main;
  String? description;

  WeatherModel.fromMap(Map<String, dynamic> map) {
    main = map['main'];
    description = map['description'];
  }
  Map<String, dynamic> toMap() {
    return {"main": main, "description": description};
  }
}

class MainModel {
  double? temp;
  double? tempMax;
  double? tempMin;
  int? pressure;
  int? humidity;

  MainModel.fromMap(Map<String, dynamic> map) {
    temp = map['temp']- 273.15;
    tempMin = map['temp_min']- 273.15;
    tempMax = map['temp_min']- 273.15;
    pressure = map['pressure'];
    humidity = map['humidity'];
  }

  Map<String, dynamic> toMap() {
    return {
      "temp": temp,
      "temp_max": tempMax,
      "temp_min": tempMin,
      "pressure": pressure,
      "humidity": humidity,
    };
  }
}

class WindModel {
  double? speed;
  double? gust;

  WindModel.fromMap(Map<String, dynamic> map) {
    speed = map['speed'];
    gust = map['gust'];
  }
  Map<String, dynamic> toMap() {
    return {"speed": speed, "gust": gust};
  }
}


class SysModel {
  DateTime? sunrise;
  DateTime? sunset;

  SysModel.fromMap(Map<String, dynamic> map) {
    sunrise = DateTime.fromMillisecondsSinceEpoch(map['sunrise'] * 1000).toLocal();
    sunset = DateTime.fromMillisecondsSinceEpoch(map['sunset'] * 1000).toLocal();
  }

  Map<String, dynamic> toMap() {
    return {
      "sunrise": sunrise?.millisecondsSinceEpoch.truncate(),
      "sunset": sunset?.millisecondsSinceEpoch.truncate(),
    };
  }


  String get sunriseFormatted =>
      sunrise != null ? DateFormat('h:mm a').format(sunrise!) : "N/A";

  String get sunsetFormatted =>
      sunset != null ? DateFormat('h:mm a').format(sunset!) : "N/A";
}

