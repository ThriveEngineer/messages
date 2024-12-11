import 'package:flutter/material.dart';
import 'package:messages/components/my_button.dart';
import 'package:messages/components/my_textfield.dart';
import 'package:messages/services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final void Function()? onTap;
   RegisterPage({
    super.key,
    required this.onTap
    });

   void register(BuildContext context) {
    final _auth = AuthService();

    // passwords match create account
    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text, 
          _pwController.text
          );
      } catch (e) {
        showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),
    );
   }
  }

  // passwords do not match error
  else {
    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text('Passwords do not match'),
      ),
    );
  }
 }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 175),
          child: Column(
            children: [
          
              // icon
              Icon(Icons.lock_rounded, size: 60, color: Theme.of(context).colorScheme.primary),
          
              const SizedBox(height: 50),
          
              // Oh a new face
              Text('Oh, a new face!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
               ),
              ),
          
              const SizedBox(height: 25),
          
              // email textfield
              Container(
                width: currentWidth > 600 ? 400 : null,
                child: MyTextfield(
                  hintText: "Enter email",
                  obscureText: false,
                  controller: _emailController,
                  ),
              ),
          
              const SizedBox(height: 10),
          
              // password textfield
              Container(
                width: currentWidth > 600 ? 400 : null,
                child: MyTextfield(
                  hintText: "Enter password",
                  obscureText: true,
                  controller: _pwController,
                  ),
              ),
          
              const SizedBox(height: 10),
          
                // confirm password textfield
              Container(
                width: currentWidth > 600 ? 400 : null,
                child: MyTextfield(
                  hintText: "Confirm password", 
                  obscureText: true,
                  controller: _confirmPwController,
                  ),
              ),
          
              const SizedBox(height: 25),
          
              // login button
              Container(
                width: currentWidth > 600 ? 400 : null,
                child: MyButton(
                  text: "Register", 
                  onTap: () => register(context),
                  ),
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
        ),
      ),
    );
  }
}