import 'package:t2parking_cities_inspector_app/models/inspector_review.dart';

class InspectorEvent {
  final String description;
  final String typeEvent;
  final List<int>? image;
  final String plate;
  final int inspectorId;
  final String inspectorUserEmail;
  final EventReviewDto eventReview;
  final String createdAt;

  InspectorEvent({
    required this.description,
    required this.typeEvent,
    this.image,
    required this.plate,
    required this.inspectorId,
    required this.inspectorUserEmail,
    required this.eventReview,
    required this.createdAt
  });

  factory InspectorEvent.fromJson(Map<String, dynamic> json) {
    return InspectorEvent(
      description: json['description'],
      typeEvent: json['typeEvent'],
      image: json['image'] != null ? List<int>.from(json['image']) : null, // Maneja el caso nulo
      plate: json['plate'],
      createdAt: json['createdAt'],
      inspectorId: json['inspectorId'],
      inspectorUserEmail: json['inspectorUserEmail'],
      eventReview: EventReviewDto.fromJson(json['eventReview']),
    );
  }
}