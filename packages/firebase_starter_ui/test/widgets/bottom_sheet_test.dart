import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  MockBuildContext _mockContext;

  setUp(() {
    _mockContext = MockBuildContext();
  });
  group('FSBottomSheet', () {
    testWidgets(
      'open bottomsheet when show constructor is used is used',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      FSBottomSheet.show(
                        context: context,
                        builder: (context) => const Text('bottomsheet'),
                      );
                    },
                    child: const FSBottomSheet(child: Text('test')),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        expect(find.text('bottomsheet'), findsOneWidget);
      },
    );

    testWidgets('throws AssertionError when context is null', (tester) async {
      expect(
        () => FSBottomSheet.show(
          context: null,
          builder: (context) => const Text('bottomsheet'),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('throws AssertionError when builder is null', (tester) async {
      expect(
        () => FSBottomSheet.show(
          context: _mockContext,
          builder: null,
        ),
        throwsAssertionError,
      );
    });
  });
}
