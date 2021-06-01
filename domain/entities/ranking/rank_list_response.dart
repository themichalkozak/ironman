import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RankListResponse extends Equatable {
  final int id;
  final int categoryId;
  final String rankingName;
  final String rankingCategoryName;

  RankListResponse({
    @required this.id,
    @required this.categoryId,
    @required this.rankingName,
    @required this.rankingCategoryName,
  });
}

class RankResponse {
  final int athleteId;
  final String athleteTitle;
  final String athleteFlag;
  final List<AthleteCategory> athleteCategories;


  RankResponse({
    @required this.athleteId,
    @required this.athleteTitle,
    @required this.athleteFlag,
    @required this.athleteCategories,
  });
}

class AthleteCategory {
  final int rank;
  final int total;
  final int events;

  AthleteCategory({
    @required this.rank,
    @required this.total,
    @required this.events,
  });
}