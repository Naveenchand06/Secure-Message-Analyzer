import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

final contactsListProvider = StateProvider<List<Contact>>((ref) {
  return [];
});

final messagesListProvider = StateProvider<List<SmsMessage>>((ref) {
  return [];
});
