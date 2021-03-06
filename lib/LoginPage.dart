import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> new _LoginPageState();
  }
  enum FormType{
    login,
    register
  }

  class _LoginPageState extends State<LoginPage>{
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    form.save();
    if (form.validate()){
      return true;
    }
    else{
      return false;
    }
  }

  void validateAndSubmit() async{
    if(validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in user: ${user.uid}');
        }
        else{
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered user: ${user.uid}');
        }
      }
      catch(e){
        print('error: $e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Hello'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.1),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  // creating separate widget
  List<Widget> buildInputs(){
    return[
      new TextFormField(
        decoration: new InputDecoration(labelText:'Email'),
        validator: (value) => value.isEmpty ? "Email can not be empty": null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText:'Password '),
        validator: (value) => value.isEmpty ? "Password can not be empty": null,
        onSaved: (value) => _password = value,
        obscureText: true,
      ),
    ];
  }

  // widgets buttons
  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login) {
      return [
        new RaisedButton(
            child: new Text('login', style: new TextStyle(fontSize: 20.0),),
            onPressed: validateAndSubmit
        ),
        new FlatButton(
          child: new Text(
            'Create an account', style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToRegister,
        )
      ];
    }else{
      return [
        new RaisedButton(
            child: new Text('Create an account', style: new TextStyle(fontSize: 20.0),),
            onPressed: validateAndSubmit
        ),
        new FlatButton(
          child: new Text(
            'Have an account ? login', style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}