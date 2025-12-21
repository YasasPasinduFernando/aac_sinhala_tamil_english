import 'package:flutter/material.dart';

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ගෙවීම තෝරන්න'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone_android, color: Colors.orange),
            title: const Text('Dialog (දවසකට රු. 5)'),
            subtitle: const Text('SMS මගින් ගෙවන්න'),
            onTap: () => _handlePayment(context, 'Dialog'),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android, color: Colors.red),
            title: const Text('Mobitel (දවසකට රු. 5)'),
            subtitle: const Text('SMS මගින් ගෙවන්න'),
            onTap: () => _handlePayment(context, 'Mobitel'),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android, color: Colors.blue),
            title: const Text('Hutch (දවසකට රු. 5)'),
            subtitle: const Text('SMS මගින් ගෙවන්න'),
            onTap: () => _handlePayment(context, 'Hutch'),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android, color: Colors.green),
            title: const Text('Airtel (දවසකට රු. 5)'),
            subtitle: const Text('SMS මගින් ගෙවන්න'),
            onTap: () => _handlePayment(context, 'Airtel'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.volunteer_activism, color: Colors.red),
            title: const Text('Donation කරන්න'),
            subtitle: const Text('ඕනෑම මුදලක්'),
            onTap: () => _handleDonation(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('අවලංගු කරන්න'),
        ),
      ],
    );
  }

  void _handlePayment(BuildContext context, String provider) {
    // This would integrate with actual mobile payment gateway
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$provider ගෙවීම'),
        content: Text(
          'කරුණාකර ඔබේ දුරකතනයෙන් SMS එකක් යවන්න:\n\n'
          'AAC REG යවන්න 77123 ට\n\n'
          'දවසකට රු. 5 අය කරනු ලැබේ',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text('හරි'),
          ),
        ],
      ),
    );
  }

  void _handleDonation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💝 Donation'),
        content: const Text(
          'ස්තූතියි! ඔබේ දායකත්වය ළමයින්ට උදව් කරයි.\n\n'
          'Bank: Bank of Ceylon\n'
          'Account: 1234567890\n'
          'Name: AAC Lanka\n\n'
          'හෝ\n\n'
          'eZ Cash / mCash: 0771234567',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text('හරි'),
          ),
        ],
      ),
    );
  }
}
