import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_messages/components/card_widget.dart';
import 'package:safe_messages/components/no_permission_screen.dart';
import 'package:safe_messages/repo/all_list_repo.dart';
import 'package:safe_messages/repo/messages_repo.dart';
import 'package:safe_messages/screens/check_url_screen.dart';
import 'package:safe_messages/screens/contacts_screen.dart';
import 'package:safe_messages/screens/messages_screen.dart';
import 'package:safe_messages/screens/messages_with_links_screen.dart';
import 'package:safe_messages/screens/safe_messages_screen.dart';
import 'package:safe_messages/screens/unsure_messages_screen.dart';
import 'package:safe_messages/utils/str_extension.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final SmsQuery query = SmsQuery();
  bool _isLoading = true;
  bool _showWheelView = false;
  bool _hasSmsPermission = false;
  bool _hasContactsPermission = false;

  @override
  void initState() {
    Future(() => _getPermissions());
    super.initState();
  }

  Future<void> _getPermissions() async {
    await getMessages();
    await getContacts();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getMessages() async {
    bool isGranted = await Permission.sms.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.sms.request().isGranted;
    }
    if (isGranted) {
      _storeMessages(await query.getAllSms);
      setState(() => _hasSmsPermission = true);
    }
  }

  Future<void> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      _storeContacts(await FastContacts.getAllContacts());
      setState(() => _hasContactsPermission = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showWheelView = !_showWheelView),
            icon: const Icon(Icons.change_circle),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: _showWheelView
                    ? ListWheelScrollView(
                        itemExtent: 180.0,
                        diameterRatio: 1.4,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          CardWidget(
                            title: 'Messages',
                            icon: Icons.message_outlined,
                            onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (_hasSmsPermission)
                                    ? const MessagesScreen()
                                    : const NoPermissionScreen(),
                              ),
                            ),
                          ),
                          CardWidget(
                            title: 'Contacts',
                            icon: Icons.contacts,
                            onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (_hasContactsPermission)
                                    ? const ContactsScreen()
                                    : const NoPermissionScreen(),
                              ),
                            ),
                          ),
                          CardWidget(
                            title: 'Safe Messages',
                            icon: Icons.safety_check,
                            onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (_hasSmsPermission &&
                                        _hasContactsPermission)
                                    ? const SafeMessagesScreen()
                                    : const NoPermissionScreen(),
                              ),
                            ),
                          ),
                          CardWidget(
                            title: 'Unsure Messages',
                            icon: Icons.unsubscribe_rounded,
                            onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (_hasSmsPermission &&
                                        _hasContactsPermission)
                                    ? const UnsureMessagesScreen()
                                    : const NoPermissionScreen(),
                              ),
                            ),
                          ),
                          CardWidget(
                            title: 'Messages with Links',
                            icon: Icons.link_rounded,
                            onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (_hasSmsPermission)
                                    ? const MessagesWithLinksScreen()
                                    : const NoPermissionScreen(),
                              ),
                            ),
                          ),
                          CardWidget(
                            title: 'Check URL',
                            icon: Icons.check_circle,
                            onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckUrlScreen(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
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
                                      builder: (context) => (_hasSmsPermission)
                                          ? const MessagesScreen()
                                          : const NoPermissionScreen(),
                                    ),
                                  ),
                                ),
                                CardWidget(
                                  title: 'Contacts',
                                  icon: Icons.contacts,
                                  onPress: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          (_hasContactsPermission)
                                              ? const ContactsScreen()
                                              : const NoPermissionScreen(),
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
                                      builder: (context) =>
                                          (_hasSmsPermission &&
                                                  _hasContactsPermission)
                                              ? const SafeMessagesScreen()
                                              : const NoPermissionScreen(),
                                    ),
                                  ),
                                ),
                                CardWidget(
                                  title: 'Unsure Messages',
                                  icon: Icons.unsubscribe_rounded,
                                  onPress: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          (_hasSmsPermission &&
                                                  _hasContactsPermission)
                                              ? const UnsureMessagesScreen()
                                              : const NoPermissionScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardWidget(
                                  title: 'Messages with Links',
                                  icon: Icons.link_rounded,
                                  onPress: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => (_hasSmsPermission)
                                          ? const MessagesWithLinksScreen()
                                          : const NoPermissionScreen(),
                                    ),
                                  ),
                                ),
                                CardWidget(
                                  title: 'Check URL',
                                  icon: Icons.check_circle,
                                  onPress: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CheckUrlScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }

  _storeContacts(List<Contact> contacts) {
    ref.read(contactsListProvider.notifier).state = contacts;
    storeNumbers(contacts);
  }

  _storeMessages(List<SmsMessage> msgs) {
    ref.read(messagesListProvider.notifier).state = msgs;
    final List<SmsMessage> msgWithLinks = [];
    for (var sms in msgs) {
      if (sms.body?.containsUrl() ?? false) {
        msgWithLinks.add(sms);
      }
    }
    ref.read(linkMessagesListProvider.notifier).saveMessages(msgWithLinks);
  }

  void storeNumbers(List<Contact> contacts) {
    List<String> conNums = [];
    for (var item in contacts) {
      for (var num in item.phones) {
        conNums.add(num.number.toNumFormat());
      }
    }
    ref.read(conNumberListProvider.notifier).state = conNums;
  }

  List<String?> extractURLs(String text) {
    final urlRegExp = RegExp(r'https?://[^\s]+');
    final matches = urlRegExp.allMatches(text);
    final urlsInStr = matches.map((match) => match.group(0)).toList();
    return urlsInStr;
  }
}
