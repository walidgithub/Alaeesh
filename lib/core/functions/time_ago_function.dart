String timeAgo(DateTime postDate) {
  final Duration difference = DateTime.now().difference(postDate);

  if (difference.inSeconds < 60) {
    return 'لـسـه حـالًا';
  } else if (difference.inMinutes < 60) {
    return ' مـن ${difference.inMinutes} دقـيـقـة ';
  } else if (difference.inHours < 24) {
    return ' مـن ${difference.inHours} سـاعـة ';
  } else if (difference.inDays == 1) {
    return '${_formatTime(postDate)} امـبـارح ';
  } else if (difference.inDays < 7) {
    return ' مـن ${difference.inDays} يــوم ';
  } else if (difference.inDays < 30) {
    final int weeks = (difference.inDays / 7).floor();
    return weeks == 1 ? ' مـن أسـبـوع ' : ' مـن $weeks أسـابـيـع ';
  } else if (difference.inDays < 365) {
    final int months = (difference.inDays / 30).floor();
    return months == 1 ? ' مـن شــهـر ' : ' مـن $months شـهـور ';
  } else {
    final int years = (difference.inDays / 365).floor();
    return years == 1 ? ' مـن سـنـة ' : ' مـن $years سـنـيـن ';
  }
}

String _formatTime(DateTime dateTime) {
  final String hour = dateTime.hour > 12
      ? '${dateTime.hour - 12}'
      : '${dateTime.hour == 0 ? 12 : dateTime.hour}';
  final String minute = dateTime.minute.toString().padLeft(2, '0');
  final String period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

List<int> splitDateTime(String dateTime) {
  List<String> parts = dateTime.split(' ');

  List<String> dateParts = parts[0].split('-');
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  List<String> timeParts = parts[1].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  if (parts[2] == 'PM' && hour != 12) {
    hour += 12;
  } else if (parts[2] == 'AM' && hour == 12) {
    hour = 0;
  }

  return [year, month, day, hour, minute];
}