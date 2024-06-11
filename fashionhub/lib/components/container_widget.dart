import 'package:flutter/material.dart';

class BranchRangeContainer extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const BranchRangeContainer({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _BranchRangeContainerState createState() => _BranchRangeContainerState();
}

class _BranchRangeContainerState extends State<BranchRangeContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 170,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: widget.isSelected
              ? Border.all(
                  color: Color.fromARGB(235, 235, 85, 20),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
