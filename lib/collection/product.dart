import 'package:isar/isar.dart';

@Collection()
class Product {
  Id? id =Isar.autoIncrement;
  late String name;
  late String category;
  late int quantity;
}