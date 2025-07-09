import 'package:dio/dio.dart';
import 'package:weather_app/models/data_model.dart';
//
// void main()async {
//    WeatherServices weatherServices = WeatherServices();
//    Map<String,dynamic> data= await weatherServices.fetchCityWeather("Cairo");
//    final weatherData= DataModel.fromMap(data);
//    print(weatherData.name);
//
//
//
//
// }

class WeatherServices {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );
  final String _apiKey = "451624183cf28bd4f1c61b2894f4676f";

   Future<Map<String,dynamic>> fetchCityWeather(String city) async {
    try {
      Response response = await _dio.get(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey",
      );
      print(response.statusCode);
      return(response.data);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchWeatherByLocation(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'units': 'metric',
          'appid': _apiKey,
        },
      );

      return response.data;
    } catch (e) {
      print("Error while fetching weather by location: $e");
      throw Exception('Failed to load weather data');
    }
  }
}


