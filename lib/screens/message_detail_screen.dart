import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:safe_messages/components/msg_detail_info_widget.dart';

class MessageDetailsScreen extends StatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.msg,
  });

  final SmsMessage msg;

  @override
  State<MessageDetailsScreen> createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MsgDetailInfoWidget(
              title: 'From: ',
              value: widget.msg.sender.toString(),
            ),
            const SizedBox(height: 8.0),
            MsgDetailInfoWidget(
              title: 'Received On: ',
              value: widget.msg.date.toString(),
            ),
            const SizedBox(height: 8.0),
            MsgDetailInfoWidget(
              title: 'Address: ',
              value: widget.msg.address.toString(),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Content: ',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.msg.body.toString(),
              style: const TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
