import 'package:flutter/material.dart';
import 'package:messages/components/my_button.dart';
import 'package:messages/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final void Function()? onTap;
   RegisterPage({
    super.key,
    required this.onTap
    });

   void register() {
    // register function
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // icon
          Icon(Icons.lock_rounded, size: 60, color: Theme.of(context).colorScheme.primary),

          const SizedBox(height: 50),

          // Oh a new face
          Text('Oh a new face!',
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

          const SizedBox(height: 10),

            // confirm password textfield
          MyTextfield(
            hintText: "Confirm password", 
            obscureText: true,
            controller: _confirmPwController,
            ),

          const SizedBox(height: 25),

          // login button
          MyButton(
            text: "Register", 
            onTap: register
            ),

          const SizedBox(height: 25),

          // not a member? register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already a member? ", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login here", 
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, 
                    fontWeight: FontWeight.bold),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}