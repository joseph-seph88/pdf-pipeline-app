import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

abstract class PdfMerger {
  static Future<Uint8List> merge(List<Uint8List> pdfs) async {
    if (pdfs.length == 1) return pdfs.first;

    final doc = pw.Document();
    for (final pdfBytes in pdfs) {
      final srcDoc = await pdfrx.PdfDocument.openData(pdfBytes);
      for (final page in srcDoc.pages) {
        final render = await page.render(
          width: (page.width * 2).toInt(),
          height: (page.height * 2).toInt(),
        );
        if (render == null) continue;
        final pngBytes =
            await _rgbaToPng(render.pixels, render.width, render.height);
        render.dispose();
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(page.width, page.height),
            margin: pw.EdgeInsets.zero,
            build: (_) => pw.Image(pw.MemoryImage(pngBytes)),
          ),
        );
      }
      srcDoc.dispose();
    }
    return doc.save();
  }

  static Future<Uint8List> _rgbaToPng(Uint8List pixels, int width, int height) {
    final completer = Completer<Uint8List>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (image) async {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        completer.complete(byteData!.buffer.asUint8List());
      },
    );
    return completer.future;
  }
}
