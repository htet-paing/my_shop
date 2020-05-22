import 'package:flutter/material.dart';
import 'package:my_shop/auth/authentication.dart';

class LoginSignupScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginSignupScreen({this.auth, this.loginCallback});
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {

  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

   bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in : $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed Up : $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length >0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      }catch (e) {
        print('Error $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
  @override
  void initState() { 
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }
  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage()
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if(_isLoading) {
      return Center(child: CircularProgressIndicator(),);
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Icon(Icons.shop),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.mail,
          color: Colors.grey,)
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock,
          color: Colors.grey,)
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Colors.pink,
          child: Text(_isLoginForm ? 'Login' : 'Create account',
          style: TextStyle(fontSize: 20,color: Colors.white,),
        ),
        onPressed: validateAndSubmit,
      ),
    ));
  }

  Widget showSecondaryButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),
      ),
      onPressed: toggleFormMode,
    );
  }
  

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13,
          color: Colors.red,
          height: 1,
          fontWeight: FontWeight.w300
        ),
      );
    }else {
      return Container(
        height: 0,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }  
}