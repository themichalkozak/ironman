import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class News extends Equatable {
  final int newsId;
  final String newsTitle;
  final String newsEntryDate;
  final String newsThumbnail;

  News({
    @required this.newsId,
    @required this.newsTitle,
    @required this.newsEntryDate,
    @required this.newsThumbnail,
  });
}
