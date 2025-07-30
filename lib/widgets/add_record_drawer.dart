import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/models/index.dart';
import 'package:uuid/uuid.dart';

class AddRecordDrawer extends StatefulWidget {
  const AddRecordDrawer({super.key, this.onConfirm, required this.users});
  final List<String> users;

  final Function(List<Orderers>)? onConfirm;
  @override
  State<AddRecordDrawer> createState() => _AddRecordDrawerState();
}

class _AddRecordDrawerState extends State<AddRecordDrawer> {
  late final List<Orderers> orderers;
  List<Orderers> selected = [];

  @override
  void initState() {
    orderers =
        widget.users.map((e) => Orderers(id: Uuid().v4(), name: e)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Text(
          'Select Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          children: orderers.map((e) {
            return InkWell(
              onTap: () {
                setState(() {
                  if (selected.contains(e)) {
                    selected.remove(e);
                  } else {
                    selected.add(e);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: selected.any((item) => item.name == e.name)
                      ? Colors.blue.withValues(alpha: 0.7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Text(e.name),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selected.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      '${selected[index].name}:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        double result = _calculateExpression(value);

                        selected[index] = selected[index].copyWith(
                          itemPrice: result,
                        );
                      });
                    },
                    inputFormatters: <TextInputFormatter>[
                      _MathExpressionFormatter(),
                    ],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  onPressed: () {
                    setState(() {
                      if (selected.contains(selected[index])) {
                        selected.remove(selected[index]);
                      } else {
                        selected.add(selected[index]);
                      }
                    });
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: selected.isNotEmpty,
          child: Text(
            "Total: ${selected.fold(0.0, (sum, item) => sum + item.itemPrice).toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        Visibility(
          visible: selected.isNotEmpty,
          child: InkWell(
            onTap: () {
              bool isAnyEmpty = selected.any((e) => e.itemPrice == 0);
              if (isAnyEmpty) {
                EasyLoading.showError('Please fill all fields');

                return;
              }

              final total = selected.fold(
                0.0,
                (sum, item) => sum + item.itemPrice,
              );
              selected = selected
                  .map((e) => e.copyWith(percentage: (e.itemPrice / total)))
                  .toList();

              Navigator.of(context).pop();
              widget.onConfirm?.call(selected);
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.lightBlueAccent,
              ),
              constraints: BoxConstraints(maxWidth: 200),
              child: Center(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateExpression(String expression) {
    if (expression.isEmpty) return 0.0;

    // Remove trailing operator if exists
    String cleanExpression = expression;
    if (cleanExpression.endsWith('+') ||
        cleanExpression.endsWith('-') ||
        cleanExpression.endsWith('*') ||
        cleanExpression.endsWith('/')) {
      cleanExpression =
          cleanExpression.substring(0, cleanExpression.length - 1);
    }

    if (cleanExpression.isEmpty) return 0.0;

    try {
      // Parse the expression with proper operator precedence
      return _parseExpression(cleanExpression);
    } catch (e) {
      return 0.0;
    }
  }

  double _parseExpression(String expression) {
    // First, handle addition and subtraction (lowest precedence)
    List<String> addSubTokens = _splitByOperators(expression, ['+', '-']);

    if (addSubTokens.length == 1) {
      // No addition/subtraction, handle multiplication/division
      return _parseMultiplyDivide(addSubTokens[0]);
    }

    double result = _parseMultiplyDivide(addSubTokens[0]);

    for (int i = 1; i < addSubTokens.length; i += 2) {
      if (i + 1 < addSubTokens.length) {
        String operator = addSubTokens[i];
        double operand = _parseMultiplyDivide(addSubTokens[i + 1]);

        if (operator == '+') {
          result += operand;
        } else if (operator == '-') {
          result -= operand;
        }
      }
    }

    return result;
  }

  double _parseMultiplyDivide(String expression) {
    // Handle multiplication and division (higher precedence)
    List<String> mulDivTokens = _splitByOperators(expression, ['*', '/']);

    if (mulDivTokens.length == 1) {
      // No multiplication/division, just parse the number
      return double.tryParse(mulDivTokens[0]) ?? 0.0;
    }

    double result = double.tryParse(mulDivTokens[0]) ?? 0.0;

    for (int i = 1; i < mulDivTokens.length; i += 2) {
      if (i + 1 < mulDivTokens.length) {
        String operator = mulDivTokens[i];
        double operand = double.tryParse(mulDivTokens[i + 1]) ?? 0.0;

        if (operator == '*') {
          result *= operand;
        } else if (operator == '/') {
          if (operand != 0) {
            result /= operand;
          } else {
            return 0.0; // Division by zero
          }
        }
      }
    }

    return result;
  }

  List<String> _splitByOperators(String expression, List<String> operators) {
    List<String> tokens = [];
    String currentToken = '';
    bool isFirstCharacter = true;

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (operators.contains(char)) {
        // Check if this is a negative sign at the beginning
        if (isFirstCharacter && char == '-') {
          currentToken += char; // Add minus to the number
        } else {
          // Add current token and operator
          if (currentToken.isNotEmpty) {
            tokens.add(currentToken);
            currentToken = '';
          }
          tokens.add(char);
        }
      } else {
        currentToken += char;
      }
      isFirstCharacter = false;
    }

    // Add the last token
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    return tokens;
  }
}

class _MathExpressionFormatter extends TextInputFormatter {
  final RegExp _validPattern = RegExp(r'^-?(\d+\.?\d*[\+\-\*\/])*\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If empty or matches the pattern, allow it
    if (newValue.text.isEmpty || _validPattern.hasMatch(newValue.text)) {
      // Additional check to prevent consecutive operators (but allow negative at start)
      if (_hasConsecutiveOperators(newValue.text)) {
        return oldValue;
      }
      return newValue;
    }

    // If the new value doesn't match, keep the old value
    return oldValue;
  }

  bool _hasConsecutiveOperators(String text) {
    // Check for consecutive operators like ++, --, +-, -+, **, //, etc.
    // But allow negative sign at the beginning
    if (text.startsWith('-')) {
      // Check for consecutive operators after the first character
      String remaining = text.substring(1);
      return RegExp(r'[\+\-\*\/]{2,}').hasMatch(remaining);
    }
    return RegExp(r'[\+\-\*\/]{2,}').hasMatch(text);
  }
}
