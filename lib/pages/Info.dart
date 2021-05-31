import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_test/models/Restaurant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/Restaurant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;

class PageInfoRestaurant extends StatefulWidget {
  final Restaurant restaurant;
  const PageInfoRestaurant(this.restaurant, {Key key}) : super(key: key);

  @override
  _PageInfoRestaurantState createState() => _PageInfoRestaurantState();
}

class _PageInfoRestaurantState extends State<PageInfoRestaurant> {
  Future<List<Review>> reseniaList;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    reseniaList = getReviews(this.widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      child: Scaffold(
          //backgroundColor: Color.fromRGBO(249, 189, 39, 1),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              sendResenia(widget.restaurant, context);
              reseniaList = getReviews(this.widget.restaurant);
            },
            child: const Icon(
              FontAwesomeIcons.pen,
              color: Colors.white,
              size: 18,
            ),
            backgroundColor: Color.fromRGBO(255, 182, 0, 1),
          ),
          body: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(249, 189, 39, 1),
                        Color.fromRGBO(251, 249, 246, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Stack(children: [
                          Opacity(
                              opacity: 0.5,
                              child: Text(
                                  '🍔🌭🌮🌯🥗🥙🍕🍟🍖🍗🥓🍱🥘🍲🍛🍜🍪🍔🌭🌮🌯🥗🥙🍕🍟🍖🍗🥓🍱🥘🍲🍛🍜🍪🍔🌭🌮🌯🥗',
                                  style: TextStyle(fontSize: 36),
                                  textAlign: TextAlign.center)),
                          Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.701,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(251, 249, 246, 1),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child: SingleChildScrollView(
                                      child: Center(
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(children: [
                                              SizedBox(height: 100),
                                              Text(
                                                widget.restaurant.name,
                                                textAlign: TextAlign.center,
                                                //style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5)
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                widget.restaurant.types,
                                                textAlign: TextAlign.center,
                                                //style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5)
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                ),
                                              ),
                                              Text(
                                                widget.restaurant.description,
                                                textAlign: TextAlign.center,
                                                //style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5)
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ])),
                                        Container(
                                          height: 400,
                                          padding: EdgeInsets.all(20),
                                          child: FutureBuilder(
                                              future: reseniaList,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          snapshot.data.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    10, 9),
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30)),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          196,
                                                                          196,
                                                                          196,
                                                                          0.15),
                                                                ),
                                                                child: ListTile(
                                                                  onTap: () {},
                                                                  title:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10.0,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .email,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 14)),
                                                                  ),
                                                                  subtitle: Text(snapshot
                                                                      .data[
                                                                          index]
                                                                      .comments),
                                                                  leading:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          28,
                                                                      width: 28,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        FontAwesomeIcons
                                                                            .solidUser,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  trailing: Text(
                                                                      "⭐️ " +
                                                                          snapshot
                                                                              .data[
                                                                                  index]
                                                                              .rating
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18)),
                                                                )));
                                                      });
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  )))),
                          Positioned(
                              top: 100,
                              left: 50,
                              right: 50,
                              child: Row(
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.only(right: 18, top: 100),
                                      child: Text(
                                          '⭐️ ' +
                                              widget.restaurant.rating
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  Container(
                                      height: 190,
                                      width: 190,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                255, 182, 0, 0.5),
                                            spreadRadius: 0,
                                            blurRadius: 23,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(30),
                                      child: paintImage(widget.restaurant)),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 18, top: 100),
                                      child: Icon(FontAwesomeIcons.share,
                                          color: Colors.black, size: 18))
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(24, 64, 0, 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    padding: EdgeInsets.all(10),
                                    child: Icon(FontAwesomeIcons.arrowLeft,
                                        color: Colors.black, size: 18),
                                  ),
                                )),
                          ),
                        ]),
                      ),
                    ],
                  )))),
    ));
  }

  paintImage(Restaurant item) {
    if (item.logo != null && item.logo != "") {
      return Image.network(
        item.logo,
        fit: BoxFit.fill,
      );
    } else {
      return Text("");
    }
  }

  sendResenia(Restaurant restaurant, BuildContext context) {
    TextEditingController textFieldR = TextEditingController(text: "");
    TextEditingController textFieldE = TextEditingController(text: "");
    double ratingR = 0.0;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  width: 150,
                  child: Text("Escribe una reseña",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: RatingBar.builder(
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.yellow[600],
                  ),
                  initialRating: 0,
                  itemCount: 5,
                  itemSize: 20,
                  allowHalfRating: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  tapOnlyMode: false,
                  direction: Axis.horizontal,
                  onRatingUpdate: (value) {
                    ratingR = value;
                  },
                )),
              ],
            ),
            content: Container(
                child: Wrap(children: <Widget>[
              SizedBox(
                  //height: 110,
                  child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Color.fromRGBO(196, 196, 196, 0.15),
                      ),
                      child: TextFormField(
                        controller: textFieldE,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'Correo',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        /**/
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Color.fromRGBO(196, 196, 196, 0.15),
                    ),
                    child: TextFormField(
                      controller: textFieldR,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Comentarios',
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      /**/
                    ),
                  ),
                ),
              ]))
            ])),
            actions: [
              Row(
                children: [
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.fromLTRB(15, 10, 15, 10)),
                        alignment: Alignment.center,
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black.withOpacity(0.5)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCELAR"),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.fromLTRB(55, 10, 55, 10)),
                        alignment: Alignment.center,
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(255, 182, 0, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {
                      var enviado = postResenia(textFieldR.text,
                          textFieldE.text, ratingR, restaurant);

                      Navigator.pop(context);
                    },
                    child: Text("ENVIAR"),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<List<Review>> getReviews(Restaurant restaurant) async {
    final response =
        await http.get("https://tellurium.behuns.com/api/reviews/");

    List<Review> reviews = [];
    if (response.statusCode == 200) {
      // Recibió información sin errores
      String decodeResponse =
          utf8.decode(response.bodyBytes); // Codificar a UTF8
      final jsonData = jsonDecode(decodeResponse);
      for (var item in jsonData) {
        if (item["restaurant"] == restaurant.slug) {
          reviews.add(Review(item["slug"], item["restaurant"], item["email"],
              item["comments"], item["rating"], item["created"]));
        }
      }
      this.setState(() {});

      return reviews;
    } else {
      throw Exception("Error: " + response.statusCode.toString());
    }
  }

  Future<http.Response> postResenia(String textField, String textFieldE,
      double ratingR, Restaurant restaurant) async {
    print(ratingR);

    final response =
        await http.post("https://tellurium.behuns.com/api/reviews/",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'restaurant': restaurant.slug,
              'email': textFieldE,
              'comments': textField,
              'rating': ratingR.toInt().toString()
            }));

    if (response.statusCode == 201) {
      print(response.statusCode);
      reseniaList = getReviews(restaurant);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Fallo al enviar la reseña');
    }
  }

  mostrarAlerta(Review review, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(review.email + " dice:"),
          content: Container(
              child: Wrap(children: <Widget>[
            SizedBox(
              //height: 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(review.comments),
                  ),
                  RatingBar.builder(
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.cyanAccent[700],
                    ),
                    initialRating: review.rating,
                    itemCount: 5,
                    allowHalfRating: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    tapOnlyMode: true,
                    direction: Axis.horizontal,
                  )
                ],
              ),
            )
          ])),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar"))
          ],
        );
      },
    );
  }
}
