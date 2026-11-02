import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:running/modules/profile/presentation/screens/my_profile_screen.dart';

void main() {
  testWidgets(
    'MyProfileScreen renders all header, pet, and progress components',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyProfileScreen()));

      expect(find.byType(MyProfileScreen), findsOneWidget);
      expect(find.text('Tracknner'), findsOneWidget);
      expect(find.text('1,250'), findsOneWidget);
      expect(find.text('TU COMPAÑERO DE CARRERA'), findsOneWidget);
      expect(find.text('¡Sigue así, Alex!'), findsOneWidget);
      expect(find.text('LVL 5'), findsOneWidget);
      expect(find.text('Corredor constante'), findsOneWidget);
      expect(find.text('680 / 1,000'), findsOneWidget);
      expect(find.text('Alimentar'), findsOneWidget);
      expect(find.text('MISIÓN DIARIA'), findsOneWidget);
    },
  );
}
