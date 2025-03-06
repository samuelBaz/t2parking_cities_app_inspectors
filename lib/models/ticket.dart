import 'package:t2parking_cities_inspector_app/models/ticket_status.dart'; // Asegúrate de que la ruta sea correcta

class Ticket {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  int version;
  String plate;
  int duration;
  DateTime startDate;
  DateTime endDate;
  String phone;
  String email;
  int idTicketGenerator;
  double amount;
  String? cause;
  TicketStatus status; // Asegúrate de que TicketStatus esté definido
  int companyId;
  String companyName;

  Ticket({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.plate,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.phone,
    required this.email,
    required this.idTicketGenerator,
    required this.amount,
    required this.cause,
    required this.status,
    required this.companyId,
    required this.companyName,
  });

  // Método para crear un Ticket a partir de un Map
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['version'],
      plate: json['plate'],
      duration: json['duration'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      phone: json['phone'],
      email: json['email'],
      idTicketGenerator: json['idTicketGenerator'],
      amount: json['amount'].toDouble(),
      cause: json['cause'],
      status: TicketStatus.values.firstWhere((e) => e.toString() == 'TicketStatus.${json['status']}'),
      companyId: json['companyId'],
      companyName: json['companyName'],
    );
  }

  // Método para convertir un Ticket a un Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
      'plate': plate,
      'duration': duration,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'phone': phone,
      'email': email,
      'idTicketGenerator': idTicketGenerator,
      'amount': amount,
      'cause': cause,
      'status': status.toString().split('.').last, // Convierte a string
      'companyId': companyId,
      'companyName': companyName,
    };
  }
}