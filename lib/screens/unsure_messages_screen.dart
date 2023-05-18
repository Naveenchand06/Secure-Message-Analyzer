import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:safe_messages/repo/all_list_repo.dart';
import 'package:safe_messages/screens/message_detail_screen.dart';
import 'package:safe_messages/utils/str_extension.dart';

class UnsureMessagesScreen extends ConsumerStatefulWidget {
  const UnsureMessagesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UnsureMessagesScreenState();
}

class _UnsureMessagesScreenState extends ConsumerState<UnsureMessagesScreen> {
  bool _isLoading = true;
  List<SmsMessage> _unsureMsgs = [];

  @override
  void initState() {
    Future(() => getSafeMessages());
    super.initState();
  }

  void getSafeMessages() async {
    final allSms = ref.read(messagesListProvider);
    final allNums = ref.read(conNumberListProvider);
    List<SmsMessage> unsureMsgs = [];

    for (var sms in allSms) {
      if (!allNums.contains(sms.sender?.toNumFormat())) {
        unsureMsgs.add(sms);
      }
    }
    setState(() {
      _unsureMsgs = unsureMsgs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unsure Messages'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _unsureMsgs.length,
              itemBuilder: (context, index) {
                SmsMessage msg = _unsureMsgs[index];
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
    if (msg.length > 40) {
      return '${msg.substring(0, 40)}...';
    }
    return msg;
  }
}
