import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazistory/l10n/app_localizations.dart';

class ListElement extends ConsumerStatefulWidget {
  const ListElement(this.text, {super.key});
  final String text;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ListElementState();
  }
}

class _ListElementState extends ConsumerState<ListElement> {
  @override
  void initState() {
    super.initState();
  }

  final _globalKey = GlobalKey();
  bool _expanded = false;
  int? _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    int textLines = widget.text.split('\n').length;
    VoidCallback? expandButtonAction;
    if (2 < textLines) {
      expandButtonAction = () {
        if (_expanded) {
          setState(() {
            _expanded = false;
            _maxLines = 2;
          });
        } else {
          setState(() {
            _expanded = true;
            _maxLines = null;
          });
        }
      };
    } else {
      expandButtonAction = null;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  key: _globalKey,
                  widget.text,
                  maxLines: _maxLines,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            IconButton(
              onPressed: expandButtonAction,
              icon: _expanded ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () {
                final data = ClipboardData(text: widget.text);
                Clipboard.setData(data).then((_) {
                  if (context.mounted) {
                    final snackBar = SnackBar(
                      content: Text(AppLocalizations.of(context)!.copiedToClipboard),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
