import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ai_toolkit/src/providers/interface/attachments.dart';

void main() {
  test('FileAttachment.fileOrImage returns ImageFileAttachment for images', () {
    final bytes = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0x00]);
    final att = FileAttachment.fileOrImage(
      name: 'photo.jpg',
      mimeType: 'image/jpeg',
      bytes: bytes,
    );

    expect(att, isA<ImageFileAttachment>());
    expect(att.name, 'photo.jpg');
    expect(att.mimeType, 'image/jpeg');
    expect(att.bytes.length, bytes.length);
  });

  test('FileAttachment.fileOrImage returns FileAttachment for non-images', () {
    final bytes = Uint8List.fromList([0x01, 0x02, 0x03]);
    final att = FileAttachment.fileOrImage(
      name: 'doc.bin',
      mimeType: 'application/octet-stream',
      bytes: bytes,
    );

    expect(att, isA<FileAttachment>());
    expect(att, isNot(isA<ImageFileAttachment>()));
    expect(att.name, 'doc.bin');
    expect(att.mimeType, 'application/octet-stream');
  });

  test('FileAttachment.fromFile reads bytes and preserves mime', () async {
    final data = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
    final file = XFile.fromData(data, mimeType: 'image/png', name: 'test.png');

    final attachment = await FileAttachment.fromFile(file);
    expect(attachment, isA<ImageFileAttachment>());
    expect(attachment.mimeType, 'image/png');
    expect(attachment.bytes, data);
  });
}
