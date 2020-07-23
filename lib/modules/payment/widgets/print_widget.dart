import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

// import 'dart:typed_data';

import 'package:flutter/material.dart' hide Image;
// import 'package:flutter/services.dart';
// import 'package:image/image.dart';

import 'package:intl/intl.dart';
import 'package:ks_bike_mobile/models/store.dart';
import 'package:ks_bike_mobile/models/transaction.dart';
import 'package:ks_bike_mobile/modules/payment/widgets/cubit/load_store_cubit.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import 'package:ks_bike_mobile/utils/toast.dart';

class PrintWidget extends StatefulWidget {
  final Transaction transaction;
  PrintWidget({Key key, @required this.transaction}) : super(key: key);

  @override
  _PrintWidgetState createState() => _PrintWidgetState();
}

class _PrintWidgetState extends State<PrintWidget> {
  final LoadStoreCubit _loadStoreCubit = LoadStoreCubit();
  final PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  List<PrinterBluetooth> _devices = [];
  Store store;

  @override
  void initState() {
    super.initState();
    _loadStoreCubit.loadStore();
    _startScanDevices();

    printerManager.scanResults.listen((devices) async {
      setState(() {
        _devices = devices;
      });
    });

    _loadStoreCubit.listen((state) {
      Stream<Store> streamStore = state.props[0];
      streamStore.listen((event) {
        store = event;
      });
    });
  }

  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(Duration(seconds: 3));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  void _testPrint(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);

    // TODO Don't forget to choose printer's paper
    const PaperSize paper = PaperSize.mm58;

    // TEST PRINT
    // final PosPrintResult res =
    // await printerManager.printTicket(await testTicket(paper));

    // DEMO RECEIPT
    final PosPrintResult res =
        await printerManager.printTicket(await receipt(paper));

    toastSuccess(res.msg);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Print Struk',
                style: Theme.of(context).textTheme.headline6,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
        ),
        Divider(
          height: 16.0,
        ),
        StreamBuilder<bool>(
            stream: printerManager.isScanningStream,
            initialData: false,
            builder: (context, snapshot) {
              if (!snapshot.data) {
                if (_devices.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tidak ditemukan printer',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _devices.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => _testPrint(_devices[index]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.print),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_devices[index].name ?? ''),
                                        Text(_devices[index].address),
                                        Text(
                                          'Click to print a test receipt',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    });
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ));
              }
            }),
        SizedBox(
          height: 16.0,
        ),
        StreamBuilder<bool>(
          stream: printerManager.isScanningStream,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return Container(
                color: Colors.red,
                padding: EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: _stopScanDevices,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Stop',
                        style: Theme.of(context).textTheme.button,
                      ),
                      SizedBox(width: 8.0),
                      Icon(
                        Icons.stop,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: _startScanDevices,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Cari Printer',
                        style: Theme.of(context).textTheme.button,
                      ),
                      SizedBox(width: 8.0),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<Ticket> receipt(PaperSize paper) async {
    final Transaction trx = widget.transaction;
    final Ticket ticket = Ticket(paper);
    // Print image
    // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image image = decodeImage(bytes);
    // ticket.image(image);

    ticket.text('${store.storeName.toUpperCase()}',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    ticket.text('${store.storeAddress}',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: ${store.storePhone}',
        styles: PosStyles(align: PosAlign.center));

    ticket.hr();

    ticket.row([
      PosColumn(text: 'Transaksi', width: 5),
      PosColumn(text: '${trx.code}', width: 7),
    ]);

    final dt = DateTime.fromMillisecondsSinceEpoch(trx.createdAt);
    final formatter = DateFormat('dd/MM/yyyy H:m');
    ticket.row([
      PosColumn(text: 'Tanggal', width: 5),
      PosColumn(text: '${formatter.format(dt)}', width: 7),
    ]);

    ticket.row([
      PosColumn(text: 'Kasir', width: 5),
      PosColumn(text: '${trx.cashier}', width: 7),
    ]);

    ticket.hr();

    trx.items.forEach((element) {
      ticket.text('${element.itemName.toUpperCase()}',
          styles: PosStyles(align: PosAlign.left));
      ticket.row([
        PosColumn(text: '${element.qty}x', width: 2),
        PosColumn(
            text: '${currencyFormatternoSym.format(element.sellPrice)}',
            width: 5,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text:
                '${currencyFormatternoSym.format(element.sellPrice * element.qty)}',
            width: 5,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });

    ticket.hr();

    ticket.row([
      PosColumn(
          text: 'Diskon',
          width: 7,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: currencyFormatter.format(trx.discount),
          width: 5,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);

    ticket.row([
      PosColumn(
          text: 'TOTAL',
          width: 7,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: currencyFormatter.format(trx.total),
          width: 5,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);

    ticket.hr(ch: '=', linesAfter: 1);

    ticket.row([
      PosColumn(
          text: 'Dibayar',
          width: 7,
          styles: PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: currencyFormatter.format(trx.totalPaid),
          width: 5,
          styles: PosStyles(
            align: PosAlign.right,
          )),
    ]);
    ticket.row([
      PosColumn(
          text: 'Kembalian',
          width: 7,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: currencyFormatter.format(trx.totalChange),
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.hr();

    ticket.text(
      'Terima kasih atas kunjungan anda',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    ticket.hr();
    ticket.text(
      'Barang yang sudah terbeli tidak bisa ditukar kembali',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());

    //   ticket.image(img);
    // } catch (e) {
    //   print(e);
    // }

    // Print QR Code using native function
    // ticket.qrcode('example.com');

    ticket.feed(2);
    ticket.cut();
    return ticket;
  }
}
