import 'package:flutter/material.dart';

class NoResultBanner extends StatelessWidget {
  final String searchTerm;
  final bool isNoResult;

  NoResultBanner(this.searchTerm, this.isNoResult);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 110,
      left: 20,
      right: 20,
      child: AnimatedOpacity(
        opacity: isNoResult ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFF9EBEB),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'No results found for: $searchTerm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
