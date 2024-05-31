import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OpenWeatherAPI {
  final String apiKey;

  const OpenWeatherAPI(this.apiKey);

  Future<Map> getWeatherDetails(
      {required double lat, required double lon}) async {
    print('Getting weather details...');

    var url =
        "https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$lat&lon=$lon&appid=$apiKey";

    var res = await http.get(Uri.parse(url));
    print(res.body);
    return jsonDecode(res.body);
  }

  String getWeatherIcon(String icon) {
    return "http://openweathermap.org/img/wn/$icon@4x.png";
  }

  String getBackgroundImage(int code, String name) {
    if (code >= 200 && code < 300) {
      return "assets/backgrounds/Thunderstorm.jpg";
    } else if (code >= 300 && code < 400) {
      return "assets/backgrounds/Drizzle.jpg";
    } else if (code >= 500 && code < 600) {
      return "assets/backgrounds/Rain.jpg";
    } else if (code >= 600 && code < 700) {
      return "assets/backgrounds/Snow.jpg";
    } else if (code >= 700 && code < 800) {
      switch (name) {
        case "Mist":
          return "assets/backgrounds/Mist.jpg";
        case "Smoke":
          return "assets/backgrounds/Smoke.jpg";
        case "Haze":
          return "assets/backgrounds/Haze.jpg";
        case "Dust":
          return "assets/backgrounds/Dust.jpg";
        case "Fog":
          return "assets/backgrounds/Fog.jpg";
        case "Sand":
          return "assets/backgrounds/Sand.jpg";
        case "Ash":
          return "assets/backgrounds/Ash.jpg";
        case "Squall":
          return "assets/backgrounds/Squall.jpg";
        case "Tornado":
          return "assets/backgrounds/Tornado.jpg";
        default:
          return "assets/backgrounds/Thunderstorm.jpg";
      }
    } else if (code == 800) {
      return "assets/backgrounds/Clear.jpg";
    } else if (code > 800) {
      switch (code) {
        case 801:
          return "assets/backgrounds/Clouds-1.jpg";
        case 802:
          return "assets/backgrounds/Clouds-2.jpg";
        case 803:
          return "assets/backgrounds/Clouds-3.jpg";
        case 804:
          return "assets/backgrounds/Clouds-4.jpg";
        default:
          return "assets/backgrounds/Clouds-1.jpg";
      }
    } else {
      return "https://source.unsplash.com/1600x900/?$name";
    }
  }

  getTimeString(int time) {
    final DateFormat sunTimeFormat = DateFormat("hh:mm a");
    var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var local = date.toLocal();
    return sunTimeFormat.format(local);
  }
}
