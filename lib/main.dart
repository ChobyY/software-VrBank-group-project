import 'package:flutter/material.dart';
import 'dart:async';
import 'account_manager.dart';
import 'storage.dart';

void main() {
  runApp(MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      await Storage.writeAll([{'username': username, 'password': password, 'balance': 0.0, 'transactions': []}]);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(username: username)));
    } else {
      print('Username and password cannot be empty');
    }
  }

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    List<dynamic> accounts = await Storage.read();
    bool validLogin = accounts.any((account) => account['username'] == username && account['password'] == password);
    if (validLogin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(username: username)));
    } else {
      print('Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login or Register')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: _register, child: Text('Register')),
            ElevatedButton(onPressed: _login, child: Text('Login'))
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final String username;

  MyApp({required this.username});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AccountManager accountManager;

  @override
  void initState() {
    super.initState();
    accountManager = AccountManager(username: widget.username);
    accountManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${widget.username}')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Balance: \$${accountManager.balance.toStringAsFixed(2)}'),
            TextField(
              onSubmitted: (value) {
                double amount = double.parse(value);
                accountManager.deposit(amount);
                setState(() {});
              },
              decoration: InputDecoration(labelText: 'Enter amount to deposit'),
            ),
            TextField(
              onSubmitted: (value) {
                double amount = double.parse(value);
                accountManager.withdraw(amount);
                setState(() {});
              },
              decoration: InputDecoration(labelText: 'Enter amount to withdraw'),
            ),
            Text('Transactions:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: accountManager.transactions.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(accountManager.transactions[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
