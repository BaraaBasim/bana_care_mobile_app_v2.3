import 'dart:convert';

import 'package:bana_care/models/prduect.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

Future<List<Product>> fetchListproduects(String path) async {
  final response = await http.get(Uri.parse(path));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    List jsonResponse = json.decode(response.body);

    return jsonResponse
        .map((product) => new Product.fromJson(product))
        .toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<List<Cart>> fetchcart() async {
  var uuid = Uuid();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = (prefs.getString('id') ?? uuid.v4());
  final response = await http.get(Uri.parse('$baseip/api/order/Items/$id'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((cart) => new Cart.fromJson(cart)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<List<Order>> fetchorder() async {
  var uuid = Uuid();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = (prefs.getString('id') ?? uuid.v4());

  final response =
      await http.get(Uri.parse('$baseip/api/order/get_user_order/$id'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((order) => new Order.fromJson(order)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
