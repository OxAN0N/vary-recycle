import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class QrBarcodeScanner extends StatefulWidget {
  const QrBarcodeScanner({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  State<QrBarcodeScanner> createState() => _QrBarcodeScannerState();
}

class _QrBarcodeScannerState extends State<QrBarcodeScanner> {
  // String? _qrInfo = 'Scan a QR/Bar code';
  var _camState;
  _qrCallback(String? code) {
    setState(() {
      _camState = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: ((context) {
      return ScannedProduct(
        productCode: code,
        changeState: _scanCode,
      );
    })));
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _scanCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('물건의 QR/바코드를 인식해주세요'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: _camState
          ? Center(
              child: SizedBox(
                height: 350,
                width: 500,
                child: QRBarScannerCamera(
                  onError: (context, error) => Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                  qrCodeCallback: (code) {
                    _qrCallback(code);
                  },
                  notStartedBuilder: (context) => const Center(
                      widthFactor: 10, child: CircularProgressIndicator()),
                ),
              ),
            )
          : Container(
              color: Colors.transparent,
            ),
    );
  }
}

class ScannedProduct extends StatefulWidget {
  final VoidCallback changeState;
  final productCode;
  const ScannedProduct(
      {super.key, this.productCode, required this.changeState});

  @override
  State<ScannedProduct> createState() => _ScannedProductState();
}

class _ScannedProductState extends State<ScannedProduct> {
  String? productName;
  String? productImage;
  bool _isProduct = false;

  Future<dynamic> _httpReq() async {
    var code = widget.productCode.toString();
    var url = "http://www.koreannet.or.kr/home/hpisSrchGtin.gs1?gtin=$code";
    var response = await http.get(Uri.parse(url));
    var responseBody = response.body;
    var document = parse(responseBody);

    if (document.getElementsByClassName('noresult').isNotEmpty) {
      productName = 'Can not Find the Product';
    } else {
      productName = document
          .getElementsByClassName('productTit')[0]
          .innerHtml
          .toString()
          .split(';')
          .last;
      productImage = document.getElementById('detailImage')!.attributes['src'];
      if (mounted) {
        setState(() {
          _isProduct = true;
        });
      }
    }
    return document;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('해당 제품을 재활용하시겠습니까?'),
        leading: BackButton(
          onPressed: () {
            widget.changeState();
            Navigator.pop(context);
          },
        ),
      ),
      body: WillPopScope(
        child: FutureBuilder(
          future: _httpReq(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(fontSize: 15),
                ),
              );
            } else {
              return Center(
                // child:
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isProduct) Image.network(productImage!),
                    Text("$productName"),
                  ],
                ),
              );
            }
          },
        ),
        onWillPop: () async => false,
      ),
    );
  }
}
