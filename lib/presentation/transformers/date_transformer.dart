import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTransformer{
  String transformDaysAgoOrDate(DateTime today, DateTime eventTime){
    Duration difference = today.difference(eventTime);
    if(difference.inDays == 0 && today.day == eventTime.day){
      return timeago.format(eventTime);
    } else {
      return DateFormat.yMMMMEEEEd().format(eventTime);
    }
  }
}