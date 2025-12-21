import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> categories = {
  'Food | ආහාර | உணவு': {
    'icon': Icons.restaurant,
    'color': Colors.orange,
    'items': [
      {'si': 'බත්', 'ta': 'சோறு', 'en': 'Rice', 'emoji': '🍚'},
      {'si': 'රොටි', 'ta': 'ரொட்டி', 'en': 'Bread', 'emoji': '🍞'},
      {'si': 'වතුර', 'ta': 'தண்ணீர்', 'en': 'Water', 'emoji': '💧'},
      {'si': 'කිරි', 'ta': 'பால்', 'en': 'Milk', 'emoji': '🥛'},
      {'si': 'පලතුරු', 'ta': 'பழங்கள்', 'en': 'Fruits', 'emoji': '🍎'},
      {'si': 'කෑම', 'ta': 'உணவு', 'en': 'Food', 'emoji': '🍽️'},
      {'si': 'චොකලට්', 'ta': 'சாக்லேட்', 'en': 'Chocolate', 'emoji': '🍫'},
      {
        'si': 'අයිස්ක්‍රීම්',
        'ta': 'ஐஸ்கிரீம்',
        'en': 'Ice cream',
        'emoji': '🍦',
      },
    ],
  },
  'Feelings | හැඟීම් | உணர்வுகள்': {
    'icon': Icons.sentiment_satisfied,
    'color': Colors.pink,
    'items': [
      {'si': 'සතුටුයි', 'ta': 'மகிழ்ச்சி', 'en': 'Happy', 'emoji': '😊'},
      {'si': 'දුකයි', 'ta': 'சோகம்', 'en': 'Sad', 'emoji': '😢'},
      {'si': 'කෝපයි', 'ta': 'கோபம்', 'en': 'Angry', 'emoji': '😠'},
      {'si': 'බයයි', 'ta': 'பயம்', 'en': 'Scared', 'emoji': '😨'},
      {'si': 'වෙහෙසයි', 'ta': 'சோர்வு', 'en': 'Tired', 'emoji': '😴'},
      {'si': 'ආදරයි', 'ta': 'அன்பு', 'en': 'Love', 'emoji': '❤️'},
    ],
  },
  'Actions | ක්‍රියා | செயல்கள்': {
    'icon': Icons.directions_run,
    'color': Colors.green,
    'items': [
      {
        'si': 'කන්න ඕනා',
        'ta': 'சாப்பிட வேண்டும்',
        'en': 'Want to eat',
        'emoji': '🍴',
      },
      {
        'si': 'බොන්න ඕනා',
        'ta': 'குடிக்க வேண்டும்',
        'en': 'Want to drink',
        'emoji': '🥤',
      },
      {
        'si': 'නාන්න ඕනා',
        'ta': 'குளிக்க வேண்டும்',
        'en': 'Want to bathe',
        'emoji': '🚿',
      },
      {'si': 'සෙල්ලම් කරන්න', 'ta': 'விளையாட', 'en': 'Play', 'emoji': '🎮'},
      {'si': 'නිදාගන්න', 'ta': 'தூங்க', 'en': 'Sleep', 'emoji': '🛏️'},
      {
        'si': 'උදව් ඕනා',
        'ta': 'உதவி வேண்டும்',
        'en': 'Need help',
        'emoji': '🆘',
      },
      {'si': 'ටොයිලට් යන්න', 'ta': 'கழிவறைக்கு', 'en': 'Toilet', 'emoji': '🚽'},
      {
        'si': 'ඇඳුම් ගලවන්න',
        'ta': 'உடை மாற்ற',
        'en': 'Change clothes',
        'emoji': '👕',
      },
    ],
  },
  'Family | පවුල | குடும்பம்': {
    'icon': Icons.family_restroom,
    'color': Colors.purple,
    'items': [
      {'si': 'අම්මා', 'ta': 'அம்மா', 'en': 'Mother', 'emoji': '👩'},
      {'si': 'තාත්තා', 'ta': 'அப்பா', 'en': 'Father', 'emoji': '👨'},
      {'si': 'අක්කා', 'ta': 'அக்கா', 'en': 'Sister', 'emoji': '👧'},
      {'si': 'අය්ය', 'ta': 'அண்ணா', 'en': 'Brother', 'emoji': '👦'},
      {'si': 'ආච්චි', 'ta': 'பாட்டி', 'en': 'Grandmother', 'emoji': '👵'},
      {'si': 'සීයා', 'ta': 'தாத்தா', 'en': 'Grandfather', 'emoji': '👴'},
    ],
  },
  'Places | ස්ථාන | இடங்கள்': {
    'icon': Icons.location_on,
    'color': Colors.blue,
    'items': [
      {'si': 'ගෙදර', 'ta': 'வீடு', 'en': 'Home', 'emoji': '🏠'},
      {'si': 'පාසල', 'ta': 'பள்ளி', 'en': 'School', 'emoji': '🏫'},
      {'si': 'උද්‍යානය', 'ta': 'பூங்கா', 'en': 'Park', 'emoji': '🌳'},
      {'si': 'රෝහල', 'ta': 'மருத்துவமனை', 'en': 'Hospital', 'emoji': '🏥'},
      {'si': 'කඩය', 'ta': 'கடை', 'en': 'Shop', 'emoji': '🏪'},
      {
        'si': 'එළියට යන්න',
        'ta': 'வெளியே போக',
        'en': 'Go outside',
        'emoji': '🚗',
      },
    ],
  },
  'Yes/No | ඔව්/නැහැ | ஆம்/இல்லை': {
    'icon': Icons.check_circle,
    'color': Colors.teal,
    'items': [
      {'si': 'ඔව්', 'ta': 'ஆம்', 'en': 'Yes', 'emoji': '✅'},
      {'si': 'නැහැ', 'ta': 'இல்லை', 'en': 'No', 'emoji': '❌'},
      {'si': 'හරි', 'ta': 'சரி', 'en': 'OK', 'emoji': '👍'},
      {'si': 'කැමතියි', 'ta': 'விரும்புகிறேன்', 'en': 'Like', 'emoji': '💚'},
      {
        'si': 'කැමති නැහැ',
        'ta': 'விரும்பவில்லை',
        'en': 'Don\'t like',
        'emoji': '👎',
      },
      {
        'si': 'මම දන්නේ නැහැ',
        'ta': 'எனக்கு தெரியாது',
        'en': 'I don\'t know',
        'emoji': '🤷',
      },
    ],
  },
};
