import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/models/index.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/widgets/index.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  List<Orderers> records = [];
  final TextEditingController storeNameCtrl = TextEditingController();

  double totalOriginal = 0;
  double actualPurchase = 0;
  double delta = 0;
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: 600,
        child: AddRecordDrawer(
          onConfirm: (value) {
            setState(() {
              records = value;
              totalOriginal = records.fold(
                0.0,
                (sum, item) => sum + item.itemPrice,
              );
              if (totalOriginal > 0 && actualPurchase > 0) {
                delta = (actualPurchase - totalOriginal);
              }
            });
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Lunch Sharing'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: AddUserDrawer());
                },
              );
            },
            icon: Icon(Icons.group_add_outlined),
          ),
          IconButton(
            onPressed: () async {
              EasyLoading.show();
              if (actualPurchase == 0 ||
                  storeNameCtrl.text.isEmpty ||
                  records.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              records = records
                  .map((e) => e.calculatePercentage(totalOriginal))
                  .map((e) => e.calculateActualPrice(delta))
                  .toList();

              final sts = await InvoiceService().addInvoice(
                storeName: storeNameCtrl.text,
                paidAmount: actualPurchase,
                date: selectedDate,
                orderers: records,
              );
              EasyLoading.dismiss();

              if (!context.mounted) return;
              if (sts) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice added successfully')),
                );
                setState(() {
                  records = [];
                  totalOriginal = 0;
                  actualPurchase = 0;
                  delta = 0;
                  storeNameCtrl.clear();
                  selectedDate = DateTime.now();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add invoice')),
                );
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Delta: $delta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Restaurant Name: '),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: TextField(
                    controller: storeNameCtrl,

                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter restaurant name',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text('Total amount paid: '),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      setState(() {
                        actualPurchase = double.tryParse(value) ?? 0;
                        delta = (actualPurchase - totalOriginal);
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter total amount paid',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text('Select a Date: '),
                InkWell(
                  onTap: () {
                    SingleDatePicker.show(
                      context,
                      onDateSelected: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),

                    child: Text(
                      selectedDate.jiffyFormatToString('EEE, dd/MM/yyyy'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: const FlexColumnWidth(1.5),
                      1: const FlexColumnWidth(),
                      2: const FlexColumnWidth(),
                      3: const FlexColumnWidth(),
                    },

                    children: [
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
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: const FlexColumnWidth(1.5),
                          1: const FlexColumnWidth(),
                          2: const FlexColumnWidth(),
                          3: const FlexColumnWidth(),
                        },
                        children: List.generate(records.length + 1, (index) {
                          if (index == records.length) {
                            return TableRow(
                              children: [
                                const SizedBox(),
                                Text(
                                  records.isEmpty
                                      ? 'No Records'
                                      : 'Total: $totalOriginal',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  records.isEmpty ? 'No Records' : '100%',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(),
                              ],
                            );
                          }

                          return TableRow(
                            children: [
                              // * Name
                              Text(
                                records[index].name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // * Original Price
                              Text(
                                records[index].itemPrice.toString(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // * Percentage
                              Text(
                                '${(records[index].percentage * 100).toStringAsFixed(2)}%',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // * Actual Price
                              Text(
                                delta != 0
                                    ? (records[index].itemPrice +
                                              delta *
                                                  (records[index].itemPrice /
                                                      totalOriginal))
                                          .toStringAsFixed(2)
                                    : "-",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
