import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/utils/due_date_utils.dart';

void main() {
  group('resolveDueColor', () {
    final reference = DateTime(2024, 1, 10);

    test('retourne gris quand aucune échéance', () {
      expect(resolveDueColor(null, referenceDate: reference), Colors.grey);
    });

    test('retourne rouge pour une échéance dépassée', () {
      final past = DateTime(2024, 1, 7);
      expect(resolveDueColor(past, referenceDate: reference), Colors.red);
    });

    test('retourne orange pour une échéance proche (<= 2 jours)', () {
      final soon = DateTime(2024, 1, 11);
      expect(resolveDueColor(soon, referenceDate: reference), Colors.orange);
    });

    test('retourne vert pour une échéance lointaine', () {
      final later = DateTime(2024, 1, 20);
      expect(resolveDueColor(later, referenceDate: reference), Colors.green);
    });
  });

  group('buildDueText', () {
    final reference = DateTime(2024, 1, 10);

    test('indique clairement lorsque aucune date est fournie', () {
      expect(buildDueText(null, referenceDate: reference), "Pas d'échéance");
    });

    test('ajoute un suffixe de retard quand la date est passée', () {
      final past = DateTime(2024, 1, 8);
      expect(
        buildDueText(past, referenceDate: reference),
        '08/01/2024 (2 jours en retard)',
      );
    });

    test('ajoute un suffixe de jours restants quand la date est future', () {
      final future = DateTime(2024, 1, 15);
      expect(
        buildDueText(future, referenceDate: reference),
        '15/01/2024 (5 jours restants)',
      );
    });
  });
}

