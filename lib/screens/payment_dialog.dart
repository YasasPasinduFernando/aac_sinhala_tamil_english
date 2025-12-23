import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ගෙවීම තෝරන්න'),
      content: SingleChildScrollView(
        child: Column(
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.volunteer_activism, color: Colors.red),
              title: const Text('Donation කරන්න'),
              subtitle: const Text('ඕනෑම මුදලක්'),
              onTap: () {
                Navigator.of(context).pop();
                _showDonationDialog(context);
              },
            ),
          ],
        ),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$provider ගෙවීම'),
        content: Text(
            'කරුණාකර ඔබේ දුරකතනයෙන් SMS එකක් යවන්න:\n\nAAC REG යවන්න 77123 ට\n\nදවසකට රු. 5 අය කරනු ලැබේ'),
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

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DonationDialog(),
    );
  }
}

class DonationDialog extends StatelessWidget {
  const DonationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.volunteer_activism, color: Colors.red),
          SizedBox(width: 8),
          Text('💝 Donation Details'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ස්තූතියි! ඔබේ දායකත්වය ළමයින්ට උදව් කරයි.',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.account_balance, 'Bank', 'Bank of Ceylon'),
            _buildDetailRow(Icons.business, 'Branch', 'Negombo'),
            _buildDetailRow(Icons.numbers, 'Account No', '87654321'),
            _buildDetailRow(
                Icons.person, 'Account Name', 'AAC Lanka Foundation'),
            const Divider(height: 24),
            _buildDetailRow(Icons.phone_android, 'eZ Cash', '0771234567'),
            _buildDetailRow(Icons.phone_android, 'mCash', '0771234567'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💙 ඔබේ සෑම දායකත්වයක්ම ළමයින්ට නොමිලේ මෙම app එක භාවිතා කිරීමට උදව් කරයි!',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Copy to clipboard
            Clipboard.setData(const ClipboardData(
                text:
                    'Bank: Bank of Ceylon\nBranch: Negombo\nAccount: 87654321\nName: AAC Lanka Foundation'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            );
          },
          child: const Text('Copy Details'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(true);
          },
          child: const Text('හරි'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
