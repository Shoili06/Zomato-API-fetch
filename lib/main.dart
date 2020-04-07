import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var data;

  TextEditingController place = TextEditingController();

  bool isDataLoaded = false;


  Future<String> getJsonData(String placeName) async {
    var response = await http.get(
      Uri.encodeFull(
          "https://developers.zomato.com/api/v2.1/search?entity_type=city&q=$placeName&count=1000"),
      headers: {
        "Accept": "application/json",
        "user-key": "API key"
      },
    );

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['restaurants'];
      isDataLoaded = true;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Restaurants"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: place,
                    decoration: InputDecoration(
                      hintText: 'Search..',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => getJsonData(place.text),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: isDataLoaded
                    ? ListView.builder(
                        itemBuilder: (_, int index) => Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                data[index]['restaurant']['name'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Divider(
                                height: 20,
                                color: Colors.transparent,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Price Range :  ",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data[index]['restaurant']['price_range']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Average cost for two :  ",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data[index]['restaurant']
                                            ['currency']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    data[index]['restaurant']
                                            ['average_cost_for_two']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        itemCount: data.length,
                      )
                    : Center(
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.black,
                    size: 200,
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
