import 'package:flutter/material.dart';

class FilterDropdown extends StatefulWidget {
  /// Callback to update calling page's map of options to state
  final Function onFilterChange;

  /// Map each option (String) to its state (enable = true and disabled = false)
  final Map<String, bool> optionsMap;

  FilterDropdown({this.onFilterChange, this.optionsMap});

  _FilterDropdownState createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  Widget build(BuildContext context) {
    Widget optionTextLabel(String value) {
      return Flexible(
        child: Container(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              value,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Color(0xFFF9EBEB),
        border: Border.all(
            style: BorderStyle.solid, color: Color(0xFF6868F6), width: 2.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          dropdownColor: Color(0xFFF9EBEB),
          iconSize: 24,
          elevation: 16,
          hint: Text('Filter:'),
          onChanged: (test) {},
          items: widget.optionsMap.entries.map((e) {
            return DropdownMenuItem(
              child: Container(
                child: Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, _setState) => Checkbox(
                        onChanged: (bool value) {
                          _setState(() {
                            widget.onFilterChange(e.key);
                          });
                        },
                        value: widget.optionsMap[e.key],
                      ),
                    ),
                    optionTextLabel(e.key),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
