import 'package:intl/intl.dart';

String formatUtcToLocal(String utcDateString) {
  DateTime utcDate = DateTime.parse(utcDateString);
  String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(utcDate.toLocal());
  return formattedDate;
}

String formatUtcTo3Letters(String utcDateString) {
  DateTime utcDate = DateTime.parse(utcDateString);
  String formattedDate = DateFormat('dd MMM, yyyy').format(utcDate.toLocal());
  formattedDate = formattedDate.replaceAll('Jun', 'Ene');
  formattedDate = formattedDate.replaceAll('Apr', 'Abr');
  formattedDate = formattedDate.replaceAll('Aug', 'Ago');
  formattedDate = formattedDate.replaceAll('Dec', 'Dic');
  return formattedDate;
}

String formatUtcToHours(String utcDateString) {
  DateTime utcDate = DateTime.parse(utcDateString);
  String formattedDate = DateFormat('HH:mm').format(utcDate.toLocal());
  return formattedDate;
}