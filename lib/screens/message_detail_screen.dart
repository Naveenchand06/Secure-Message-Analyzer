import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:safe_messages/components/link_info_widget.dart';
import 'package:safe_messages/components/msg_detail_info_widget.dart';
import 'package:safe_messages/models/url_status_model.dart';
import 'package:safe_messages/network/link_verifier.dart';
import 'package:safe_messages/utils/str_extension.dart';

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
  LinkVerifier linker = LinkVerifier();
  List<UrlStatusModel> _urlStatus = [];
  bool _isLoading = false;
  bool _containsUrl = false;

  @override
  void initState() {
    if (widget.msg.body?.containsUrl() ?? false) {
      Future(() => getUrlReport());
    }
    super.initState();
  }

  void getUrlReport() async {
    setState(() {
      _isLoading = true;
      _containsUrl = true;
    });
    final List<String> urls = widget.msg.body!.getUrls();
    if (urls.isNotEmpty) {
      List<UrlStatusModel> urlStatus = [];
      for (var url in urls) {
        final type = await linker.getUrlType(urls.first);
        urlStatus.add(UrlStatusModel(url: url, type: type));
      }
      setState(() {
        _urlStatus = urlStatus;
        _isLoading = false;
      });
      return;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.msg.body?.containsUrl() ?? false
                        ? Center(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.blueGrey.shade100,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.link),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'Link',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 16.0),
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
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: const Text(
                        'Content: ',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: Text(
                        widget.msg.body.toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _containsUrl
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: const Tooltip(
                                  message: 'Tap on the link to copy it',
                                  padding: EdgeInsets.all(8.0),
                                  triggerMode: TooltipTriggerMode.tap,
                                  child: Icon(Icons.info),
                                ),
                              ),
                              Column(
                                children: _urlStatus
                                    .map((e) => LinkInfoWidget(info: e))
                                    .toList(),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }
}
