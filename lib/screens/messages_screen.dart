import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:safe_messages/repo/all_list_repo.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesListProvider);
    debugPrint('I Got Printed  Messages Length => ${messages.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS"),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          SmsMessage msg = messages[index];
          debugPrint('The msg is ==> ${msg.date}');
          return Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                title: Text(msg.sender ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msg.body ?? 'Empty'),
                  ],
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }
}
