import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

final safeMessagesProvider =
    StateNotifierProvider<SafeMessages, List<SmsMessage>>((ref) {
  return SafeMessages();
});

class SafeMessages extends StateNotifier<List<SmsMessage>> {
  SafeMessages() : super([]);
}
