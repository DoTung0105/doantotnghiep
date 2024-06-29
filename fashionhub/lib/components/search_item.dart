import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class SuggestedProducts extends StatelessWidget {
  final Clother sugPro;
  final VoidCallback onTap;

  const SuggestedProducts({
    Key? key,
    required this.sugPro,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Image.network(
                  sugPro.imagePath,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2 - 10,
                  fit: BoxFit.cover,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    sugPro.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Positioned(
              width: 40,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 14,
                    ),
                    Text(
                      '${sugPro.evaluate}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistoryItem extends StatelessWidget {
  final String query;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const SearchHistoryItem({
    Key? key,
    required this.query,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        leading: Icon(Icons.history, color: Colors.grey),
        title: Text(
          query,
          style: TextStyle(fontSize: 17),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
