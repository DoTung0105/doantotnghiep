import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class CloSelling extends StatelessWidget {
  final Clother cloSel;

  const CloSelling({Key? key, required this.cloSel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String description = cloSel.description.length > 160
        ? cloSel.description.substring(0, 160) + '...'
        : cloSel.description;

    return Container(
      margin: EdgeInsets.only(left: 8.0),
      width: 300.0,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(cloSel.imagePath),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                description,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 130,
                            child: Text(
                              cloSel.name.length > 25
                                  ? cloSel.name.substring(0, 25) + '...'
                                  : cloSel.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
                                  cloSel.evaluate.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      //const SizedBox(height: 5),
                      PriceWidget(
                          price: cloSel.price,
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                    ],
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
