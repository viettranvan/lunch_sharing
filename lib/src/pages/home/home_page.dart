// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/src/common/network/index.dart';
import 'package:lunch_sharing/src/pages/home/bloc/home_bloc.dart';
import 'package:lunch_sharing/src/pages/home/bloc/home_repository.dart';
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
          HomeBloc(homeRepository: HomeRepository(client: DioClient()))
            ..add(FetchInvoices()),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Show paid invoices',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            value: state.showPaidInvoices,
                            onChanged: (value) {
                              context.read<HomeBloc>().add(
                                    ToggleShowPaidInvoices(),
                                  );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Container(
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
                              (state.startDate == null && state.endDate == null)
                                  ? "Select a range"
                                  : '${state.startDate!.jiffyFormatToString('dd/MM/yyyy')} - ${state.endDate!.jiffyFormatToString('dd/MM/yyyy')}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            state.startDate != null && state.endDate != null,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: IconButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(const ClearFilter());
                            },
                            icon: Icon(Icons.filter_alt_off_sharp),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
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
            final listData = state.showPaidInvoices
                ? state.apiInvoices
                : state.apiInvoices
                    .where(
                        (e) => e.orderers.any((order) => order.isPaid == false))
                    .toList();
            return Column(
              children: [
                OrderedOverview(invoices: state.apiInvoices),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: DashedLine(thickness: 2),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 30),
                    itemCount: listData.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = listData[index];
                      return OrderedTable(
                        date: formatDateTime(order.createdAt),
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
