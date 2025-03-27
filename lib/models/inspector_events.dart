import 'package:t2parking_cities_inspector_app/models/inspector_review.dart';

class InspectorEvent {
  final int id;
  final String createdAt;
  final String? updatedAt;
  final int version;
  final String typeEvent;
  final String plate;
  final int inspectorId;
  final String inspectorUserEmail;
  final EventReviewDto? eventReview;
  final String status;

  InspectorEvent({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.version,
    required this.typeEvent,
    required this.plate,
    required this.inspectorId,
    required this.inspectorUserEmail,
    this.eventReview,
    required this.status,
  });

  factory InspectorEvent.fromJson(Map<String, dynamic> json) {
    return InspectorEvent(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['version'],
      typeEvent: json['typeEvent'],
      plate: json['plate'],
      inspectorId: json['inspectorId'],
      inspectorUserEmail: json['inspectorUserEmail'],
      eventReview: json['eventReview'] != null ? EventReviewDto.fromJson(json['eventReview']) : null,
      status: json['status'],
    );
  }
}