import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      Map<String, dynamic> userData = json.decode(response.body);
      List<dynamic> users = userData['results'];
      setState(() {
        data = users;
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONNECT TO A WEB SERVICE AND TO RETRIEVE DATA '),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var user = data[index];
          var picture = user['picture'];
          var address = user['location'];
          var coordinates = address['coordinates'];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(picture['large']),
              ),
              title: Text(
                'Author: ${user['name']['first']} ${user['name']['last']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text('Email: ${user['email']}'),
                  SizedBox(height: 5),
                  Text(
                      'Street: ${address['street']['name']} ${address['street']['number']}'),
                  SizedBox(height: 5),
                  Text('City: ${address['city']}'),
                  SizedBox(height: 5),
                  Text('Latitude: ${coordinates['latitude']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
