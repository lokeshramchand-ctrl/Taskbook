import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskbook/main.dart';

void main() {
  testWidgets('App starts without crashing and shows a screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaskbookApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
