import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var lat;

  // @override
  // void initState() {
  //   super.initState();
  //   getLocation();
  //
  // }

  getLocation()async{
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    lat = position.latitude;
    longi = position.longitude;
    final queryParameter = {
      'lat': lat.toString(),
      'lon': longi.toString(),
      'appid': "d712d2247a2c332dcce11f913720e2a7",
    };
    Uri uri = Uri.https("api.openweathermap.org","/data/2.5/weather",queryParameter);
    final response = await get(uri);
    final result = jsonDecode(response.body);

    setState((){
      temparature = result["main"]["temp"];
      description = result["weather"][0]["main"];
      currentCity = result["name"];
      iconId = result["weather"][0]["icon"];
      humidity = result["main"]["humidity"];
      feelsLike = result["main"]["feels_like"];
    });
  }

  var temparature;
  var description;
  var currentCity;
  var iconId = "10d";
  var lati;
  var longi;
  var showCurrentCity;
  var humidity;
  var feelsLike;

  TextEditingController cityNameController = new TextEditingController();
  void getWeather() async {
    print("Clicked");
    String cityName = cityNameController.text;
    print(cityName);
    final mp = {
      "q":cityName,
      "appid":"d712d2247a2c332dcce11f913720e2a7"
    };
    Uri uri = Uri.https("api.openweathermap.org", "/data/2.5/weather", mp);
    final response = await get(uri);
    var result = jsonDecode(response.body);

    setState((){
      temparature = result["main"]["temp"];
      description = result["weather"][0]["main"];
      currentCity = result["name"];
      iconId = result["weather"][0]["icon"];
      humidity = result["main"]["humidity"];
      feelsLike = result["main"]["feels_like"];
    });

  }
  showCityName(){
    setState(() {
      showCurrentCity = currentCity;
    });

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.purple.shade200,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: Text("Weather App"),
        ),
        body:
        Center(
          child : SingleChildScrollView(
          child :
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text((showCurrentCity == null) ? "" : showCurrentCity),
                ElevatedButton(onPressed: getLocation, child: Text("Current Location")),
                Image.network("http://openweathermap.org/img/wn/${iconId}@2x.png"),
                
                Text("Currently in "+(currentCity == null ? "Loading" : currentCity),
                style: TextStyle(fontSize: 30,
                backgroundColor: Colors.purpleAccent.shade200),),
                SizedBox(height: 20,),

                Text("Tempatature : "+(temparature == null ? "Loading" : (temparature - 273).toStringAsFixed(2).toString())+"\u00B0 celsious",
                style: TextStyle(fontSize: 35,
                backgroundColor: Colors.purpleAccent.shade100,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),

                Text("Weather : "+(description == null ? "Loading" : description),
                style: TextStyle(fontSize: 30,
                backgroundColor: Colors.purple.shade100),
                ),
                SizedBox(height: 20,),

                Text("Feels like : "+(feelsLike == null ? "Loading" : (feelsLike - 273).toStringAsFixed(2))+"\u00B0 celsious",
                  style: TextStyle(fontSize: 30,
                      backgroundColor: Colors.purple.shade100),
                ),
                SizedBox(height: 20,),

                Text("Humidity : "+(humidity == null ? "Loading" : humidity.toString()),
                style: TextStyle(fontSize: 30,
                backgroundColor: Colors.purple.shade50),
                ),

                SizedBox(
                  width: 200,
                    child: TextField(
                      decoration: new InputDecoration(
                        hintText: "Enter city name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)
                        )
                      ),
                      controller: cityNameController,
                      textAlign: TextAlign.center,
                      style:TextStyle(fontSize: 20),
                    )
                ),
                ElevatedButton(
                    onPressed: getWeather,
                    child: Text("Search",
                    style: TextStyle(fontSize: 20),))
              ],
            )
          )
      // )
      )
    )
    );
  }
}
