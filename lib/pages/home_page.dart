import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text(
              'Messages',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500
                ),
              ),
        ),
      ),
      drawer: MyDrawer(),

      body: Column(
        children: [

        ],
      ),
    );
  }
}