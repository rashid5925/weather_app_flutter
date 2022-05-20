// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/util/apifile.dart' as util;
import 'package:http/http.dart' as http;

class Climate extends StatefulWidget {
  @override
  _ClimateState createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  static String _cityEntered = "Rawalpindi";
  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
  }

  Future _goToNextScreen(BuildContext context) async {
    Map? results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
              onPressed: () => _goToNextScreen(context),
              icon: const Icon(Icons.menu))
        ],
      ),
      body: Stack(
        children: <Widget>[
          const Center(
            child: Image(
              image: AssetImage("assets/images/background.jpeg"),
              height: 1200.0,
              width: 590.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              _cityEntered,
              style: cityStyle(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.apiId}&units=imperial';
    http.Response response = await http.get(Uri.parse(apiUrl));

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.apiId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.requireData;
            return Container(
              margin: EdgeInsets.fromLTRB(0.0, 280.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "${content['main']['temp'].toString()}" + "F",
                      style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: ListTile(
                      title: Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                        "Min: ${content['main']['temp_min'].toString()}\n"
                        "Max: ${content['main']['temp_max'].toString()}",
                        style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  final _cityFieldController = new TextEditingController();

  ChangeCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Change City"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
              child: Image.asset(
            "assets/images/snow.jpeg",
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,
          )),
          ListView(
            children: [
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {'enter': _cityFieldController});
                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: Text("Search")),
              )
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}
