import 'package:isar/isar.dart';
import 'category.dart';
part 'product.g.dart';

@Collection()
class Product {
  Id? id =Isar.autoIncrement;
  late String name;
  @Index(composite: [CompositeIndex('name')])
  final category = IsarLink<Category>();
  late float price;
  late int quantity;
}