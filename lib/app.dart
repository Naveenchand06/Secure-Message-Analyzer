import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_messages/components/card_widget.dart';
import 'package:safe_messages/repo/all_list_repo.dart';
import 'package:safe_messages/screens/contacts_screen.dart';
import 'package:safe_messages/screens/messages_screen.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final SmsQuery query = SmsQuery();

  @override
  void initState() {
    _getPermissions();
    super.initState();
  }

  Future<void> _getPermissions() async {
    await getMessages();
    await getContacts();
  }

  Future<void> getMessages() async {
    bool isGranted = await Permission.sms.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.sms.request().isGranted;
    }
    if (isGranted) {
      _storeMessages(await query.getAllSms);
    }
  }

  Future<void> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      _storeContacts(await FastContacts.getAllContacts());
    }
  }

  _storeContacts(List<Contact> contacts) {
    ref.read(contactsListProvider.notifier).state = contacts;
  }

  _storeMessages(List<SmsMessage> msgs) {
    ref.read(messagesListProvider.notifier).state = msgs;
    debugPrint('SMS stored ==> ${ref.read(messagesListProvider)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardWidget(
                  title: 'Messages',
                  icon: Icons.message_outlined,
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessagesScreen(),
                    ),
                  ),
                ),
                CardWidget(
                  title: 'Contacts',
                  icon: Icons.contacts,
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactsScreen(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardWidget(
                  title: 'Safe Messages',
                  icon: Icons.safety_check,
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessagesScreen(),
                    ),
                  ),
                ),
                CardWidget(
                  title: 'Unsure Messages',
                  icon: Icons.unsubscribe_rounded,
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactsScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
