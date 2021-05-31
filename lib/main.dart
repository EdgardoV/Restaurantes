import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_test/pages/Info.dart';
import 'models/Restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<File> _image;
  final picker = ImagePicker();

  _imgFromCamera() async {
    final File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    return image;
  }

  Future<File> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    return image;
  }

  Future<List<Restaurant>> restaurantList;
  Future<List<FoodType>> foodTypeList;

  Future<List<Restaurant>> getRestaurants(String filtro) async {
    final response =
        await http.get("https://tellurium.behuns.com/api/restaurants/");

    List<Restaurant> restaurants = [];

    if (response.statusCode == 200) {
      // Recibió información sin errores
      String decodeResponse =
          utf8.decode(response.bodyBytes); // Codificar a UTF8
      final jsonData = jsonDecode(decodeResponse);
      for (var item in jsonData) {
        List<String> foodType = [];
        List<Review> reviews = [];
        for (var fType in item["food_type"]) {
          foodType.add(fType);
        }
        for (var rev in item["reviews"]) {
          reviews.add(Review(rev["slug"], rev["restaurant"], rev["email"],
              rev["comments"], rev["rating"], rev["created"]));
        }
        Restaurant value = Restaurant(
            item["slug"],
            item["name"],
            item["description"],
            item["logo"],
            item["rating"],
            foodType,
            reviews);
        if (foodType.contains(filtro) || filtro == "") {
          restaurants.add(value);
        }
      }

      return restaurants;
      this.setState(() {});
    } else {
      throw Exception("Error: " + response.statusCode.toString());
    }
  }

  Future<List<FoodType>> getFoodTypes() async {
    final response =
        await http.get("https://tellurium.behuns.com/api/food_types/");

    List<FoodType> types = [];

    if (response.statusCode == 200) {
      String decodeResponse =
          utf8.decode(response.bodyBytes); // Codificar a UTF8
      final jsonData = jsonDecode(decodeResponse);
      types.add(FoodType("", "All Types"));
      for (var item in jsonData) {
        types.add(FoodType(item["slug"], item["name"]));
      }

      return types;
    } else {
      throw Exception("Error: " + response.statusCode.toString());
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    restaurantList = getRestaurants("");
    foodTypeList = getFoodTypes();
  }

  @override
  Widget build(BuildContext context) {
    String selectedFc;
    return Container(
      color: Color.fromRGBO(251, 249, 246, 1),
      child: SafeArea(
          child: MaterialApp(
        title: 'Main',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color.fromRGBO(251, 249, 246, 1),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              openFormAddRestaurant(context);
            },
            child: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
              size: 18,
            ),
            backgroundColor: Color.fromRGBO(255, 182, 0, 1),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(32, 64, 32, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                              child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Restaurantes',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('¿De qué hay antojo?',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(0, 0, 0, 0.5))),
                        ),
                        Padding( 
                          padding: EdgeInsets.only(top: 10),
                          child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Color.fromRGBO(255, 182, 0, 1),
                              ),
                              child: FutureBuilder(
                                future: foodTypeList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton<String>(
                                        hint: Text(
                                          "Selecciona",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        value: selectedFc,
                                        onChanged: (newValue) {
                                          restaurantList =
                                              getRestaurants(newValue);
                                          setState(() {
                                            selectedFc = newValue;
                                          });
                                        },
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (fc) =>
                                                    DropdownMenuItem<String>(
                                                      child: Text(fc.name),
                                                      value: fc.slug,
                                                    ))
                                            .toList());
                                  }
                                  return Text("Cargando...");
                                },
                              )),
                        ))
                      ]))),
                      Container(
                        alignment: Alignment.centerRight,
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(255, 255, 255, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              )
                            ]),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.search,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 615,
                    child: FutureBuilder(
                      future: restaurantList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: ListTile(
                                            onTap: () {
                                              openRestaurant(
                                                  snapshot.data[index],
                                                  context);
                                            },
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 22.0, 0, 10.0),
                                              child: Text(
                                                  snapshot.data[index].name,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1))),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0.0, 0, 10.0),
                                              child: Text(snapshot
                                                  .data[index].description),
                                            ),
                                            leading: FloatingActionButton(
                                              onPressed: () {},
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                padding: EdgeInsets.all(10),
                                                child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor:
                                                        Colors.blue[900],
                                                    child: paintImage(
                                                        snapshot.data[index])),
                                              ),
                                            ),
                                            trailing: Column(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 4, 0, 11),
                                                  child: Container(
                                                    child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 18),
                                                  )),
                                              Text(
                                                '⭐️ ' +
                                                    (snapshot
                                                            .data[index].rating)
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]) //Icon(Icons.arrow_forward_ios),
                                            )));
                              });
                        } else if (snapshot.hasError) {
                          return Text("Error al recuperar información");
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                    //)])
                    )
              ]))),
            ],
          ),
        ),
      )),
    );
  }

  openFormAddRestaurant(BuildContext context) {
    TextEditingController textName = TextEditingController(text: "");
    TextEditingController textDescription = TextEditingController(text: "");
    String selectedFc;
    File img;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                    width: 150,
                    child: Text("Registra un restaurante",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: FloatingActionButton(
                              backgroundColor: Color.fromRGBO(255, 182, 0, 1),
                              onPressed: () {
                                _image = _imgFromGallery();
                                setState(() {});
                              },
                              tooltip: 'Selecciona archivo',
                              child: Icon(Icons.add_a_photo)))),
                ],
              ),
              content: Container(
                  child: Wrap(children: <Widget>[
                SizedBox(
                  //height: 110,
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Color.fromRGBO(196, 196, 196, 0.15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                controller: textName,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  hintText: 'Nombre',
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
                            ))),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 145),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Color.fromRGBO(196, 196, 196, 0.15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FutureBuilder(
                                  future: foodTypeList,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButton<String>(
                                          hint: Text("Tipo",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          value: selectedFc,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedFc = newValue;
                                            });
                                          },
                                          items: snapshot.data
                                              .map<DropdownMenuItem<String>>(
                                                  (fc) =>
                                                      DropdownMenuItem<String>(
                                                        child: Text(fc.name,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                        value: fc.slug,
                                                      ))
                                              .toList());
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                )))),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Color.fromRGBO(196, 196, 196, 0.15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                controller: textDescription,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  hintText: 'Descripción',
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
                            ))),
                    Container(
                        child: FutureBuilder(
                      future: _image,
                      builder: (context, snapshot) {
                        print(snapshot);
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          img = snapshot.data;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Imagen cargada, exitosamente!"),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text("Error al recuperar imagen"),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(""),
                        );
                      },
                    ))
                  ]),
                )
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
                              EdgeInsets.fromLTRB(50, 10, 50, 10)),
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
                        sendNewRestaurant(textName.text, textDescription.text,
                            selectedFc, img);
                        Navigator.pop(context);
                      },
                      child: Text("REGISTRAR"),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  Future<http.Response> sendNewRestaurant(
      textName, textDescription, selectedFc, File img) async {
    /*var request = http.MultipartRequest('POST', Uri.parse("https://tellurium.behuns.com/api/restaurants/"));
    request.files.add(
      http.MultipartFile.fromBytes(
        'logo',
        img.readAsBytesSync(),
        filename: img.path.split("/").last
      )
    );*/

    var listFood = [];
    listFood.add(selectedFc);
    if (img != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://tellurium.behuns.com/api/restaurants/'));
      request.fields.addAll({
        'name': textName,
        'description': textDescription,
        'food_type': selectedFc
      });
      request.files.add(await http.MultipartFile.fromPath('logo', img.path));

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(await response.stream.bytesToString());
        print(response.statusCode);
        restaurantList = getRestaurants("");
        this.setState(() {});
      } else {
        print(response.reasonPhrase);
      }
    } else {
      final response =
          await http.post("https://tellurium.behuns.com/api/restaurants/",
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                'name': textName,
                'description': textDescription,
                'food_type': listFood
                //fromFile(img.path, filename:"fileName.jpg"),
              }));
      if (response.statusCode == 201) {
        print(response.statusCode);
        restaurantList = getRestaurants("");
        this.setState(() {});
      } else {
        print(response.body);
        print("NOOOO");
        throw Exception('Fallo al enviar la reseña');
      }
    }
  }

  paintImage(Restaurant item) {
    if (item.logo != null && item.logo != "") {
      return Image.network(
        item.logo,
        fit: BoxFit.fill,
      );
    } else {
      return Text(item.name.substring(0, 1));
    }
  }

  openRestaurant(Restaurant restaurant, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PageInfoRestaurant(restaurant)));
    print("RATING: " + restaurant.rating.toString());
  }
}
