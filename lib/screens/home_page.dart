import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:simple_weather_app/constants.dart';
import 'package:simple_weather_app/keys.dart';
import 'package:simple_weather_app/screens/weather_info_widget.dart';
import 'package:simple_weather_app/weather/openweather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final openWeatherApi = const OpenWeatherAPI(OPEN_WEATHER_API_KEY);
  late Timer timer;
  dynamic data;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      print("Refreshing data...");
      setState(
        () {},
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: openWeatherApi.getWeatherDetails(
            lat: 51.2230,
            lon: 6.7825,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              data = snapshot.data;
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              print("Loading data...");
            }

            if (data == null) return const Text("No data found");

            var feelsLike = data["main"]["feels_like"];
            var code = data["weather"][0]["id"];
            var name = data["weather"][0]["main"];
            var backgroundImage = openWeatherApi.getBackgroundImage(code, name);
            var minTemp = data["main"]["temp_min"];
            var maxTemp = data["main"]["temp_max"];
            var humidity = data["main"]["humidity"];
            var pressure = data["main"]["pressure"];
            var windSpeed = data["wind"]["speed"];
            var windDir = data["wind"]["deg"];
            var sunrise = data["sys"]["sunrise"];
            var sunset = data["sys"]["sunset"];
            var icon = data['weather'][0]['icon'];
            var temp = data["main"]["temp"];
            var city = data["name"];
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kTitleBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                          ),
                          child: Column(
                            children: [
                              Image.network(
                                openWeatherApi.getWeatherIcon(icon),
                                width: 150,
                                height: 150,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$temp",
                                    style: GoogleFonts.poppins(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  ),
                                  const Text("°C")
                                ],
                              ),
                              Text("Feels like: $feelsLike °C"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_pin, size: 16),
                                  Text(
                                    city,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      height: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WeatherInfoWidget(
                                    icon: MdiIcons.thermometerLow,
                                    iconColor: Colors.blue[600],
                                    label: "$minTemp°C",
                                  ),
                                  const SizedBox(width: 16),
                                  WeatherInfoWidget(
                                    icon: MdiIcons.thermometerHigh,
                                    iconColor: Colors.red[400],
                                    label: "$maxTemp°C",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WeatherInfoWidget(
                                    icon: MdiIcons.waterPercent,
                                    iconColor: Colors.blue[600],
                                    label: "$humidity%",
                                  ),
                                  const SizedBox(width: 16),
                                  WeatherInfoWidget(
                                    icon: MdiIcons.airballoon,
                                    iconColor: Colors.green[600],
                                    label: "$pressure hPa",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WeatherInfoWidget(
                                    icon: MdiIcons.windsock,
                                    iconColor: Colors.blue[600],
                                    label: "$windSpeed m/s",
                                  ),
                                  const SizedBox(width: 16),
                                  WeatherInfoWidget(
                                    icon: MdiIcons.compass,
                                    iconColor: Colors.red[600],
                                    label: "$windDir°",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WeatherInfoWidget(
                                    icon: MdiIcons.weatherSunsetUp,
                                    iconColor: Colors.blue[600],
                                    label:
                                        openWeatherApi.getTimeString(sunrise),
                                  ),
                                  const SizedBox(width: 16),
                                  WeatherInfoWidget(
                                    icon: MdiIcons.weatherSunsetDown,
                                    iconColor: Colors.amber[600],
                                    label: openWeatherApi.getTimeString(sunset),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
