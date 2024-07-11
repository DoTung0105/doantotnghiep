import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClotherTile extends StatelessWidget {
  final Clother cloTil;

  const ClotherTile({Key? key, required this.cloTil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatSold(int sold) {
      if (sold >= 1000) {
        double soldInK = sold / 1000;
        return soldInK.toStringAsFixed(1) + 'K';
      } else {
        return sold.toString();
      }
    }

    return ChangeNotifierProvider.value(
      value: cloTil,
      child: Consumer<Clother>(
        builder: (context, clother, child) {
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
                      child: Image.network(
                        clother.imagePath,
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
                  clother.name.length > 18
                      ? clother.name.substring(0, 18) + '...'
                      : clother.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 3),

                Container(
                  width: 44,
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(124, 223, 205, 198),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow[800],
                        size: 11,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        clother.evaluate.toString(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceWidget(
                      price: clother.price,
                      style: TextStyle(color: Colors.red, fontSize: 17),
                    ),
                    Text('Đã bán: ' + formatSold(clother.sold)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
