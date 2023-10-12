import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/home/index.dart';

// Mock class for the MethodChannel
class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  late MockMethodChannel mockMethodChannel;

  setUp(() {
    mockMethodChannel = MockMethodChannel();
  });

  group('_HomeScreenState', () {
    testWidgets('Check if the app bar title is "Home"', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Check if the "Navigate To Settings" button works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.tap(find.text('Navigate To Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings Screen'), findsOneWidget);
    });

    testWidgets('Check if the text fields are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(4)); // Excluding the footer button
    });

    testWidgets('Check if the date and time picker works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.tap(find.text('Chọn Thời Gian Bắt Đầu'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.byType(TimePickerDialog), findsOneWidget);

      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();

      expect(find.text('Thời Gian Bắt Đầu: '), findsOneWidget);
    });

    testWidgets('Check if the location button works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.tap(find.text('Select Location'));
      await tester.pumpAndSettle();

      // Verify the logic after navigating to the location screen
      // You can use `verify` from Mockito to check the expected behavior
      verify(mockMethodChannel.invokeMethod('your_native_method_name')).called(1);
    });

    testWidgets('Check if the "Lưu" button works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.enterText(find.byType(TextFormField), 'Test Task');
      await tester.tap(find.text('Chọn Thời Gian Bắt Đầu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      // Verify the logic after tapping the "Lưu" button
      // You can use `verify` from Mockito to check the expected behavior
      // Example: verify(context.read<TaskCubit>().insertTask(any)).called(1);
    });
  });
}
