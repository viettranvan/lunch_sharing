import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/pages/mark_paid/bloc/mark_paid_bloc.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/utils/utils.dart';
import 'package:lunch_sharing/widgets/index.dart';

class MarkPaidPage extends StatefulWidget {
  const MarkPaidPage({super.key});

  @override
  State<MarkPaidPage> createState() => _MarkPaidPageState();
}

class _MarkPaidPageState extends State<MarkPaidPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MarkPaidBloc(invoiceService: InvoiceService())..add(FetchInvoices()),
      child: BlocConsumer<MarkPaidBloc, MarkPaidState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();

          if (state.errorMessage.isNotEmpty) {
            EasyLoading.showError(state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Mark Paid'),
              actions: [
                InkWell(
                  onTap: () {
                    DateRangePicker.show(
                      context,
                      startDate: state.startDate,
                      endDate: state.endDate,
                      onRangeDateSelected: (start, end) {
                        context.read<MarkPaidBloc>().add(
                          OnChangeRangeDate(startDate: start, endDate: end),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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
                          (state.startDate.difference(DateTime.now()).inDays ==
                                      0 &&
                                  state.endDate
                                          .difference(DateTime.now())
                                          .inDays ==
                                      0)
                              ? "Select a range"
                              : '${state.startDate.jiffyFormatToString('dd/MM/yyyy')} - ${state.endDate.jiffyFormatToString('dd/MM/yyyy')}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            body: ListView.separated(
              itemCount: state.invoices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = state.invoices[index];
                return OrderedTableAction(
                  date: formatFirebaseTimestamp(order.createdAt),
                  storeName: order.storeName,
                  paidAmount: order.paidAmount,
                  ordered: order.orderers,
                  markPaidCallback: (id) async {
                    context.read<MarkPaidBloc>().add(
                      MarkUserAsPaid(invoiceId: order.id, ordererId: id),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
