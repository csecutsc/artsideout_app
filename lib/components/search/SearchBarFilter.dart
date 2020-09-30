import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/search/FilterDropdown.dart';

class SearchBarFilter extends StatefulWidget {
  final void Function(String text) handleTextChange;
  final void Function() handleTextClear;
  final void Function(String value) handleFilterChange;
  final Map<String, bool> optionsMap;

  SearchBarFilter(
      {this.handleTextChange,
      this.handleTextClear,
      this.handleFilterChange,
      this.optionsMap});

  _SearchBarFilterState createState() => _SearchBarFilterState();
}

class _SearchBarFilterState extends State<SearchBarFilter> {
  var isLoading = false;
  var searchQueryController = new TextEditingController();

  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: searchQueryController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                color: ColorConstants.PRIMARY,
                onPressed: () =>
                    widget.handleTextChange(searchQueryController.text),
              ),
              suffix: SizedBox(
                height: 22,
                width: 22,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(ColorConstants.PRIMARY),
                        backgroundColor: Colors.white,
                      )
                    : GestureDetector(
                        child: Icon(
                          Icons.close,
                          size: 22,
                        ),
                        onTap: () {
                          if (widget.handleTextClear != null)
                            widget.handleTextClear();
                          searchQueryController.clear();
                        },
                      ),
              ),
              hintText: "Search installations, activities, artists...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              hintStyle: TextStyle(color: Colors.black),
            ),
            style: Theme.of(context).textTheme.subtitle1,
            onEditingComplete: () async => [
              isLoading = true,
              await widget.handleTextChange(searchQueryController.text),
              isLoading = false
            ],
          ),
        Container(
          width: 130,
          child: FilterDropdown(
            onFilterChange: (String value) {
              setState(() {
                widget.handleFilterChange(value);
              });
            },
            optionsMap: widget.optionsMap,
          ),
        )
      ],
    );
  }
}
