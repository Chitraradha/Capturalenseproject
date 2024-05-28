import 'package:flutter/material.dart';

void main() => runApp(DatePickerApp());

class DatePickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DatePickerExample(),
    );
  }
}

class DatePickerExample extends StatefulWidget {
  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2021, 7, 25);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: OutlinedButton(
              onPressed: () => _selectDate(context),
              child: Text('Open Date Picker'),
            ),
          ),
        ],
      ),
    );
  }
}
