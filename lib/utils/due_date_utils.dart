import 'package:flutter/material.dart';

/// Calcule la couleur de l'icône en fonction de la date d'échéance.
Color resolveDueColor(DateTime? dueDate, {DateTime? referenceDate}) {
  if (dueDate == null) return Colors.grey;
  final today = _truncate(referenceDate ?? DateTime.now());
  final target = _truncate(dueDate);
  if (target.isBefore(today)) return Colors.red;
  if (target.difference(today).inDays <= 2) return Colors.orange;
  return Colors.green;
}

/// Génère le texte d'échéance affiché sous un todo.
String buildDueText(DateTime? dueDate, {DateTime? referenceDate}) {
  if (dueDate == null) return 'Pas d\'échéance';
  final formatted = _formatDate(dueDate);
  final suffix = _dueSuffix(dueDate, referenceDate: referenceDate);
  return suffix == null ? formatted : '$formatted $suffix';
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}

String? _dueSuffix(DateTime dueDate, {DateTime? referenceDate}) {
  final today = _truncate(referenceDate ?? DateTime.now());
  final target = _truncate(dueDate);
  final delta = target.difference(today).inDays;

  String plural(int value) => value.abs() > 1 ? 's' : '';

  if (delta > 0) {
    return '($delta jour${plural(delta)} restant${plural(delta)})';
  }
  if (delta < 0) {
    final late = delta.abs();
    return '($late jour${plural(late)} en retard)';
  }
  return '(0 jour restant)';
}

DateTime _truncate(DateTime date) => DateTime(date.year, date.month, date.day);
