import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Row(
          children: [
            Icon(Icons.person_rounded),
            Text(text),
          ],
        ),
      ),
    );
  }
}