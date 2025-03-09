import 'package:flutter/material.dart';


class BulletList extends StatelessWidget {
  final List<String> items;

  BulletList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• ", style: TextStyle(fontSize: 20)), // Bullet point
            Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)), // Text
          ],
        );
      }).toList(),
    );
  }
}