// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

bool _contextMenuDisabled = false;

void disableBrowserContextMenuForApp() {
  if (_contextMenuDisabled) return;
  _contextMenuDisabled = true;
  html.document.onContextMenu.listen((event) => event.preventDefault());
}

