import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SmsQuery query = SmsQuery();

  Future<List<SmsMessage>> getMessages() async {
    bool isGranted = await Permission.sms.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.sms.request().isGranted;
    }
    if (isGranted) {
      return await query.getAllSms;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS"),
      ),
      body: SizedBox(
        height: double.infinity,
        child: FutureBuilder<List<SmsMessage>>(
          future: getMessages(),
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'Messages List are empty',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      SmsMessage msg = snapshot.data[index];

                      return Column(children: [
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
                      ]);
                    });
              default:
                return const Text('Something Went wrong');
            }
          },
        ),
      ),
    );
  }
}
