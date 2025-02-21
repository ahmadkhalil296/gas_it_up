import 'package:flutter/material.dart';


class ServiceCard extends StatelessWidget {


  final String imageUrl;
  final String title;
  final String description;

  const ServiceCard({
  Key? key,
  required this.imageUrl,
  required this.title,
  required this.description,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width / 2 - 30, // Adjust based on needs
      height: 245,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage(imageUrl)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,

              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}