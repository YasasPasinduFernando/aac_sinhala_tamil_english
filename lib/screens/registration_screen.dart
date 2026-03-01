import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String _selectedGender = 'boy';
  String _selectedLang = 'en';

  String _t(String key) {
    const texts = {
      'si': {
        'write_name': 'ඔබේ නම ලියන්න',
        'name_hint': 'නම',
        'name_error': 'කරුණාකර නම ඇතුලත් කරන්න',
        'select_gender': 'ලිංගය තෝරන්න',
        'boy': 'පිරිමි',
        'girl': 'ගැහැණු',
        'start': 'ආරම්භ කරමු 🎉',
        'free_msg': '💙 මෙම app එක autism ළමයින් සඳහා නොමිලේ සපයයි',
        'select_lang': 'භාෂාව තෝරන්න',
      },
      'ta': {
        'write_name': 'உங்கள் பெயரை எழுதுங்கள்',
        'name_hint': 'பெயர்',
        'name_error': 'தயவுசெய்து பெயரை உள்ளிடவும்',
        'select_gender': 'பாலினத்தைத் தேர்ந்தெடுக்கவும்',
        'boy': 'ஆண்',
        'girl': 'பெண்',
        'start': 'தொடங்குவோம் 🎉',
        'free_msg': '💙 இந்த ஆப் ஆட்டிசம் குழந்தைகளுக்கு இலவசம்',
        'select_lang': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      },
      'en': {
        'write_name': 'Write your name',
        'name_hint': 'Name',
        'name_error': 'Please enter your name',
        'select_gender': 'Select gender',
        'boy': 'Boy',
        'girl': 'Girl',
        'start': 'Let\'s Start 🎉',
        'free_msg': '💙 This app is free for children with autism',
        'select_lang': 'Select language',
      },
    };
    return texts[_selectedLang]?[key] ?? texts['en']![key]!;
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await StorageService.saveUserData(
      name: _nameController.text,
      gender: _selectedGender,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Widget _buildLangButton(String code, String flag, String label) {
    final isSelected = _selectedLang == code;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedLang = code),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.white.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Text(flag, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue.shade700 : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF87CEEB),
              const Color(0xFFB8E0F6),
              const Color(0xFFFFB6C1),
              const Color(0xFFFFC0CB),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Language Selector
                  Text(
                    _t('select_lang'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildLangButton('si', '🇱🇰', 'සිංහල'),
                      const SizedBox(width: 10),
                      _buildLangButton('ta', '🔱', 'தமிழ்'),
                      const SizedBox(width: 10),
                      _buildLangButton('en', '🇬🇧', 'English'),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // App Logo
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('💬', style: TextStyle(fontSize: 55)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'AAC කථා කරමු',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 6),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'සිංහල • தமிழ் • English',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _t('write_name'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: _t('name_hint'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return _t('name_error');
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        Text(
                          _t('select_gender'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedGender = 'boy'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    gradient: _selectedGender == 'boy'
                                        ? const LinearGradient(
                                            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                                          )
                                        : null,
                                    color: _selectedGender == 'boy' ? null : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _selectedGender == 'boy'
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('👦', style: TextStyle(fontSize: 48)),
                                      const SizedBox(height: 8),
                                      Text(
                                        _t('boy'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedGender == 'boy'
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedGender = 'girl'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    gradient: _selectedGender == 'girl'
                                        ? const LinearGradient(
                                            colors: [Color(0xFFEC407A), Color(0xFFD81B60)],
                                          )
                                        : null,
                                    color: _selectedGender == 'girl' ? null : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _selectedGender == 'girl'
                                          ? Colors.pink
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('👧', style: TextStyle(fontSize: 48)),
                                      const SizedBox(height: 8),
                                      Text(
                                        _t('girl'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedGender == 'girl'
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            _t('start'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    _t('free_msg'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.5,
                      shadows: [
                        Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
