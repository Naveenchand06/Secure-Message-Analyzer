import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:safe_messages/repo/all_list_repo.dart';
import 'package:safe_messages/screens/message_detail_screen.dart';
import 'package:safe_messages/utils/str_extension.dart';

class SafeMessagesScreen extends ConsumerStatefulWidget {
  const SafeMessagesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SafeMessagesScreenState();
}

class _SafeMessagesScreenState extends ConsumerState<SafeMessagesScreen> {
  bool _isLoading = true;
  List<SmsMessage> _safeMsgs = [];

  @override
  void initState() {
    Future(() => getSafeMessages());
    super.initState();
  }

  void getSafeMessages() async {
    final allSms = ref.read(messagesListProvider);
    final allNums = ref.read(conNumberListProvider);
    List<SmsMessage> safeMsgs = [];

    for (var sms in allSms) {
      if (allNums.contains(sms.sender?.toNumFormat())) {
        safeMsgs.add(sms);
      }
    }
    setState(() {
      _safeMsgs = safeMsgs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Messages'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _safeMsgs.length,
              itemBuilder: (context, index) {
                SmsMessage msg = _safeMsgs[index];
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
                      title: Text(msg.address ?? 'Unknown'),
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
    if (msg.length > 30) {
      return '${msg.substring(0, 15)}...';
    }
    return msg;
  }
}
