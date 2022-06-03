import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shop24x7/Home.dart';

class ProductMenu extends StatefulWidget {
  const ProductMenu({Key? key}) : super(key: key);

  @override
  State<ProductMenu> createState() => _ProductMenuState();
}

class _ProductMenuState extends State<ProductMenu> {
  @override
  /* initializing variable*/
  List? data;
  var value, name, description, rating, url;
  List image = [];
  late final myBox;
  bool shouldPop = true;
/*-----------------------*/
  Future<String> get_Data() async {
    List _items = [];

    await Hive.openBox('Product_box');
    myBox = Hive.box('Product_box');

    var BIGdata = myBox.keys.map((key) async {
      value = await myBox.get(key);
      for (int i = 0; i < value.length; i++) {
        image.add(value[i]["productImage"]);
      }
    }).toList();
    setState(() {
      value = value;
    });

    return 'success';
  }

  @override
  void initState() {
    super.initState();
    this.get_Data();
  }

  void val(int index) async {
    name = value[index]['ProductName'];
    description = value[index]['productDescription'];
    rating = value[index]['productRating'];
    url = value[index]['productUrl'];
  }

  bool _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homepage()));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: value == null ? Colors.white : Colors.blue[50],
            appBar: AppBar(
              title: Text("Shop24x7!"),
              backgroundColor: Color(0xFF8F48F7),
            ),
            body: value == null
                ? Center(child: Image.asset('assets/images/loading.gif'))
                : ListView.builder(
                    itemCount: value == null ? 0 : value!.length,
                    itemBuilder: (BuildContext context, int index) {
                      val(index);
                      return ExpandableNotifier(
                          child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: GestureDetector(
                              child: Center(
                            child:
                                Stack(alignment: Alignment.center, children: <
                                    Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(alignment: Alignment.center, children: <
                                      Widget>[
                                    Column(children: [
                                      Text(name,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.pink)),
                                      ScrollOnExpand(
                                        scrollOnExpand: true,
                                        scrollOnCollapse: false,
                                        child: ExpandablePanel(
                                          theme: const ExpandableThemeData(
                                            headerAlignment:
                                                ExpandablePanelHeaderAlignment
                                                    .center,
                                          ),
                                          collapsed: Linkify(
                                            onOpen: (link) {},
                                            text:
                                                "Description:-\n" + description,
                                            softWrap: true,
                                            maxLines:
                                                image[index] != "null" ? 3 : 7,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          header: SizedBox(
                                            height: 0,
                                            width: 0,
                                          ),
                                          expanded: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10, left: 2),
                                                  child: Linkify(
                                                    onOpen: (link) {},
                                                    text: "Description:-\n" +
                                                        description,
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  )),
                                              Container(
                                                  child: Container(
                                                child: Card(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    child: Container(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 7,
                                                                vertical: 8),
                                                        child:
                                                            Column(children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text("Url:-",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200)),
                                                          ),
                                                          Text(
                                                            url,
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                    )),
                                              )),
                                            ],
                                          ),
                                          builder: (_, collapsed, expanded) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              child: Expandable(
                                                collapsed: collapsed,
                                                expanded: expanded,
                                                theme:
                                                    const ExpandableThemeData(
                                                        crossFadePoint: 0),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                          height: 250,
                                          child: Image.asset(image[index])),
                                    ]),
                                  ]),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.star_border),
                                              Text(
                                                rating,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          )),
                        ),
                      ));
                    })),
      ),
    );
  }
}
