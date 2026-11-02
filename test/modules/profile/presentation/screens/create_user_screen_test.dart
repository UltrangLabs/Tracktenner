import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:running/modules/profile/presentation/constants/profile_constants.dart';
import 'package:running/modules/profile/presentation/screens/create_user_screen.dart';
import 'package:running/modules/profile/presentation/widgets/pet_carousel_banner.dart';
import 'package:running/modules/profile/presentation/widgets/user_form.dart';

void main() {
  group('CreateUserScreen and UserForm', () {
    testWidgets('renders CreateUserScreen with UserForm and initial pet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CreateUserScreen()));

      expect(find.byType(CreateUserScreen), findsOneWidget);
      expect(find.byType(UserForm), findsOneWidget);
      expect(find.byType(PetCarouselBanner), findsOneWidget);
      expect(find.text(kUserFormStrings.formTitle), findsOneWidget);
      expect(find.text(kUserFormStrings.formSubtitle), findsOneWidget);
      expect(find.text(kUserFormStrings.nameLabel), findsOneWidget);
      expect(find.text(kUserFormStrings.submitButtonText), findsOneWidget);
      expect(find.text(kAvailablePets.first.name), findsOneWidget);
      expect(find.text(kAvailablePets.first.breed), findsOneWidget);
    });

    testWidgets('validates required name and minimum length', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CreateUserScreen()));

      final submitFinder = find.widgetWithText(
        ElevatedButton,
        kUserFormStrings.submitButtonText,
      );

      // Scroll to submit button and tap
      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(find.text(kUserFormStrings.nameRequiredError), findsOneWidget);

      // Submit short name
      await tester.enterText(find.byType(TextFormField), 'Al');
      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(find.text(kUserFormStrings.nameMinLengthError), findsOneWidget);
    });

    testWidgets('successfully submits valid user name', (
      WidgetTester tester,
    ) async {
      String? submittedName;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: UserForm(
                onUserCreated: (name) {
                  submittedName = name;
                },
              ),
            ),
          ),
        ),
      );

      final submitFinder = find.widgetWithText(
        ElevatedButton,
        kUserFormStrings.submitButtonText,
      );

      await tester.enterText(find.byType(TextFormField), '  Alex runner  ');
      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(submittedName, equals('Alex runner'));
      expect(find.text(kUserFormStrings.nameRequiredError), findsNothing);
    });

    testWidgets(
      'navigates next and previous infinitely through available pets',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: CreateUserScreen()));

        // Initial pet is index 0: Max
        expect(find.text('Max'), findsOneWidget);

        final nextButton = find.byTooltip(kUserFormStrings.nextPetTooltip);
        final prevButton = find.byTooltip(kUserFormStrings.previousPetTooltip);

        // Next -> Kiu
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.text('Kiu'), findsOneWidget);

        // Next -> Luna
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.text('Luna'), findsOneWidget);

        // Next -> Rocky
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.text('Rocky'), findsOneWidget);

        // Next -> wraps infinitely back to Max
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        expect(find.text('Max'), findsOneWidget);

        // Prev -> wraps back to Rocky
        await tester.tap(prevButton);
        await tester.pumpAndSettle();
        expect(find.text('Rocky'), findsOneWidget);
      },
    );
  });
}
