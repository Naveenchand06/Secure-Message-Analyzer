import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_messages/models/url_status_model.dart';
import 'package:safe_messages/models/url_type.dart';
import 'package:safe_messages/utils/app_snackbar.dart';

class LinkInfoWidget extends StatelessWidget {
  const LinkInfoWidget({
    super.key,
    required this.info,
  });

  final UrlStatusModel info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: info.type == UrlType.safe
          ? () async {
              await Clipboard.setData(ClipboardData(text: info.url));
              showToast(context, 'Copied to clipboard');
            }
          : () => showToast(context, 'You cannot copy unsafe URL', false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 280.0,
              child: Text(
                info.url,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            getIcon(),
          ],
        ),
      ),
    );
  }

  Widget getIcon() {
    Color color = Colors.orangeAccent;
    IconData icon = Icons.remove;
    switch (info.type) {
      case UrlType.safe:
        color = Colors.green;
        icon = Icons.check;
        break;
      case UrlType.unsafe:
        color = Colors.redAccent;
        icon = Icons.close;
        break;
      default:
        break;
    }

    return CircleAvatar(
      radius: 18.0,
      backgroundColor: color,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
