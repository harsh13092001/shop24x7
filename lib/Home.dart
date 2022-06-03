import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'product.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  List? data;
  var value;
  late final myBox;
  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/product.json');
    setState(() => data = json.decode(jsonText));
    await Hive.openBox('Product_box');
    myBox = Hive.box('Product_box');
    await myBox.put('Product_box', data);

    return 'success';
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            width / 12, height / 3, width / 12, height / 24),
        child: Column(
          children: [
            Text("shop24x7!",
                style: TextStyle(fontSize: 60, color: Color(0xFA8F48FF))),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    loadJsonData();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProductMenu()));
                  },
                  color: Colors.amber,
                  child: Text('Signin'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
