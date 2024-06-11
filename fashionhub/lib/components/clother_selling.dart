import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class CloSelling extends StatefulWidget {
  final Clother cloSel;
  const CloSelling({super.key, required this.cloSel});

  @override
  _CloSellingState createState() => _CloSellingState();
}

class _CloSellingState extends State<CloSelling> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    // Kiểm tra và cắt đoạn mô tả nếu vượt quá 140 ký tự
    String description = widget.cloSel.description.length > 150
        ? widget.cloSel.description.substring(0, 150) + '...'
        : widget.cloSel.description;

    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 8.0),
        width: 300.0,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(widget.cloSel.imagePath),
            ),

            // Description
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                description,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: Container(),
            ),

            // Price + Name
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Container(
                        width: 250,
                        child: Text(
                          widget.cloSel.name.length > 25
                              ? widget.cloSel.name.substring(0, 25) + '...'
                              : widget.cloSel.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.cloSel.price + '\₫',
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 36,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(124, 223, 205, 198),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[800],
                                  size: 13,
                                ),
                                Text(
                                  widget.cloSel.evaluate.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                  // Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red[500] : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
