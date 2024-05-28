import 'package:captura_lens/model/register_competition_model.dart';
import 'package:captura_lens/photographer/photo_home.dart';
import 'package:captura_lens/services/payment_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:upi_india/upi_exception.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';

import '../constants.dart';

class PhotoEventPayment extends StatefulWidget {
  String upiId;
  RegisterCompetitionModel registerCompetitionModel;
  String regId;
  double amount;
  PhotoEventPayment(
      {super.key,
      required this.registerCompetitionModel,
      required this.upiId,
      required this.amount,
      required this.regId});

  @override
  State<PhotoEventPayment> createState() => _PhotoEventPaymentState();
}

class _PhotoEventPaymentState extends State<PhotoEventPayment> {
  Future<UpiResponse>? transaction;
  @override
  Widget build(BuildContext context) {
    setState(() {});

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CupertinoColors.black,
      ),
      body: Column(children: [
        Container(
          color: CupertinoColors.black,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Payment',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Make an advance payment',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        FutureBuilder(
          future: PaymentController().initializeUpiIndia(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print("1");
                      transaction = PaymentController().initiateTransaction(
                          context,
                          app: snapshot.data![index],
                          receiverUpiId: widget.upiId,
                          receiverName: "Captura Lens",
                          amount: widget.amount);
                      print("2");
                    },
                    leading: Image.memory(snapshot.data![index].icon),
                    title: Text(
                      snapshot.data![index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            );
          },
        ),
        FutureBuilder(
            future: transaction,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(_upiErrorHandler(snapshot.error.runtimeType),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ));
                }
                UpiResponse upiResponse = snapshot.data!;

                String txnId = upiResponse.transactionId ?? 'N/A';
                String resCode = upiResponse.responseCode ?? 'N/A';
                String txnRef = upiResponse.transactionRefId ?? 'N/A';
                String status = upiResponse.status ?? 'N/A';
                String approvalRef = upiResponse.approvalRefNo ?? 'N/A';
                _checkTxnStatus(status);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      displayTransactionData('Transaction Id', txnId),
                      displayTransactionData('Response Code', resCode),
                      displayTransactionData('Reference Id', txnRef),
                      displayTransactionData('Status', status.toUpperCase()),
                      displayTransactionData('Approval No', approvalRef),
                    ],
                  ),
                );
              }

              return const Text(
                "",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              );
            }),
        SizedBox(
          height: 30,
        )
      ]),
    );
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              )),
          Flexible(
              child: Text(
            body,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    );
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }
}
