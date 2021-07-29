// ignore_for_file: prefer_const_constructors
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FSTextButton', () {
    testWidgets('throws AssertionError when child is null', (tester) async {
      expect(
        () => tester.pumpWidget(
          FSTextButton(
            onPressed: () {},
            child: null,
          ),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('renders child widget', (tester) async {
      const key = Key('__test_target__');
      await tester.pumpWidget(
        MaterialApp(
          home: FSTextButton(
            key: key,
            onPressed: () {},
            child: const Text('firebase_starter'),
          ),
        ),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    group('.icon', () {
      testWidgets('throws AssertionError when icon is null', (tester) async {
        expect(
          () => tester.pumpWidget(
            FSTextButton.icon(
              onPressed: () {},
              icon: null,
              label: const Text('firebase_starter'),
            ),
          ),
          throwsAssertionError,
        );
      });

      testWidgets('throws AssertionError when label is null', (tester) async {
        expect(
          () => tester.pumpWidget(
            FSTextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.sports_football),
              label: null,
            ),
          ),
          throwsAssertionError,
        );
      });

      testWidgets('renders child widget', (tester) async {
        const key = Key('__test_target__');
        await tester.pumpWidget(
          MaterialApp(
            home: FSTextButton.icon(
              key: key,
              onPressed: () {},
              icon: Icon(Icons.sports_football),
              label: const Text('firebase_starter'),
            ),
          ),
        );
        expect(find.byKey(key), findsOneWidget);
      });
    });
  });

  group('FSOutlinedButton', () {
    testWidgets('throws AssertionError when child is null', (tester) async {
      expect(
        () => tester.pumpWidget(
          FSOutlinedButton(
            onPressed: () {},
            child: null,
          ),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('renders child widget', (tester) async {
      const key = Key('__test_target__');
      await tester.pumpWidget(
        MaterialApp(
          home: FSOutlinedButton(
            key: key,
            onPressed: () {},
            child: const Text('firebase_starter'),
          ),
        ),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    group('.icon', () {
      testWidgets('throws AssertionError when icon is null', (tester) async {
        expect(
          () => tester.pumpWidget(
            FSOutlinedButton.icon(
              onPressed: () {},
              icon: null,
              label: const Text('firebase_starter'),
            ),
          ),
          throwsAssertionError,
        );
      });

      testWidgets('throws AssertionError when label is null', (tester) async {
        expect(
          () => tester.pumpWidget(
            FSOutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.sports_football),
              label: null,
            ),
          ),
          throwsAssertionError,
        );
      });

      testWidgets('renders child widget', (tester) async {
        const key = Key('__test_target__');
        await tester.pumpWidget(
          MaterialApp(
            home: FSOutlinedButton.icon(
              key: key,
              onPressed: () {},
              icon: Icon(Icons.sports_football),
              label: const Text('firebase_starter'),
            ),
          ),
        );
        expect(find.byKey(key), findsOneWidget);
      });
    });
  });

  group('FSElevatedButton', () {
    testWidgets('throws AssertionError when child is null', (tester) async {
      expect(
        () => tester.pumpWidget(
          FSElevatedButton(
            onPressed: () {},
            child: null,
          ),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('renders child widget', (tester) async {
      const key = Key('__test_target__');
      await tester.pumpWidget(
        MaterialApp(
          home: FSElevatedButton(
            key: key,
            onPressed: () {},
            child: const Text('firebase_starter'),
          ),
        ),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    group('.icon', () {
      testWidgets('throws AssertionError when icon is null', (tester) async {
        expect(
          () => tester.pumpWidget(
            FSElevatedButton.icon(
              onPressed: () {},
              icon: null,
              label: const Text('firebase_starter'),
            ),
          ),
          throwsAssertionError,
        );
      });

      testWidgets('throws AssertionError when label is null', (tester) async {
        expect(
          () => tester.pumpWidget(
            FSElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.sports_football),
              label: null,
            ),
          ),
          throwsAssertionError,
        );
      });

      testWidgets('renders child widget', (tester) async {
        const key = Key('__test_target__');
        await tester.pumpWidget(
          MaterialApp(
            home: FSElevatedButton.icon(
              key: key,
              onPressed: () {},
              icon: Icon(Icons.sports_football),
              label: const Text('firebase_starter'),
            ),
          ),
        );
        expect(find.byKey(key), findsOneWidget);
      });
    });
  });

  group('FSIconButton', () {
    testWidgets('throws AssertionError when icon is null', (tester) async {
      expect(
        () => tester.pumpWidget(
          FSIconButton(
            onPressed: () {},
            icon: null,
          ),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('renders child widget', (tester) async {
      const key = Key('__test_target__');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [
                FSIconButton(
                  key: key,
                  onPressed: () {},
                  icon: Icon(Icons.sports_football),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byKey(key), findsOneWidget);
    });
  });
}
