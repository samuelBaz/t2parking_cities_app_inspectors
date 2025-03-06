import 'package:t2parking_cities_inspector_app/models/inspector_review.dart';

class InspectorEvent {
  final int id;
  final String description;
  final String typeEvent;
  final List<int>? image;
  final String plate;
  final int inspectorId;
  final String inspectorUserEmail;
  final EventReviewDto? eventReview;
  final String createdAt;
  final String? updatedAt;
  final int version;

  InspectorEvent({
    required this.id,
    required this.description,
    required this.typeEvent,
    this.image,
    required this.plate,
    required this.inspectorId,
    required this.inspectorUserEmail,
    this.eventReview,
    required this.createdAt,
    this.updatedAt,
    required this.version,
  });

  factory InspectorEvent.fromJson(Map<String, dynamic> json) {
    return InspectorEvent(
      id: json['id'],
      description: json['description'],
      typeEvent: json['typeEvent'],
      image: json['image'] != null ? List<int>.from(json['image']) : null,
      plate: json['plate'],
      createdAt: json['createdAt'],
      inspectorId: json['inspectorId'],
      inspectorUserEmail: json['inspectorUserEmail'],
      eventReview: json['eventReview'] != null ? EventReviewDto.fromJson(json['eventReview']) : null,
      updatedAt: json['updatedAt'],
      version: json['version'],
    );
  }
}