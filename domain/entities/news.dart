import 'package:flutter/foundation.dart';

import '../repsonse.dart';

class News extends Response {
  final int newsId;
  final String newsTitle;
  final String newsEntryDate;
  final String newsThumbnail;

  News({
    @required status,
    @required currentPage,
    @required lastPage,
    @required this.newsId,
    @required this.newsTitle,
    @required this.newsEntryDate,
    @required this.newsThumbnail,
  }) : super(status, currentPage, lastPage);
}
