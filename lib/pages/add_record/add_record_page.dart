import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/pages/add_record/bloc/add_record_bloc.dart';
import 'package:lunch_sharing/services/invoice_service.dart';
import 'package:lunch_sharing/services/user_order_service.dart';
import 'package:lunch_sharing/widgets/index.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddRecordBloc(
        invoiceService: InvoiceService(),
        userOrderService: UserOrderService(),
      )..add(FetchUsers()),
      child: BlocConsumer<AddRecordBloc, AddRecordState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if (state.errorMessage.isNotEmpty) {
            EasyLoading.showError(state.errorMessage);
          }
        },
        builder: (context, state) {
          final bloc = BlocProvider.of<AddRecordBloc>(context);
          return Scaffold(
            endDrawer: Drawer(
              width: 600,
              child: AddRecordDrawer(
                users: state.users,
                onConfirm: (value) {
                  bloc.add(UpdateStateValue(orderers: value));
                },
              ),
            ),
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('Add Invoice'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          content: AddUserDrawer(
                            onUserAddCallback: (userName) {
                              BlocProvider.of<AddRecordBloc>(
                                context,
                              ).add(AddNewUser(userName: userName));
                            },
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.group_add_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    bloc.add(AddNewRecord());
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
                    'Price Discrepancy: ${state.discrepancy}',
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
                          controller: bloc.nameController,
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
                          controller: bloc.amountController,
                          onChanged: (_) => bloc.add(
                            UpdateStateValue(orderers: state.orderers),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            // Allow only numbers and up to two decimal places and negative values
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^[+-]?\d*\.?\d{0,2}'),
                            ),
                          ],
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
                              bloc.add(UpdateStateValue(date: value));
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            state.date.jiffyFormatToString('EEE, dd/MM/yyyy'),
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
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
                              children:
                                  List.generate(state.orderers.length + 1, (
                                index,
                              ) {
                                if (index == state.orderers.length) {
                                  return TableRow(
                                    children: [
                                      const SizedBox(),
                                      Text(
                                        state.orderers.isEmpty
                                            ? 'No Records'
                                            : 'Total: ${state.orderers.fold(0.0, (sum, item) => sum + item.itemPrice).toStringAsFixed(2)}',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        state.orderers.isEmpty
                                            ? 'No Records'
                                            : '100%',
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
                                      state.orderers[index].name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // * Original Price
                                    Text(
                                      state.orderers[index].itemPrice
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // * Percentage
                                    Text(
                                      '${(state.orderers[index].percentage * 100).toStringAsFixed(2)}%',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // * Actual Price
                                    Text(
                                      state.orderers[index].actualPrice
                                          .toStringAsFixed(2),
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
        },
      ),
    );
  }
}
