import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService{

  static const Base_URL="http://api.openweathermap.org/data/2.5/weather";
  final String apikey;

  WeatherService(this.apikey);

  Future <Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$Base_URL?q=$cityName&appid=$apikey&units=metric'));
    if(response.statusCode==200){
      print(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('failed to lead weather data');
    }
  }

  Future <String> getcurrentcity() async{
    LocationPermission permission = await Geolocator.checkPermission();

    // get permisssion location
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    // fetch  the  current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    // CONVERT THE LOCATION INTO A LIST OF PLACEMARK OBJECTS
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    // extract the city name from te first placemark

    String? city= placemark[0].locality;
    return city ?? "";
  }

}