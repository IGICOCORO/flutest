import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'category.dart';
part 'product.g.dart';

@Collection(ignore: {'props'})
class Product extends Equatable {
  Id? id =Isar.autoIncrement;
  late String name;
  @Index(composite: [CompositeIndex('name')])
  final category = IsarLink<Category>();
  late float price;
  late int quantity;

  @override
  List<Object?> get props => [id];
}