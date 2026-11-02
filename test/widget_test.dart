import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:running/main.dart';
import 'package:running/modules/profile/presentation/screens/my_profile_screen.dart';
import 'package:running/shared/screens/dashboard_screen.dart';
import 'package:running/shared/widgets/bottom_nav.dart';

void main() {
  testWidgets('Dashboard smoke test verifies navigation tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MyProfileScreen), findsOneWidget);
    expect(find.byType(BottomNav), findsOneWidget);

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Carrera'), findsWidgets);
    expect(find.text('Resumen'), findsWidgets);
    expect(find.text('Historia'), findsWidgets);
    expect(find.text('Mascota'), findsWidgets);

    // Tap on Carrera tab
    await tester.tap(find.byIcon(Icons.access_time_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
