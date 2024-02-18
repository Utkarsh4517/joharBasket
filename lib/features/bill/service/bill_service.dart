import 'dart:io';
import 'dart:typed_data';
import 'package:johar/features/order/bloc/order_bloc.dart';
import 'package:johar/features/profile/bloc/profile_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BillService {
  Future<Uint8List> generatePdfCustomer({
    required List orderIdList,
    required OrderLoadedSuccessState successState,
    required OrderBloc bloc,
    required int indexU,
    // required String invoice,
    required String total,
  }) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context content) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Johar Basket',
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 20),
                            pw.Text(
                                'Near Chhat Talab Phulsarai \nRamgarh - 829101(Jharkhand)\nMob. no. +91 9431728628'),
                            pw.SizedBox(height: 15),
                            // pw.Text('Invoice no : $invoice'),
                            pw.Text('Date : '),
                            pw.Text('Order No. : ${orderIdList[indexU]}')
                          ])
                    ]),
                pw.SizedBox(height: 50),
                pw.Container(
                    decoration:
                        pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Sl. no.'),
                          ),
                          pw.Container(
                            width: 120,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Particulars'),
                          ),
                          pw.Container(
                            width: 90,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Quantity'),
                          ),
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Rate'),
                          ),
                          pw.Container(
                            width: 100,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Amount'),
                          ),
                        ])),
                pw.ListView.builder(
                  itemCount: successState.orders[indexU].length,
                  itemBuilder: (context, index) {
                    return pw.Container(
                        margin: pw.EdgeInsets.symmetric(vertical: 15),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Container(
                                width: 80,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text((index + 1).toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 120,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState.orders[indexU][index].name,
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 90,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState.orders[indexU][index].nos
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 80,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState
                                        .orders[indexU][index].discountedPrice
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 100,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    (successState.orders[indexU][index]
                                                .discountedPrice *
                                            successState
                                                .orders[indexU][index].nos)
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                            ]));
                  },
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(right: 30),
                      child: pw.Text('Total : $total',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(left: 30),
                      child: pw.Text('Authorised Signatory',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          )),
                    ),
                  ],
                )
              ]);
        },
      ),
    );
    return pdf.save();
  }

   Future<Uint8List> generatePdfAdminPanel({
    required List orderIdList,
    required ProfileOrderLoadedSuccessState successState,
    required int indexU,
    required String total,
  }) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context content) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Johar Basket',
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 20),
                            pw.Text(
                                'Near Chhat Talab Phulsarai \nRamgarh - 829101(Jharkhand)\nMob. no. +91 9431728628'),
                            pw.SizedBox(height: 15),
                            pw.Text('Date : '),
                            pw.Text('Order No. : ${orderIdList[indexU]}')
                          ])
                    ]),
                pw.SizedBox(height: 50),
                pw.Container(
                    decoration:
                        pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Sl. no.'),
                          ),
                          pw.Container(
                            width: 120,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Particulars'),
                          ),
                          pw.Container(
                            width: 90,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Quantity'),
                          ),
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Rate'),
                          ),
                          pw.Container(
                            width: 100,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Amount'),
                          ),
                        ])),
                pw.ListView.builder(
                  itemCount: successState.orders[indexU].length,
                  itemBuilder: (context, index) {
                    return pw.Container(
                        margin: pw.EdgeInsets.symmetric(vertical: 15),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Container(
                                width: 80,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text((index + 1).toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 120,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState.orders[indexU][index].name,
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 90,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState.orders[indexU][index].nos
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 80,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState
                                        .orders[indexU][index].discountedPrice
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 100,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    (successState.orders[indexU][index]
                                                .discountedPrice *
                                            successState
                                                .orders[indexU][index].nos)
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                            ]));
                  },
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(right: 30),
                      child: pw.Text('Total : $total',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(left: 30),
                      child: pw.Text('Authorised Signatory',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          )),
                    ),
                  ],
                )
              ]);
        },
      ),
    );
    return pdf.save();
  }

    Future<Uint8List> generatePdfDeliveredOrder({
    required List orderIdList,
    required StatsPageOrderDeliveredSuccessState successState,
    required int indexU,
    required String total,
  }) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context content) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Johar Basket',
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 20),
                            pw.Text(
                                'Near Chhat Talab Phulsarai \nRamgarh - 829101(Jharkhand)\nMob. no. +91 9431728628'),
                            pw.SizedBox(height: 15),
                            pw.Text('Date : '),
                            pw.Text('Order No. : ${orderIdList[indexU]}')
                          ])
                    ]),
                pw.SizedBox(height: 50),
                pw.Container(
                    decoration:
                        pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Sl. no.'),
                          ),
                          pw.Container(
                            width: 120,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Particulars'),
                          ),
                          pw.Container(
                            width: 90,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Quantity'),
                          ),
                          pw.Container(
                            width: 80,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Rate'),
                          ),
                          pw.Container(
                            width: 100,
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.symmetric(horizontal: 20),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 1.5),
                              ),
                            ),
                            child: pw.Text('Amount'),
                          ),
                        ])),
                pw.ListView.builder(
                  itemCount: successState.orders[indexU].length,
                  itemBuilder: (context, index) {
                    return pw.Container(
                        margin: pw.EdgeInsets.symmetric(vertical: 15),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Container(
                                width: 80,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text((index + 1).toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 120,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState.orders[indexU][index].name,
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 90,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState.orders[indexU][index].nos
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 80,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    successState
                                        .orders[indexU][index].discountedPrice
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                              pw.Container(
                                width: 100,
                                alignment: pw.Alignment.center,
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 20),
                                child: pw.Text(
                                    (successState.orders[indexU][index]
                                                .discountedPrice *
                                            successState
                                                .orders[indexU][index].nos)
                                        .toString(),
                                    style: pw.TextStyle(fontSize: 8)),
                              ),
                            ]));
                  },
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(right: 30),
                      child: pw.Text('Total : $total',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(left: 30),
                      child: pw.Text('Authorised Signatory',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          )),
                    ),
                  ],
                )
              ]);
        },
      ),
    );
    return pdf.save();
  }


  Future<void> savePdfFile(
      {required String filename, required Uint8List byteList}) async {
    final output = await getTemporaryDirectory();
    var filePath = '${output.path}/$filename.pdf';
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
