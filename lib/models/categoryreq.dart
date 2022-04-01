import 'dart:convert';

import 'package:bana_care/models/prduect.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse('$baseip/api/Categorys'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    List jsonResponse = json.decode(response.body);

    return jsonResponse
        .map((category) => new Category.fromJson(category))
        .toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
