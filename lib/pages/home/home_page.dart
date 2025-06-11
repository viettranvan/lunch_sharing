// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/pages/home/bloc/home_bloc.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/utils/utils.dart';
import 'package:lunch_sharing/widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(invoiceService: InvoiceService())..add(FetchInvoices()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lunch Sharing'),

          actions: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return InkWell(
                  onTap: () {
                    DateRangePicker.show(
                      context,
                      startDate: state.startDate,
                      endDate: state.endDate,
                      onRangeDateSelected: (start, end) {
                        context.read<HomeBloc>().add(
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
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();

            if (state.errorMessage.isNotEmpty) {
              EasyLoading.showError(state.errorMessage);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                OrderedOverview(invoices: state.invoices),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: DashedLine(thickness: 2),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.invoices.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = state.invoices[index];
                      return OrderedTable(
                        date: formatFirebaseTimestamp(order.createdAt),
                        storeName: order.storeName,
                        paidAmount: order.paidAmount,
                        ordered: order.orderers,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
