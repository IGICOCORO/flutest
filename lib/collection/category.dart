import 'package:isar/isar.dart';

@Collection()
class Category {
  Id? id = Isar.autoIncrement;
  late String name;
}