import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final int id;
  final String name;
  final dynamic image;
  Category(this.id, this.name, {this.image});
}

final List<Category> categories = [
  Category(9, "Beginner", image: "images/py.png"),
  Category(10, "Intermediate", image: "images/py.png"),
  Category(11, "Advanced", image: "images/py.png"),
];
