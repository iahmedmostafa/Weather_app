import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/app_icons.dart';
import 'package:weather_app/core/app_images.dart';
import 'package:weather_app/models/data_model.dart';
import 'package:weather_app/services/location_helper.dart';
import 'package:weather_app/widgets/custom_text_field.dart';
import 'dart:async';
import '../services/weather_services.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;
  late DataModel weatherData ;
  WeatherServices weatherServices=WeatherServices();
  bool isLoading=true;
  Timer? _debounce;
  String? _bgImage;
  String? _icImage;



  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
    super.initState();
    if (_controller.text.isEmpty) {
      getLocationAndFetchWeather();
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final data = await weatherServices.fetchCityWeather(_controller.text);
      weatherData = DataModel.fromMap(data);
      updateWeatherImages(weatherData.weather![0].main!);
    } catch (e) {
      print("Error fetching city weather: $e");
    }
    setState(() => isLoading = false);
  }

  Future<void> getLocationAndFetchWeather() async {
    setState(() => isLoading = true);
    try {
      final position = await LocationHelper.getCurrentLocation();

      late Map<String, dynamic> data;

      if (position != null) {
        data = await weatherServices.fetchWeatherByLocation(
          position.latitude,
          position.longitude,
        );
      } else {
        print("Location not available, fallback to Cairo");
        data = await weatherServices.fetchCityWeather("Cairo");
      }

      weatherData = DataModel.fromMap(data);
      updateWeatherImages(weatherData.weather![0].main!);
    } catch (e) {
      print("Error fetching weather: $e");
    }

    setState(() => isLoading = false);
  }
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_controller.text.trim().isNotEmpty) {
        print("Search triggered for: ${_controller.text}");
        fetchData();
      }
    });
  }
  void updateWeatherImages(String condition) {
    switch (condition) {
      case "Rain":
        _bgImage = AppImages.rain;
        _icImage = AppIcons.rain;
        break;
      case "Clouds":
        _bgImage = AppImages.clouds;
        _icImage = AppIcons.clouds;
        break;
      case "Fog":
        _bgImage = AppImages.fog;
        _icImage = AppIcons.haze2;
        break;
      case "Haze":
        _bgImage = AppImages.haze;
        _icImage = AppIcons.haze;
        break;
      case "Clear":
        _bgImage = AppImages.clear;
        _icImage = AppIcons.clear;
        break;
      case "Thunderstorm":
        _bgImage = AppImages.thunderstorm;
        _icImage = AppIcons.thunderstorm;
        break;
      default:
        _bgImage = AppImages.clear;
        _icImage = AppIcons.clear;
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading==true?Center(child: CircularProgressIndicator()):
      Stack(
        children: [
          Image(
            image: AssetImage(_bgImage??"assets/images/clear.jpg"),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 50.h,
            right: 10.w,
            left: 10.w,
            child: CustomTextField(controller: _controller),
          ),
          Positioned(
            top: 135.h,
            right: 10.w,
            left: 10.w,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on,color: Colors.black,size: 25.sp,),
                Text("${weatherData.name}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),)
              ],
            )
          ),
          Positioned(
              top: 220.h,
              left: 15.w,
              child:Text("${weatherData.main!.temp!.toStringAsFixed(2)}\u00B0C",style: TextStyle(fontSize: 70.sp,fontWeight: FontWeight.bold,color: Colors.black),)
          ),
          Positioned(
              top: 280.h,
              left: 20.w,
              child:Row(
                children: [
                  Text("${weatherData.weather![0].description}",style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.normal,color: Colors.black),),
                  SizedBox(width: 30.w,),
                  Image.asset(_icImage??"assets/icons/Clear.png",width: 90.w,height: 120.h,)
                ],
              ),
          ),
          Positioned(
            top: 390.h,
            right: 10.w,
            left: 20.w,
            child:Row(
              children: [
                Icon(Icons.arrow_upward,color: Colors.black,size: 18.sp,),
                Text("${weatherData.main!.tempMax!.truncateToDouble()}\u00B0C",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,fontStyle: FontStyle.italic,color: Colors.black),),
                SizedBox(width:10.w),
                Icon(Icons.arrow_downward,color: Colors.black,size: 18.sp,),
                Text("${weatherData.main!.tempMin!.truncateToDouble()}\u00B0C",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,fontStyle: FontStyle.italic,color: Colors.black),),
              ],
            ),
          ),
          Positioned(
            top: 490.h,
            right: 10.w,
            left: 10.w,
            child:Container(
              width:300.w ,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(.2),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Sunrise",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${weatherData.system!.sunriseFormatted}",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,color: Colors.white.withOpacity(.7)),),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Sunset",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${weatherData.system!.sunsetFormatted}",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,color: Colors.white.withOpacity(.7)),),
                        ],
                      ),
                     ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Pressure",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${weatherData.main!.pressure}",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,color: Colors.white.withOpacity(.7)),),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Humidity",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${weatherData.main!.humidity}",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,color: Colors.white.withOpacity(.7)),),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Visibility",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${weatherData.visibility}",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,color: Colors.white.withOpacity(.7)),),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Wind Speed",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${weatherData.wind!.speed} km/h",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.normal,color: Colors.white.withOpacity(.7)),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }
}
