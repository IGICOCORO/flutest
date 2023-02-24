part of 'category_bloc.dart';

@immutable
class CategoryEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCategories extends CategoryEvent {
  GetCategories({
    required this.idSelected,
  });
  final int idSelected;

  @override
  List<Object?> get props => [idSelected];
}
