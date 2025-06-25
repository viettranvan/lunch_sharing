import 'package:flutter/material.dart';
import 'package:lunch_sharing/models/invoices.dart';
import 'package:lunch_sharing/models/orderer.dart';

class OrderedOverview extends StatefulWidget {
  const OrderedOverview({super.key, required this.invoices});
  final List<Invoices> invoices;

  @override
  State<OrderedOverview> createState() => _OrderedOverviewState();
}

class _OrderedOverviewState extends State<OrderedOverview> {
  List<String> users = [];

  @override
  void initState() {
    for (var element in widget.invoices) {
      for (var orderer in element.orderers) {
        if (!users.contains(orderer.name)) {
          users.add(orderer.name);
        }
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OrderedOverview oldWidget) {
    if (oldWidget.invoices != widget.invoices) {
      for (var element in widget.invoices) {
        for (var orderer in element.orderers) {
          if (!users.contains(orderer.name)) {
            users.add(orderer.name);
          }
        }
      }

      for (final user in List<String>.from(users)) {
        if (buildFinal(user, widget.invoices) == 0) {
          users.remove(user);
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  String buildSum(String userName, List<Invoices> invoices) {
    String result = '';

    for (final invoice in invoices) {
      Orderers orderer = invoice.orderers.firstWhere(
        (orderer) => orderer.name == userName,
        orElse: () => Orderers(
          id: '',
          actualPrice: 0.0,
          isPaid: false,
          name: userName,
          percentage: 0.0,
        ),
      );
      if (result.isEmpty && orderer.actualPrice > 0 && !orderer.isPaid) {
        result += orderer.actualPrice.toStringAsFixed(2);
      } else if (result.isNotEmpty &&
          orderer.actualPrice > 0 &&
          !orderer.isPaid) {
        result += ' + ${orderer.actualPrice.toStringAsFixed(2)}';
      }
    }

    return result;
  }

  double buildFinal(String userName, List<Invoices> invoices) {
    double result = 0;

    for (final invoice in invoices) {
      Orderers orderer = invoice.orderers.firstWhere(
        (orderer) => orderer.name == userName,
        orElse: () => Orderers(
          id: '',
          actualPrice: 0.0,
          isPaid: false,
          itemPrice: 0.0,
          name: userName,
          percentage: 0.0,
        ),
      );
      if (!orderer.isPaid) {
        result += orderer.actualPrice;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FlexColumnWidth(),
        1: const FlexColumnWidth(3),
        2: const FlexColumnWidth(),
      },
      children: List.generate(users.length, (index) {
        return TableRow(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.grey.withValues(alpha: 0.1) : null,
          ),
          children: [
            // * Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                users[index],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            // * Name
            Text(
              buildSum(users[index], widget.invoices),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            // * Name
            Text(
              buildFinal(users[index], widget.invoices).toStringAsFixed(2),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        );
      }),
    );
  }
}
