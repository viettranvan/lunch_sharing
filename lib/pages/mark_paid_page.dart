import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/utils/utils.dart';
import 'package:lunch_sharing/widgets/index.dart';

class MarkPaidPage extends StatefulWidget {
  const MarkPaidPage({super.key});

  @override
  State<MarkPaidPage> createState() => _MarkPaidPageState();
}

class _MarkPaidPageState extends State<MarkPaidPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  @override
  void initState() {
    final queryParams = Uri.base.queryParameters;

    setState(() {
      startDate =
          DateFormat('dd-MM-yyyy').tryParse(queryParams['start_date'] ?? '') ??
          DateTime.now();
      endDate =
          DateFormat('dd-MM-yyyy').tryParse(queryParams['end_date'] ?? '') ??
          DateTime.now();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Paid'),
        actions: [
          InkWell(
            onTap: () {
              DateRangePicker.show(
                context,
                startDate: startDate,
                endDate: endDate,
                onRangeDateSelected: (start, end) {
                  setState(() {
                    startDate = start;
                    endDate = end;
                  });
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 5),
                  Text(
                    (startDate.difference(DateTime.now()).inDays == 0 &&
                            endDate.difference(DateTime.now()).inDays == 0)
                        ? "Select a range"
                        : '${startDate.jiffyFormatToString('dd/MM/yyyy')} - ${endDate.jiffyFormatToString('dd/MM/yyyy')}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: FutureBuilder(
        future: InvoiceService().fetchInvoices(),
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

          final invoices = snapshot.data!;

          return ListView.separated(
            itemCount: invoices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = invoices[index];
              return OrderedTableAction(
                date: formatFirebaseTimestamp(order.createdAt),
                storeName: order.storeName,
                paidAmount: order.paidAmount,
                ordered: order.orderers,
                markPaidCallback: (id) async {
                  EasyLoading.show();
                  final sts = await InvoiceService().markPaid(
                    invoiceId: order.id,
                    ordererId: id,
                  );
                  EasyLoading.dismiss();
                  if (sts) {
                    setState(() {});
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
