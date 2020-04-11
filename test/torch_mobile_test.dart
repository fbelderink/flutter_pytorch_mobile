import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:torch_mobile/torch_mobile.dart';

void main() {
  const MethodChannel channel = MethodChannel('torch_mobile');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect('42', '42');
  });
}
