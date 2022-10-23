import 'package:bintang_timur/dashboard/report/inventory/model_inventory_report.dart';
import 'package:bintang_timur/dashboard/report/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInventoryApi {
  static Future<File> generate(ContentI content) async {
    final pdf = Document();
    final logo = await rootBundle.loadString('assets/bt logo.svg');

    pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.a3.applyMargin(left: 0, top: 0, right: 0, bottom: 0),
      // pageTheme: PageTheme(pageFormat: PdfPageFormat.a4),
      build: (context) => [
        pw.SvgImage(svg: logo),
        buildHeader(),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(),
        buildTable(content),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(name: 'bintangtimur_inventory.pdf', pdf: pdf);
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Laporan Stok Barang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('Laporan Stok Barang Toko Bintang Timur'),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildHeader() {
    final now = DateTime.now();
    String time = DateFormat('dd-MM-yyyy').format(now);
    // final inti = initializeDateFormatting('id_ID', '');
    final titles = <String>['Nomor Laporan:', 'Tanggal Laporan:'];
    final data = <String>[
      '${DateTime.now().year}-INRBT',
      '$time'
      // '${DateFormat('EEEE, d MMMM yyyy').format(DateTime.now())}'
    ];
    return pw
        .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.SizedBox(height: 1 * PdfPageFormat.cm),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('Bintang Timur',
              style:
                  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text('Senen, Jakarta Pusat, DKI Jakarta')
        ]),
        pw.Container(
            height: 70,
            width: 70,
            child: pw.BarcodeWidget(
                data: '${DateTime.now().year}-INRBT',
                barcode: Barcode.qrCode()))
      ]),
      pw.SizedBox(height: 1 * PdfPageFormat.cm),
      pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(titles.length, (index) {
                final title = titles[index];
                final value = data[index];
                return buildText(title: title, value: value, width: 200);
              }),
            )
          ])
    ]);
  }

  static Widget buildFooter() {
    return Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
        pw.Text('Pemimpin',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 2 * PdfPageFormat.cm),
        pw.Text('Wahyudin', style: pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
      ]),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
        pw.Divider(),
        pw.SizedBox(height: 2 * PdfPageFormat.mm),
        buildSimpleText(
            title: 'Alamat',
            value:
                'Jl. Salemba Bluntas RT.11/RW.05, Senen, Jakarta Pusat, DKI Jakarta')
      ])
    ]);
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(title, style: style),
          pw.SizedBox(width: 2 * PdfPageFormat.mm),
          pw.Text(value)
        ]);
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
        width: width,
        child: pw.Row(children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null)
        ]));
  }

  static Widget buildTable(ContentI content) {
    final header = ['Tanggal', 'Barcode', 'Nama Barang', 'Harga', 'Jumlah'];

    final data = content.inventory.map((e) {
      return [e.date, e.barcode, e.name, e.sellingPrice, e.qty];
    }).toList();

    return Table.fromTextArray(
      headers: header,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.center,
        4: Alignment.center,
      },
      // cellPadding: pw.EdgeInsets.symmetric(horizontal: 5)
    );
  }
}
