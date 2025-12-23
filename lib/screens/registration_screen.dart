import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../services/payment_service.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const RegistrationScreen({Key? key, required this.onThemeChanged})
      : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _needsFreeAccess = false;
  bool _isLoading = false;

  Future<void> _handleFreeRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await StorageService.saveUserData(
      name: _nameController.text,
      phone: _phoneController.text,
      isPremium: true,
    );

    if (mounted) {
      _showSuccessDialog('ස්තූතියි!',
          'ඔබට නොමිලේ ප්‍රවේශය ලැබී ඇත. අපි ළමයින් වෙනුවෙන් මෙම සේවාව සපයයි.');
    }
  }

  Future<void> _handlePaidRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const PaymentDialog(),
    );

    if (result == true) {
      await StorageService.saveUserData(
        name: _nameController.text,
        phone: _phoneController.text,
        isPremium: true,
      );

      if (mounted) {
        _showSuccessDialog('ස්තූතියි!',
            'ඔබේ දායකත්වය අගය කරනවා! දැන් ඔබට ads නොමැතිව භාවිතා කළ හැක.');
      }
    }

    setState(() => _isLoading = false);
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(onThemeChanged: widget.onThemeChanged),
                ),
              );
            },
            child: const Text('ආරම්භ කරමු'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ලියාපදිංචි වන්න'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.favorite, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              const Text('ළමයින් වෙනුවෙන්',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('මෙම app එක autism ළමයින් සඳහා නොමිලේ සපයයි',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'නම',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                validator: (value) => value == null || value.isEmpty
                    ? 'කරුණාකර නම ඇතුලත් කරන්න'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'දුරකථන අංකය',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'කරුණාකර දුරකථන අංකය ඇතුලත් කරන්න';
                  if (value.length != 10)
                    return 'වලංගු දුරකථන අංකයක් ඇතුලත් කරන්න';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CheckboxListTile(
                title: const Text(
                    'මට මුදල් ගෙවීමට නොහැකියි. නොමිලේ ප්‍රවේශය අවශ්‍යයි',
                    style: TextStyle(fontSize: 14)),
                subtitle: const Text('අපි සියළුම ළමයින්ට මෙම සේවාව සපයයි',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                value: _needsFreeAccess,
                onChanged: (value) =>
                    setState(() => _needsFreeAccess = value ?? false),
              ),
              const SizedBox(height: 24),
              if (_needsFreeAccess) ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleFreeRegistration,
                  icon: const Icon(Icons.check_circle),
                  label: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('නොමිලේ ලියාපදිංචි වන්න',
                          style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handlePaidRegistration,
                  icon: const Icon(Icons.payment),
                  label: const Text('රු. 5.00 ගෙවා දායක වන්න',
                      style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                    '✓ දවසකට රු. 5 පමණි\n✓ දැන්වීම් නැත\n✓ ළමයින්ට උදව් කරන්න',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
