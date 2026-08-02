import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumo/app/lumo_app.dart';

void main() {
  testWidgets('Lumo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LumoApp()),
    );
  });
}
