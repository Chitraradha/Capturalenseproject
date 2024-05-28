import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class PaymentController with ChangeNotifier {
  List<UpiApp>? apps;
  Future<UpiResponse>? transaction;

  // getResponse(UpiResponse? upiResponse) {
  //   upiResponse = upiResponse;
  //   notifyListeners();
  // }

  UpiIndia _upiIndia = UpiIndia();
  Future<List<UpiApp>> initializeUpiIndia() async {
    return await _upiIndia
        .getAllUpiApps(mandatoryTransactionId: false)
        .then((value) {
      return apps = value;
    }).catchError((e) {
      return apps = [];
    });
  }

  Future<UpiResponse> initiateTransaction(context,
      {required UpiApp app,
      required String receiverUpiId,
      required String receiverName,
      required double amount}) async {
    print("object");
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: receiverUpiId,
      receiverName: receiverName,
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: amount,
    );
  }
}
