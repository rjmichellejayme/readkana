// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Highlight {
  final String id;
  final String bookId;
  final int startPage;
  final int endPage;
  final Color color;
  final String? note;
  final DateTime date;

  Highlight({
    required this.id,
    required this.bookId,
    required this.startPage,
    required this.endPage,
    required this.color,
    this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'startPage': startPage,
      'endPage': endPage,
      'color': color.value,
      'note': note,
      'createdAt': date.toIso8601String(),
    };
  }

  static Highlight fromMap(Map<String, dynamic> map) {
    return Highlight(
      id: map['id'],
      bookId: map['bookId'],
      startPage: map['startPage'],
      endPage: map['endPage'],
      color: Color(map['color']),
      note: map['note'],
      date: DateTime.parse(map['createdAt']),
    );
  }

  Highlight copyWith({
    String? id,
    String? bookId,
    int? startPage,
    int? endPage,
    Color? color,
    String? note,
    DateTime? date,
  }) {
    return Highlight(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      startPage: startPage ?? this.startPage,
      endPage: endPage ?? this.endPage,
      color: color ?? this.color,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Highlight{id: $id, bookId: $bookId, startPage: $startPage, endPage: $endPage, color: $color, note: $note, date: $date}';
  }
}
