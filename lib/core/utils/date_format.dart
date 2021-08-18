import 'package:intl/intl.dart';

String formatStartDate(DateTime dateTime){
  var formatter = DateFormat('yyyy-MM-dd',);
  return formatter.format(dateTime);
}