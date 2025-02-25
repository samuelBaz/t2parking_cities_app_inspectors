class EventReviewDto {
  final int id;
  final String createdAt;
  final String? updatedAt; // Puede ser nulo
  final int version;
  final String? comment; // Puede ser nulo
  final String eventStatus;
  final int? reviewerId; // Puede ser nulo

  EventReviewDto({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.version,
    this.comment,
    required this.eventStatus,
    this.reviewerId,
  });

  factory EventReviewDto.fromJson(Map<String, dynamic> json) {
    return EventReviewDto(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['version'],
      comment: json['comment'],
      eventStatus: json['eventStatus'],
      reviewerId: json['reviewerId'],
    );
  }
}