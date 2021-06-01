import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RankListResponse extends Equatable {
  final int id;
  final int catetgoryId;
  final String rankingName;
  final String rankingCategoryName;


}

class RankResponse {
  final int athleteId;
  final String athleteTitle;
  final String athleteFlag;
  final List<AthleteCategory> athleteCategories;

}

class AthleteCategory {
  final int rank;
  final int total;
  final int events;

  const AthleteCategory({
    @required this.rank,
    @required this.total,
    @required this.events,
  });
}