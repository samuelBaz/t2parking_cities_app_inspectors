import 'package:intl/intl.dart';

String formatUtcToLocal(String utcDateString) {
  // Parsear la fecha en formato UTC
  DateTime utcDate = DateTime.parse(utcDateString);

  // Convertir a la zona horaria local
  // tz.TZDateTime localDate = tz.TZDateTime.from(utcDate, tz.local);

  // Formatear la fecha en un formato legible
  String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(utcDate);
  return formattedDate;
}

String formatUtcTo3Letters(String utcDateString) {

  // Parsear la fecha en formato UTC
  DateTime utcDate = DateTime.parse(utcDateString);

  // Formatear la fecha en un formato legible
  String formattedDate = DateFormat('dd MMM, yyyy').format(utcDate);
  formattedDate = formattedDate.replaceAll('Jun', 'Ene');
  formattedDate = formattedDate.replaceAll('Apr', 'Abr');
  formattedDate = formattedDate.replaceAll('Aug', 'Ago');
  formattedDate = formattedDate.replaceAll('Dec', 'Dic');
  return formattedDate;
}

String formatUtcToHours(String utcDateString) {
  // Parsear la fecha en formato UTC
  DateTime utcDate = DateTime.parse(utcDateString);

  // Formatear la fecha en un formato legible
  String formattedDate = DateFormat('HH:mm').format(utcDate);
  return formattedDate;
}