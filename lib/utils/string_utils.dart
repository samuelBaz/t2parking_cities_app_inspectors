import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String formatUtcToLocal(String utcDateString) {
  // Parsear la fecha en formato UTC
  DateTime utcDate = DateTime.parse(utcDateString);

  // Convertir a la zona horaria local
  tz.TZDateTime localDate = tz.TZDateTime.from(utcDate, tz.local);

  // Formatear la fecha en un formato legible
  String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(localDate);
  return formattedDate;
}