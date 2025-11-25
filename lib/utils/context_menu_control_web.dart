import 'dart:js_interop';

import 'package:web/web.dart' as web;

bool _contextMenuDisabled = false;

void disableBrowserContextMenuForApp() {
  if (_contextMenuDisabled) return;
  _contextMenuDisabled = true;

  web.window.addEventListener(
    'contextmenu',
    (web.Event event) {
      event.preventDefault();
    }.toJS,
  );
}
