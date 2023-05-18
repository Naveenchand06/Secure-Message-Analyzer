import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:safe_messages/repo/messages_repo.dart';
import 'package:safe_messages/screens/message_detail_screen.dart';

class MessagesWithLinksScreen extends ConsumerStatefulWidget {
  const MessagesWithLinksScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MessagesWithLinksScreenState();
}

class _MessagesWithLinksScreenState
    extends ConsumerState<MessagesWithLinksScreen> {
  bool _isLoading = true;
  List<SmsMessage> _linkMsgs = [];

  @override
  void initState() {
    Future(() => getMsgsWithLinks());
    super.initState();
  }

  void getMsgsWithLinks() {
    setState(() {
      _linkMsgs = ref.read(linkMessagesListProvider);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link Messages'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _linkMsgs.length,
              itemBuilder: (context, index) {
                SmsMessage msg = _linkMsgs[index];
                debugPrint('The msg is ==> ${msg.date}');
                return Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageDetailsScreen(msg: msg),
                        ),
                      ),
                      leading: const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                      title: Text(msg.sender ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(msgBody(msg.body.toString())),
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

  String msgBody(String msg) {
    if (msg.length > 45) {
      return '${msg.substring(0, 45)}...';
    }
    return msg;
  }
}
