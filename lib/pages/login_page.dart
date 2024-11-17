import 'package:flutter/material.dart';
import 'package:messages/components/my_button.dart';
import 'package:messages/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final void Function()? onTap;
   LoginPage({
    super.key,
    required this.onTap
    });

   void login() {
    // login function
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // icon
          Icon(Icons.lock_open_rounded, size: 60, color: Theme.of(context).colorScheme.primary),

          const SizedBox(height: 50),

          // welcome back , you've been missed
          Text('Welcome back, you\'ve been missed!',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
           ),
          ),

          const SizedBox(height: 25),

          // email textfield
          MyTextfield(
            hintText: "Enter email",
            obscureText: false,
            controller: _emailController,
            ),

          const SizedBox(height: 10),

          // password textfield
          MyTextfield(
            hintText: "Enter password",
            obscureText: true,
            controller: _pwController,
            ),

          const SizedBox(height: 25),

          // login button
          MyButton(
            text: "Login", 
            onTap: login
            ),

          const SizedBox(height: 25),

          // not a member? register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a member? ", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register now", 
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, 
                    fontWeight: FontWeight.bold),
                    )
                   ),
            ],
          ),
        ],
      ),
    );
  }
}