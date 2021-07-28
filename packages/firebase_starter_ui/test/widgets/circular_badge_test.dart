// ignore_for_file: prefer_const_constructors
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FSCircularBadge', () {
    test('throws AssertionError when child is null', () {
      expect(
        () => FSCircularBadge(
          child: null,
        ),
        throwsAssertionError,
      );
    });

    test('throws AssertionError when elevation is null', () {
      expect(
        () => FSCircularBadge(
          elevation: null,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('throws AssertionError when color is null', () {
      expect(
        () => FSCircularBadge(
          color: null,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('throws AssertionError when clipBehavior is null', () {
      expect(
        () => FSCircularBadge(
          clipBehavior: null,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('throws AssertionError when radius is null', () {
      expect(
        () => FSCircularBadge(
          radius: null,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    group('.empty', () {
      test('throws AssertionError when elevation is null', () {
        expect(
          () => FSCircularBadge.empty(
            elevation: null,
          ),
          throwsAssertionError,
        );
      });

      test('throws AssertionError when color is null', () {
        expect(
          () => FSCircularBadge.empty(
            color: null,
          ),
          throwsAssertionError,
        );
      });

      test('throws AssertionError when radius is null', () {
        expect(
          () => FSCircularBadge.empty(
            radius: null,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('renders', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: FSCircularBadge.empty(),
          ),
        );
      });
    });

    testWidgets('renders child', (tester) async {
      const key = Key('__test_target__');

      await tester.pumpWidget(
        MaterialApp(
          home: FSCircularBadge(
            child: SizedBox(key: key),
          ),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders elevation', (tester) async {
      const elevation = 9.9;

      await tester.pumpWidget(
        MaterialApp(
          home: FSCircularBadge(
            elevation: elevation,
            child: const SizedBox(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Material && widget.elevation == elevation,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders color', (tester) async {
      const color = Color(0xFFAABBCC);

      await tester.pumpWidget(
        MaterialApp(
          home: FSCircularBadge(
            color: color,
            child: const SizedBox(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is CircleAvatar && widget.backgroundColor == color,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders correct radius', (tester) async {
      const radius = 9.9;

      await tester.pumpWidget(
        MaterialApp(
          home: FSCircularBadge(
            radius: radius,
            child: const SizedBox(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is CircleAvatar && widget.radius == radius,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'sets default text color to black if provided color is bright',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: FSCircularBadge(
              color: FSColors.white,
              child: const SizedBox(),
            ),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is DefaultTextStyle &&
                widget.style.color == FSColors.black,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'sets default text color to white if provided color is dark',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: FSCircularBadge(
              color: FSColors.black,
              child: const SizedBox(),
            ),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is DefaultTextStyle &&
                widget.style.color == FSColors.white,
          ),
          findsOneWidget,
        );
      },
    );
  });
}
