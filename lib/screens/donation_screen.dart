// ==========================================
// FILE: lib/screens/donation_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';

class DonationScreen extends StatefulWidget {
  final String language;
  final bool isGirl;

  const DonationScreen({
    Key? key,
    required this.language,
    required this.isGirl,
  }) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadUserName();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Hide system navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('userName') ?? '';
    if (mounted) {
      setState(() => userName = savedName);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
    super.dispose();
  }

  String _getText(String key) {
    final texts = {
      'si-LK': {
        'title': 'දායකත්වය',
        'subtitle': 'ඔබේ සහයෝගය අගය කරනවා',
        'message':
            'ඔබේ කරුණාව මගින් අපි තවත් ළමයින්ට මෙම සේවාව නොමිලේ සැපයීමට හැකි වේ',
        'ez_cash': 'EZ Cash / mCash',
        'bank_transfer': 'බැංකු ගිණුම',
        'number': 'අංකය',
        'name': 'නම',
        'bank_name': 'බැංකුව',
        'account_number': 'ගිණුම් අංකය',
        'account_holder': 'ගිණුම් හිමිකරු',
        'branch': 'ශාඛාව',
        'copy': 'පිටපත් කරන්න',
        'copied': '✅ පිටපත් කරන ලදී!',
        'thank_you': 'ස්තූතියි',
        'thank_message': userName.isNotEmpty
            ? '$userName, ඔබේ දායකත්වය අපගේ ළමයින්ගේ අනාගතය වෙනස් කරයි! 💙'
            : 'ඔබේ දායකත්වය අපගේ ළමයින්ගේ අනාගතය වෙනස් කරයි! 💙',
        'next': 'ඊළඟ',
        'previous': 'පෙර',
        'done': 'හරි',
      },
      'ta-IN': {
        'title': 'நன்கொடை',
        'subtitle': 'உங்கள் ஆதரவு மதிக்கப்படுகிறது',
        'message':
            'உங்கள் தயவால் மேலும் குழந்தைகளுக்கு இந்த சேவையை இலவசமாக வழங்க முடியும்',
        'ez_cash': 'EZ Cash / mCash',
        'bank_transfer': 'வங்கி கணக்கு',
        'number': 'எண்',
        'name': 'பெயர்',
        'bank_name': 'வங்கி',
        'account_number': 'கணக்கு எண்',
        'account_holder': 'கணக்கு வைத்திருப்பவர்',
        'branch': 'கிளை',
        'copy': 'நகலெடுக்கவும்',
        'copied': '✅ நகலெடுக்கப்பட்டது!',
        'thank_you': 'நன்றி',
        'thank_message': userName.isNotEmpty
            ? '$userName, உங்கள் நன்கொடை எங்கள் குழந்தைகளின் எதிர்காலத்தை மாற்றுகிறது! 💙'
            : 'உங்கள் நன்கொடை எங்கள் குழந்தைகளின் எதிர்காலத்தை மாற்றுகிறது! 💙',
        'next': 'அடுத்து',
        'previous': 'முந்தைய',
        'done': 'சரி',
      },
      'en-GB': {
        'title': 'Donation',
        'subtitle': 'Your Support Matters',
        'message':
            'Your kindness helps us provide this service free to more children',
        'ez_cash': 'EZ Cash / mCash',
        'bank_transfer': 'Bank Account',
        'number': 'Number',
        'name': 'Name',
        'bank_name': 'Bank',
        'account_number': 'Account Number',
        'account_holder': 'Account Holder',
        'branch': 'Branch',
        'copy': 'Copy',
        'copied': '✅ Copied!',
        'thank_you': 'Thank You',
        'thank_message': userName.isNotEmpty
            ? '$userName, your donation changes our children\'s future! 💙'
            : 'Your donation changes our children\'s future! 💙',
        'next': 'Next',
        'previous': 'Previous',
        'done': 'Done',
      },
    };

    return texts[widget.language]?[key] ?? texts['en-GB']?[key] ?? key;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _getText('copied'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getThemeColors(widget.isGirl);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors['background']!,
              colors['accent']!.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              _buildTopBar(colors),

              // Page Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: [
                      _buildIntroPage(colors),
                      _buildEZCashPage(colors),
                      _buildBankPage(colors),
                      _buildThankYouPage(colors),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              _buildBottomNav(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(Map<String, Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Back/Home Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors['primary']!.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: colors['primary'],
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getText('title'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors['textColor'],
                  ),
                ),
                Text(
                  _getText('subtitle'),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors['textColor']!.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Page Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colors['primary']!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentPage + 1}/4',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(Map<String, Color> colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Heart Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors['primary']!.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Text('💝', style: TextStyle(fontSize: 80)),
            ),
          ),

          const SizedBox(height: 40),

          // Message
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _getText('message'),
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: colors['textColor'],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  '💙 🇱🇰 💙',
                  style: TextStyle(fontSize: 32),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Stats
          Row(
            children: [
              Expanded(child: _buildStatCard(colors, '1000+', 'ළමයින්', '🎯')),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(colors, '100%', 'නොමිලේ', '🎁')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      Map<String, Color> colors, String value, String label, String emoji) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors['primary']!, colors['accent']!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors['primary']!.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEZCashPage(Map<String, Color> colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors['primary']!, colors['accent']!],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📱', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Text(
                  _getText('ez_cash'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Payment Details
          _buildPaymentCard(
            colors,
            _getText('number'),
            '0776905654',
            '📞',
          ),

          const SizedBox(height: 16),

          _buildPaymentCard(
            colors,
            _getText('name'),
            'EKYP FERNANDO',
            '👤',
          ),

          const SizedBox(height: 30),

          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      'How to send:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors['textColor'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInstruction('1', 'Open eZ Cash / mCash app'),
                _buildInstruction('2', 'Select "Send Money"'),
                _buildInstruction('3', 'Enter number: 0776905654'),
                _buildInstruction('4', 'Enter any amount'),
                _buildInstruction('5', 'Complete transfer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankPage(Map<String, Color> colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors['primary']!, colors['accent']!],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏦', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Text(
                  _getText('bank_transfer'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Bank Details
          _buildPaymentCard(
            colors,
            _getText('bank_name'),
            'BOC',
            '🏦',
          ),

          const SizedBox(height: 16),

          _buildPaymentCard(
            colors,
            _getText('account_number'),
            '9604516',
            '🔢',
          ),

          const SizedBox(height: 16),

          _buildPaymentCard(
            colors,
            _getText('account_holder'),
            'EKYP FERNANDO',
            '👤',
          ),

          const SizedBox(height: 16),

          _buildPaymentCard(
            colors,
            _getText('branch'),
            'HIKKADUWA',
            '📍',
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouPage(Map<String, Color> colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),

          // Thank You Icon
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors['primary']!.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: const Center(
              child: Text('🙏', style: TextStyle(fontSize: 100)),
            ),
          ),

          const SizedBox(height: 40),

          // Thank You Message
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _getText('thank_you'),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colors['primary'],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getText('thank_message'),
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: colors['textColor'],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Text(
                  '💙 🇱🇰 💙',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: colors['primary'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 8,
              ),
              child: Text(
                _getText('done'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    Map<String, Color> colors,
    String label,
    String value,
    String emoji,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors['textColor']!.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors['textColor'],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _copyToClipboard(value),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors['primary']!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    color: colors['primary'],
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Map<String, Color> colors) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade200, Colors.pink.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous Button
            GestureDetector(
              onTap: _currentPage > 0
                  ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                  : null,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _currentPage > 0
                      ? Colors.blue
                      : Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: _currentPage > 0
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            // Home Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

            // Next Button
            GestureDetector(
              onTap: _currentPage < 3
                  ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                  : null,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _currentPage < 3
                      ? Colors.blue
                      : Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: _currentPage < 3
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
