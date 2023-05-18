import 'package:flutter/material.dart';
import 'package:safe_messages/models/url_type.dart';
import 'package:safe_messages/network/link_verifier.dart';
import 'package:safe_messages/utils/str_extension.dart';

class CheckUrlScreen extends StatefulWidget {
  const CheckUrlScreen({super.key});

  @override
  State<CheckUrlScreen> createState() => _CheckUrlScreenState();
}

class _CheckUrlScreenState extends State<CheckUrlScreen> {
  bool _isLoading = false;
  final LinkVerifier linker = LinkVerifier();
  UrlType? res;
  final key = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check URL'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Form(
                  key: key,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.blueGrey.shade300,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (!(value.toString().containsUrl())) {
                                return 'Enter a valid URL';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8.0),
                              hintText: 'Place you URL here',
                              enabled: !_isLoading,
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  width: 1.2,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (key.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              final type = await linker
                                  .getUrlType(controller.text.trim());
                              debugPrint('========>>>> $type');
                              setState(() {
                                res = type;
                                _isLoading = false;
                              });
                            }
                          },
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Check'),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (res != null) getIcon(res ?? UrlType.unknown),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getIcon(UrlType info) {
    Color color = Colors.orangeAccent;
    IconData icon = Icons.remove;
    String msg = 'Not Sure!';
    switch (info) {
      case UrlType.safe:
        color = Colors.green;
        icon = Icons.check;
        msg = 'The link is safe';
        break;
      case UrlType.unsafe:
        color = Colors.redAccent;
        icon = Icons.close;
        msg = 'The link is safe';

        break;
      default:
        break;
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        )
      ],
    );
  }
}
