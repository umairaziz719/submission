import 'package:appcustom/views/homepage.dart';
import 'package:appcustom/views/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController et = TextEditingController();
  TextEditingController et1 = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(350))),
              child: Text(
                "Custom App",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: et,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.purple),
                  ),
                  label: Text("Username")),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: et1,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.purple)),
                  prefixIcon: Icon(Icons.lock),
                  label: Text("Password")),
            ),
            SizedBox(
              height: 40,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                try {
                  if (et1.text.length >= 6) {
                    await _auth.signInWithEmailAndPassword(
                        email: et.text, password: et1.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(
                                  email: et.text,
                                )));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    print(
                        "The email address is already in use by another account.");
                  }
                }
              },
              child: Text("Sign In"),
              color: Colors.purple,
              minWidth: 200,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                try {
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  final GoogleSignInAccount? googleSignInAccount =
                      await googleSignIn.signIn();
                  if (googleSignInAccount != null) {
                    final GoogleSignInAuthentication
                        googleSignInAuthentication =
                        await googleSignInAccount.authentication;
                    final AuthCredential authCredential =
                        GoogleAuthProvider.credential(
                            idToken: googleSignInAuthentication.idToken,
                            accessToken:
                                googleSignInAuthentication.accessToken);

                    // Getting users credential
                    UserCredential result =
                        await _auth.signInWithCredential(authCredential);
                    User? user = result.user;
                    print("helloo");
                    if (result != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    email: result.user!.email,
                                  )));
                    } // if result not null we simply call the MaterialpageRoute,
                    // for go to the HomePage screen
                  }
                } catch (error) {
                  print(error);
                }
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => HomePage()));
              },
              child: Text("Sign In with google"),
              color: Colors.purple,
              minWidth: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Forget your Password"),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(400))),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignUp()));
                },
                child: Text(
                  "SignUp",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
