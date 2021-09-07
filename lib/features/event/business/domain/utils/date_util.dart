import 'package:intl/intl.dart';

class DateUtils {

  String dateToString(DateTime dateTime, DateFormat dateFormat){
    return dateFormat.format(dateTime);
  }

  DateTime stringToDate(String formattedDateTimeString){
    return DateTime.tryParse(formattedDateTimeString);
  }

  String startDateToString(DateTime dateTime){
    var formatter = DateFormat('yyyy-MM-dd',);
    return dateToString(dateTime, formatter);
  }


}
