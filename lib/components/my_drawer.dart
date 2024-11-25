import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(1.0),
      child: Column(
        children: [

          // Logo
          DrawerHeader(
            child: Image.asset(
              "assets/messages_logo.png", 
              width: 75, 
              height: 75,
              ),
            ),

            // home list tile
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text("H O M E"),
                leading: Icon(Icons.home),
                onTap: () {
                  // pop the drawer
                  Navigator.pop(context);
                },
              ),
            ),

            // settings list tile
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text("S E T T I N G S"),
                leading: Icon(Icons.settings_rounded),
                onTap: () {
                  // pop the drawer
                  Navigator.pop(context);

                  // navigate to settings page
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage()
                       ),
                      );
                },
              ),
            ),


            // logout list tile
        ],
      ),
    );
  }
}