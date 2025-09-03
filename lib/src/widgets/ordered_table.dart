// import 'package:flutter/material.dart';
// import 'package:lunch_sharing/src/models/api_models.dart';

// class OrderedTable extends StatelessWidget {
//   const OrderedTable({
//     super.key,
//     required this.date,
//     required this.storeName,
//     required this.paidAmount,
//     required this.ordered,
//     this.markPaidCallback,
//     this.deleteCallback,
//   });

//   final String date;
//   final String storeName;
//   final double paidAmount;
//   final List<ApiOrderer> ordered;
//   final Function(int)? markPaidCallback;
//   final VoidCallback? deleteCallback;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Wrap(
//           crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             Text(
//               '$date - $storeName',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(width: 10),
//             const SizedBox(width: 10),
//             RichText(
//               text: TextSpan(
//                 text: 'Tổng tiền: ',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: paidAmount.toString(),
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) {
//                     return AlertDialog(
//                       content:
//                           Text('Bạn có chắc chắn muốn xóa hóa đơn này không?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('Hủy'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             deleteCallback?.call();
//                           },
//                           child: Text('Xóa'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: Icon(Icons.delete_forever),
//             ),
//             const SizedBox(width: 10),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Table(
//           border: TableBorder.all(),
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           columnWidths: {
//             0: const FlexColumnWidth(1.5),
//             1: const FlexColumnWidth(),
//             2: const FlexColumnWidth(),
//             3: const FlexColumnWidth(),
//             4: const FlexColumnWidth(),
//             5: const FlexColumnWidth(),
//           },
//           children: [
//                 TableRow(
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withValues(alpha: 0.7),
//                   ),
//                   children: [
//                     Text(
//                       'Name',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         height: 2.5,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Original Price',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         height: 2.5,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Percentage',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         height: 2.5,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Actual Price',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         height: 2.5,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Status',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         height: 2.5,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Action',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         height: 2.5,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ] +
//               List.generate(ordered.length + 1, (index) {
//                 if (index == ordered.length) {
//                   return TableRow(
//                     children: [
//                       const SizedBox(),
//                       Text(
//                         'Total: ${ordered.fold(0.0, (sum, item) => sum + item.itemPrice)}',
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         '100%',
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         'Total: ${ordered.fold(0.0, (sum, item) => sum + item.actualPrice).toStringAsFixed(2)}',
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(),
//                     ],
//                   );
//                 }

//                 return TableRow(
//                   children: [
//                     // * Name
//                     Text(
//                       ordered[index].user.name,
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // * Original Price
//                     Text(
//                       ordered[index].itemPrice.toString(),
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // * Percentage
//                     Text(
//                       '${(ordered[index].percentage * 100).toStringAsFixed(2)}%',
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // * Actual Price
//                     Text(
//                       ordered[index].actualPrice.toStringAsFixed(2),
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     //* Status
//                     ordered[index].isPaid
//                         ? Icon(Icons.check_circle, color: Colors.green)
//                         : Icon(Icons.cancel_outlined, color: Colors.red),

//                     //* Action
//                     Visibility(
//                       visible: !ordered[index].isPaid,
//                       child: InkWell(
//                         onTap: () => markPaidCallback?.call(ordered[index].id),
//                         child: Text(
//                           'Mark as Paid',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             height: 2,
//                             fontSize: 16,
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:lunch_sharing/src/models/api_models.dart';

class OrderedTable extends StatelessWidget {
  const OrderedTable({
    super.key,
    required this.date,
    required this.storeName,
    required this.paidAmount,
    required this.ordered,
    this.markPaidCallback,
    this.deleteCallback,
  });

  final String date;
  final String storeName;
  final double paidAmount;
  final List<ApiOrderer> ordered;
  final Function(int)? markPaidCallback;
  final VoidCallback? deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '$date - $storeName',
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
                    text: paidAmount.toString(),
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
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content:
                          Text('Bạn có chắc chắn muốn xóa hóa đơn này không?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            deleteCallback?.call();
                          },
                          child: Text('Xóa'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete_forever),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: const FlexColumnWidth(1.5),
            1: const FlexColumnWidth(),
            2: const FlexColumnWidth(),
            3: const FlexColumnWidth(),
            4: const FlexColumnWidth(),
            5: const FlexColumnWidth(),
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
                    Text(
                      'Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 2.5,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Action',
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
              List.generate(ordered.length, (index) {
                return TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.grey.withValues(alpha: 0.1)
                        : null,
                  ),
                  children: [
                    // * Name
                    Text(
                      ordered[index].user.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 2),
                    ),
                    // * Original Price
                    Text(
                      ordered[index].itemPrice.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // * Percentage
                    Text(
                      '${(ordered[index].percentage * 100).toStringAsFixed(2)}%',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // * Actual Price
                    Text(
                      ordered[index].actualPrice.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ordered[index].isPaid
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel_outlined, color: Colors.red),
                    Visibility(
                      visible: !ordered[index].isPaid,
                      child: InkWell(
                        onTap: () => markPaidCallback?.call(ordered[index].id),
                        child: Text(
                          'Mark as Paid',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 2,
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
