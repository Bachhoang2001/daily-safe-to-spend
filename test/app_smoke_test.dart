import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/app.dart';

void main() {
  testWidgets('T00-1: render GetMaterialApp tối thiểu không lỗi', (
    tester,
  ) async {
    await tester.pumpWidget(const SafeToSpendApp());

    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
