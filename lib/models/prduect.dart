// To parse this JSON data, do
//
//
//     final product = productFromJson(jsonString);
// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    required this.id,
    required this.total,
    required this.title,
    required this.ordered,
    required this.items,
  });

  final String id;
  final String total;
  final String title;
  final bool ordered;
  final List<String> items;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        total: json["total"],
        title: json["title"],
        ordered: json["ordered"],
        items: List<String>.from(json["items"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "title": title,
        "ordered": ordered,
        "items": List<dynamic>.from(items.map((x) => x)),
      };
}

class Cart {
  Cart({
    required this.id,
    required this.itemQty,
    required this.product,
  });

  final String id;
  final int itemQty;
  final Product product;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        itemQty: json["item_qty"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_qty": itemQty,
        "product": product.toJson(),
      };
}

class Product {
  Product({
    required this.id,
    required this.isFeatured,
    required this.isActive,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.category,
    required this.image,
  });

  final String id;
  final bool isFeatured;
  final bool isActive;
  final String name;
  final String description;
  final int price;
  final int discountedPrice;
  final Category category;
  final String image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        isFeatured: json["is_featured"],
        isActive: json["is_active"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image: json["image"],
        discountedPrice: json["discounted_price"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_featured": isFeatured,
        "is_active": isActive,
        "name": name,
        "description": description,
        "price": price,
        "discounted_price": discountedPrice,
        "category": category.toJson(),
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
