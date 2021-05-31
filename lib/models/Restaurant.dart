import 'dart:convert';
import 'package:http/http.dart' as http;

class Restaurant{
  String slug;
  String name;
  String description;
  String logo;
  double rating;
  List<String> foodType;
  String types = "";
  List<Review> reviews;

  Restaurant(slug, name, description, logo, rating, foodType, reviews){
    this.slug = slug;
    this.name = name;
    this.description = description;
    this.logo = logo;
    if(rating != null){
      this.rating = rating;
    }else{
      this.rating = 0.0;
    }

    this.foodType = foodType;
    this.reviews = reviews;

    this.getTypes();

  }

  void getTypes() async {
    
    final response =
        await http.get("https://tellurium.behuns.com/api/food_types/");

    if (response.statusCode == 200) {
      // Recibió información sin errores
      String decodeResponse =
          utf8.decode(response.bodyBytes); // Codificar a UTF8
      final jsonData = jsonDecode(decodeResponse);
      for (var item in jsonData) {
        for (var food in this.foodType) {
          if (food == item['slug']){
            this.types += item["name"];
            this.types += ", ";
          }
          print(food);
        }
      }
      this.types = removeLastCharacter(this.types);

    } else {
      throw Exception("Error: " + response.statusCode.toString());
    }
  }

  static String removeLastCharacter(String str) {   
	  String result = "";   
    if ((str != "") && str.isNotEmpty) {      
    	result = str.substring(0, str.length - 1);   
    }   
    return result;
}

}

class FoodType{
  String slug;
  String name;

  FoodType(slug, name){
    this.slug = slug;
    this.name = name;
  }
}

class Review {
    String slug;
    String restaurant;
    String email;
    String comments;
    double rating;
    String created;

    Review(slug, restaurant, email, comments, rating, created){
      this.slug = slug;
      this.restaurant = restaurant;
      this.email = email;
      this.comments = comments;
      if(rating != null){
        this.rating = rating.toDouble();
      }else{
        this.rating = 0.0;
      }
      this.created = created;
    }
}