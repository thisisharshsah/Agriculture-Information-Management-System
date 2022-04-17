import 'package:aims/screens/login_page.dart';
import 'package:aims/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'First Name',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Your First Name';
        } else if (value.length < 3) {
          return 'Please Enter Your First Name(Atleast 3 Characters)';
        }
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Please Enter a valid First Name';
        }
        return null;
      },
      onSaved: (value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'Second Name',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Your Second Name';
        } else if (value.length < 3) {
          return 'Please Enter Your Second Name(At least 3 characters)';
        }
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Please Enter a valid Second Name';
        }
        return null;
      },
      onSaved: (value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        hintText: 'Email',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Your Email';
        } else if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$')
            .hasMatch(value)) {
          return 'Please Enter a valid Email';
        }
        return null;
      },
      onSaved: (value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        hintText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Your Password';
        } else if (value.length < 6) {
          return 'Please Enter Your Password(Atleast 6 characters)';
        }
        return null;
      },
      onSaved: (value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        hintText: 'Confirm Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Your Confirm Password';
        } else if (value.length < 6) {
          return 'Please Enter Your Confirm Password(Atleast 6 characters)';
        } else if (value != passwordEditingController.text) {
          return 'Password does not match';
        }
        return null;
      },
      onSaved: (value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
    );

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightGreenAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black, fontSize: 15.0),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 250.0,
                          child: Image.asset(
                            "assets/black_logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        firstNameField,
                        const SizedBox(
                          height: 20,
                        ),
                        secondNameField,
                        const SizedBox(
                          height: 20,
                        ),
                        emailField,
                        const SizedBox(
                          height: 20,
                        ),
                        passwordField,
                        const SizedBox(
                          height: 20,
                        ),
                        confirmPasswordField,
                        const SizedBox(
                          height: 20,
                        ),
                        signUpButton,
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((error) {
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebasefirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(
        msg: "Account Created Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }
}
