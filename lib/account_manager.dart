import 'storage.dart';

class AccountManager {
  String username;
  double balance;
  List<String> transactions;

  AccountManager({required this.username, this.balance = 0.0, List<String>? transactions})
      : this.transactions = transactions ?? [];

  Future<void> init() async {
    List<dynamic> accounts = await Storage.read();
    var accountData = accounts.firstWhere(
            (account) => account['username'] == username,
        orElse: () => null
    );
    if (accountData != null) {
      balance = accountData['balance'];
      transactions = List<String>.from(accountData['transactions']);
    } else {
      balance = 0.0;
      transactions = [];
      await updateStorage();
    }
  }

  Future<void> deposit(double amount) async {
    balance += amount;
    transactions.add('Deposit: \$${amount.toStringAsFixed(2)}');
    await updateStorage();
  }

  Future<void> withdraw(double amount) async {
    if (amount > balance) {
      print('Insufficient funds');
      return;
    }
    balance -= amount;
    transactions.add('Withdraw: \$${amount.toStringAsFixed(2)}');
    await updateStorage();
  }

  Future<void> updateStorage() async {
    Map<String, dynamic> accountData = {
      'username': username,
      'balance': balance,
      'transactions': transactions
    };

    List<dynamic> allAccounts = await Storage.read();
    int index = allAccounts.indexWhere((acc) => acc['username'] == username);
    if (index != -1) {
      allAccounts[index] = accountData;
    } else {
      allAccounts.add(accountData);
    }

    await Storage.writeAll(allAccounts);
  }
}
