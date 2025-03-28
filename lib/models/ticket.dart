class Ticket {
  final int id;
  final String createdAt;
  final String? updatedAt;
  final int version;
  final String plate;
  final int duration;
  final String startDate;
  final String endDate;
  final String phone;
  final String email;
  final int idTicketGenerator;
  final double amount;
  final String? cause;
  final String status;
  final int companyId;
  final int parkingAreaId;
  final String parkingAreaName;
  final String companyName;

  Ticket({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.version,
    required this.plate,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.phone,
    required this.email,
    required this.idTicketGenerator,
    required this.amount,
    this.cause,
    required this.status,
    required this.companyId,
    required this.parkingAreaId,
    required this.parkingAreaName,
    required this.companyName,
  });

  // Método para crear un Ticket a partir de un Map
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['version'],
      plate: json['plate'],
      duration: json['duration'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      phone: json['phone'],
      email: json['email'],
      idTicketGenerator: json['idTicketGenerator'],
      amount: json['amount'],
      cause: json['cause'],
      status: json['status'],
      companyId: json['companyId'],
      parkingAreaId: json['parkingAreaId'],
      parkingAreaName: json['parkingAreaName'],
      companyName: json['companyName'],
    );
  }

  // Método para convertir un Ticket a un Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'version': version,
      'plate': plate,
      'duration': duration,
      'startDate': startDate,
      'endDate': endDate,
      'phone': phone,
      'email': email,
      'idTicketGenerator': idTicketGenerator,
      'amount': amount,
      'cause': cause,
      'status': status,
      'companyId': companyId,
      'parkingAreaId': parkingAreaId,
      'parkingAreaName': parkingAreaName,
      'companyName': companyName,
    };
  }
}