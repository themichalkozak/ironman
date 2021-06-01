import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RankingCategoryResponse extends Equatable {
  final int id;
  final int categoryId;
  // Olympic
  final String categoryName;
  // Elite Man
  final String name;
  final String regionName;

  RankingCategoryResponse({
    @required this.id,
    @required this.categoryId,
    @required this.categoryName,
    @required this.name,
    @required this.regionName,
  });

  @override
  List get props => [id,categoryId,categoryName,name,regionName];
}