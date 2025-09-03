import 'package:flutter/material.dart';
import 'package:lunch_sharing/src/models/api_models.dart';

class OrderedTable extends StatelessWidget {
  const OrderedTable({
    super.key,
    required this.date,
    required this.storeName,
    required this.paidAmount,
    required this.ordered,
  });

  final String date;
  final String storeName;
  final double paidAmount;
  final List<ApiOrderer> ordered;

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
                  ],
                ),
              ] +
              List.generate(ordered.length + 1, (index) {
                if (index == ordered.length) {
                  return TableRow(
                    children: [
                      const SizedBox(),
                      Text(
                        'Total: ${ordered.fold(0.0, (sum, item) => sum + item.itemPrice)}',
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
                        'Total: ${ordered.fold(0.0, (sum, item) => sum + item.actualPrice).toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(),
                    ],
                  );
                }

                return TableRow(
                  children: [
                    // * Name
                    Text(
                      ordered[index].user.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                  ],
                );
              }),
        ),
      ],
    );
  }
}
