import 'package:flutter/material.dart';


class UserItemListWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String email;
  final VoidCallback? onTap;

  const UserItemListWidget({
    super.key,
    this.imageUrl = '',
    required this.name,
    required this.email,
    this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black26,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty ? const Icon(Icons.person, size: 30, color: Colors.white,) : null,
            ),
            const SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.name,),
                Text(this.email,),
              ],
            )
          ],
        ),
      ),
    );
  }
}