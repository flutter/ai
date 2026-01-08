import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:flutter_ai_toolkit/src/helpers/paste_helper/paste_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ai_toolkit/src/helpers/paste_helper/paste_helper_web.dart'
    as web_helper;
import 'package:flutter_ai_toolkit/src/providers/interface/attachments.dart';
import 'package:super_clipboard/super_clipboard.dart';

class FakeDataReader extends ClipboardDataReader {
  final String text;

  FakeDataReader(this.text);

  @override
  ReadProgress? getFile(
    FileFormat? format,
    AsyncValueChanged<DataReaderFile> onFile, {
    ValueChanged<Object>? onError,
    bool allowVirtualFiles = true,
    bool synthesizeFilesFromURIs = true,
  }) {
    return null;
  }

  @override
  List<DataFormat<Object>> getFormats(List<DataFormat<Object>> allFormats) {
    // Indicate that this reader can provide plain text when present in the
    // list of all known formats. This keeps the fake minimal while allowing
    // `ClipboardReader` to detect available plain-text data.
    return allFormats.where((f) => f == Formats.plainText).toList();
  }

  @override
  Future<String?> getSuggestedName() async {
    return null;
  }

  @override
  ReadProgress? getValue<T extends Object>(
    ValueFormat<T> format,
    AsyncValueChanged<T?> onValue, {
    ValueChanged<Object>? onError,
  }) {
    return null;
  }

  @override
  Future<VirtualFileReceiver?> getVirtualFileReceiver({
    FileFormat? format,
  }) async {
    return null;
  }

  @override
  bool isSynthesized(DataFormat<Object> format) {
    return false;
  }

  @override
  bool isVirtual(DataFormat<Object> format) {
    return false;
  }

  @override
  // Minimal platform formats for tests.
  List<PlatformFormat> get platformFormats => <PlatformFormat>[];

  @override
  Future<T?> readValue<T extends Object>(ValueFormat<T> format) async {
    // If the caller requests plain text, return the supplied text.
    if (format as Object == Formats.plainText) {
      // Cast to `T` -- tests will request `String`.
      return text as T;
    }
    return null;
  }
}

void main() {
  test('paste web - text format', () async {
    final controller = TextEditingController();
    final captured = <Attachment>[];

    final fake = ClipboardReader([FakeDataReader('test')]);

    await web_helper.pasteOperation(
      controller: controller,
      onAttachments: (atts) => captured.addAll(atts),
      insertText: ({required controller, required text}) {
        controller.text = text;
      },
      reader: fake as dynamic,
    );

    expect(captured, isEmpty);
    expect(controller.text, 'test');
  });

  test('paste other platforms - text format', () async {
    final controller = TextEditingController(text: 'testing');
    final captured = <Attachment>[];

    await handlePaste(
      controller: controller,
      onAttachments: (atts) => captured.addAll(atts),
      insertText: ({required controller, required text}) {
        controller.text = text;
      },
    );

    expect(captured, isEmpty);
    expect(controller.text, 'testing');
  });
}
