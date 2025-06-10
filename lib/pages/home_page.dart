// ignore_for_file: avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/utils/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lunch Sharing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: InvoiceService().getInvoicesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Đã xảy ra lỗi');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '${formatFirebaseTimestamp(data['createdAt'])} - ${data['storeName']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 10),

                              const SizedBox(width: 10),
                              RichText(
                                text: TextSpan(
                                  text: 'Tổng tiền: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: data['paidAmount'].toString(),
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: {
                              0: const FlexColumnWidth(1.5),
                              1: const FlexColumnWidth(),
                              2: const FlexColumnWidth(),
                              3: const FlexColumnWidth(),
                            },

                            children:
                                [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.7),
                                    ),
                                    children: [
                                      Text(
                                        'Name',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 2.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Original Price',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 2.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Percentage',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 2.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Actual Price',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 2.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] +
                                List.generate(data['orderers'].length + 1, (
                                  index,
                                ) {
                                  if (index == data['orderers'].length) {
                                    return TableRow(
                                      children: [
                                        const SizedBox(),
                                        Text(
                                          'Total: ${data['orderers'].fold(0.0, (sum, item) => sum + item['itemPrice'])}',

                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '100%',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Total: ${data['orderers'].fold(0.0, (sum, item) => sum + item['actualPrice'])}',

                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  }

                                  return TableRow(
                                    children: [
                                      // * Name
                                      Text(
                                        data['orderers'][index]['name'] ?? '',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // * Original Price
                                      Text(
                                        data['orderers'][index]['itemPrice']
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // * Percentage
                                      Text(
                                        '${data['orderers'][index]['percentage'] * 100} %',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // * Actual Price
                                      Text(
                                        data['orderers'][index]['actualPrice']
                                            .toString(),

                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
