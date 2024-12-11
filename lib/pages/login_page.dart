import 'package:flutter/material.dart';
import 'package:messages/components/my_button.dart';
import 'package:messages/components/my_textfield.dart';
import 'package:messages/services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final void Function()? onTap;
   LoginPage({
    super.key,
    required this.onTap
    });

   void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailPassword(_emailController.text, _pwController.text);
    }

    // catch errors
    catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),
    );
   }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 175),
            child: Column(
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
            
                const SizedBox(height: 25),
            
                // login button
                Container(
                  width: currentWidth > 600 ? 400 : null,
                  child: MyButton(
                    text: "Login", 
                    onTap: () => login(context),
                    ),
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
          ),
        ),
      ),
    );
  }
}