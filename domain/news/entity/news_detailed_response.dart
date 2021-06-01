import 'package:flutter/foundation.dart';
import 'file:///C:/Users/themi/flutter/ProjectFlutter/ironman/lib/domain/news/entity/news_list_response.dart';

class NewsDetailedResponse extends News {

  final String author;
  final String body;

  NewsDetailedResponse({
    @required newsId,
    @required newsTitle,
    @required newsEntryDate,
    @required newsThumbnail,
    @required this.author,
    @required this.body,
  }):super(newsId: newsId,newsTitle: newsTitle,newsEntryDate: newsEntryDate,newsThumbnail: newsThumbnail);

  @override
  List get props => [author,body];
}