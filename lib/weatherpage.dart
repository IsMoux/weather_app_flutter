import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/service/weather_service.dart';

import 'model/weather_model.dart';

class Weatherpage extends StatefulWidget{
  Weatherpage({super.key});

  @override
  State<Weatherpage> createState()=> _WeatherpageState();
}

class _WeatherpageState extends State<Weatherpage>{
  //api key
  final _weatherService=WeatherService('92e2fe9e75a98f79a1739b15ca243ff4');
  Weather? _weather;

  //fetch weather
  _fetchweather() async {
    //get the current city
    String cityName= await _weatherService.getcurrentcity();
    // get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather=weather;
      });
    }catch(e){
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition){
    if(mainCondition==null) return 'assets/sun.json';
    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzie':
      case 'shower rain':
        return 'assets/running.json';
      case'thunderstorm':
        return 'assets/not_clear.json';
      case'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }
  @override
  void initState() {
    super.initState();

    _fetchweather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text("My weather APP"),
        backgroundColor: Colors.purple,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 15),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "loading city..",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text("${_weather?.temperature.round()}C",style: TextStyle(color: Colors.purple,fontSize: 20),),
            Text(_weather?.mainCondition?? "",style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }

}