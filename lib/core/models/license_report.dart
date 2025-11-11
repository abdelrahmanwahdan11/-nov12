import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class LicenseReport {
  const LicenseReport({
    required this.id,
    required this.categoryKey,
    required this.message,
    required this.statusKey,
    required this.submittedAt,
  });

  final String id;
  final String categoryKey;
  final String message;
  final String statusKey;
  final DateTime submittedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryKey': categoryKey,
      'message': message,
      'statusKey': statusKey,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory LicenseReport.fromMap(Map<String, dynamic> map) {
    return LicenseReport(
      id: map['id'] as String,
      categoryKey: map['categoryKey'] as String,
      message: map['message'] as String,
      statusKey: map['statusKey'] as String,
      submittedAt: DateTime.parse(map['submittedAt'] as String),
    );
  }

  factory LicenseReport.fromJson(String source) {
    return LicenseReport.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
