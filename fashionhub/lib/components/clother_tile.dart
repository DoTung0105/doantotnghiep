import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class ClotherTile extends StatelessWidget {
  final Clother cloTil;
  const ClotherTile({Key? key, required this.cloTil});

  String formatSold(int sold) {
    if (sold >= 1000) {
      double soldInK = sold / 1000;
      return soldInK.toStringAsFixed(1) + 'K';
    } else {
      return sold.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cloTil.imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Name
          Text(
            cloTil.name.length > 18
                ? cloTil.name.substring(0, 18) + '...'
                : cloTil.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 3),

          Container(
            width: 44,
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(124, 223, 205, 198),
              border: Border.all(color: Colors.orange),
              // borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                  size: 13,
                ),
                const SizedBox(width: 2),
                Text(
                  cloTil.evaluate.toString(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                )
              ],
            ),
          ),

          const SizedBox(height: 3),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cloTil.price + '\₫',
                style: TextStyle(color: Colors.red, fontSize: 17),
              ),
              Text('Đã bán: ' + formatSold(cloTil.sold)),
            ],
          ),
        ],
      ),
    );
  }
}
