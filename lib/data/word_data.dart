import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> categories = {
  'Food | ආහාර | உணவு': {
    'icon': Icons.restaurant,
    'color': Colors.orange,
    'items': [
      {
        'si': 'බත්',
        'ta': 'சோறு',
        'en': 'Rice',
        'emoji': '🍚',
        'icon': Icons.restaurant
      },
      {
        'si': 'රොටි',
        'ta': 'ரொட்டி',
        'en': 'Bread',
        'emoji': '🍞',
        'icon': Icons.bakery_dining
      },
      {
        'si': 'වතුර',
        'ta': 'தண்ணீர்',
        'en': 'Water',
        'emoji': '💧',
        'icon': Icons.water_drop
      },
      {
        'si': 'කිරි',
        'ta': 'பால்',
        'en': 'Milk',
        'emoji': '🥛',
        'icon': Icons.local_drink
      },
      {
        'si': 'පලතුරු',
        'ta': 'பழங்கள்',
        'en': 'Fruits',
        'emoji': '🍎',
        'icon': Icons.local_grocery_store
      },
      {
        'si': 'කෑම',
        'ta': 'உணவு',
        'en': 'Food',
        'emoji': '🍽️',
        'icon': Icons.restaurant
      },
      {
        'si': 'චොකලට්',
        'ta': 'சாக்லேட்',
        'en': 'Chocolate',
        'emoji': '🍫',
        'icon': Icons.cake
      },
      {
        'si': 'අයිස්ක්‍රීම්',
        'ta': 'ஐஸ்கிரீம்',
        'en': 'Ice cream',
        'emoji': '🍦',
        'icon': Icons.icecream,
      },
    ],
    // Actions related to Food category — these will show alongside food items
    'actions': [
      {
        'si': 'කන්න',
        'ta': 'சாப்பிடு',
        'en': 'Eat',
        'emoji': '🍽️',
        'icon': Icons.restaurant
      },
      {
        'si': 'බත් කන්න',
        'ta': 'சோறு சாப்பிடு',
        'en': 'Eat Rice',
        'emoji': '🍚',
        'icon': Icons.restaurant
      },
      {
        'si': 'රොටි කන්න',
        'ta': 'ரொட்டி சாப்பிடு',
        'en': 'Eat Bread',
        'emoji': '🍞',
        'icon': Icons.bakery_dining
      },
      {
        'si': 'පලතුරු කන්න',
        'ta': 'பழம் சாப்பிடு',
        'en': 'Eat Fruits',
        'emoji': '🍎',
        'icon': Icons.local_grocery_store
      },
      {
        'si': 'හැපී',
        'ta': 'பிடிக்கும்',
        'en': 'Like',
        'emoji': '👍',
        'icon': Icons.thumb_up
      },
      {
        'si': 'ඇත්තේ නෑ',
        'ta': 'விரும்பவில்லை',
        'en': 'Don\'t like',
        'emoji': '👎',
        'icon': Icons.thumb_down
      },
      {'si': 'එනවා', 'ta': 'வருகிறது', 'en': 'Enough', 'emoji': '✅'},
      {
        'si': 'තවත් ඕනේ',
        'ta': 'மேலும் வேண்டும்',
        'en': 'More please',
        'emoji': '➕'
      },
    ],
  },
  'Feelings | හැඟීම් | உணர்வுகள்': {
    'icon': Icons.sentiment_satisfied,
    'color': Colors.pink,
    'items': [
      {
        'si': 'සතුටුයි',
        'ta': 'மகிழ்ச்சி',
        'en': 'Happy',
        'emoji': '😊',
        'icon': Icons.sentiment_very_satisfied
      },
      {
        'si': 'දුකයි',
        'ta': 'சோகம்',
        'en': 'Sad',
        'emoji': '😢',
        'icon': Icons.sentiment_dissatisfied
      },
      {
        'si': 'කෝපයි',
        'ta': 'கோபம்',
        'en': 'Angry',
        'emoji': '😠',
        'icon': Icons.sentiment_very_dissatisfied
      },
      {
        'si': 'බයයි',
        'ta': 'பயம்',
        'en': 'Scared',
        'emoji': '😨',
        'icon': Icons.sentiment_neutral
      },
      {
        'si': 'වෙහෙසයි',
        'ta': 'சோர்வு',
        'en': 'Tired',
        'emoji': '😴',
        'icon': Icons.bedtime
      },
      {
        'si': 'ආදරයි',
        'ta': 'அன்பு',
        'en': 'Love',
        'emoji': '❤️',
        'icon': Icons.favorite
      },
    ],
    'actions': [
      {
        'si': 'මට සතුටුයි',
        'ta': 'எனக்கு மகிழ்ச்சி',
        'en': 'I am happy',
        'emoji': '😊',
        'icon': Icons.sentiment_very_satisfied
      },
      {
        'si': 'මට දුකයි',
        'ta': 'எனக்கு துக்கம்',
        'en': 'I am sad',
        'emoji': '😢',
        'icon': Icons.sentiment_dissatisfied
      },
      {
        'si': 'මට ඉන්නට උදවු කරන්න',
        'ta': 'எனக்கு உதவுங்கள்',
        'en': 'Comfort me',
        'emoji': '🤗',
        'icon': Icons.support_agent
      },
      {
        'si': 'මට සෙල්ලම් කරන්න ඕනේ',
        'ta': 'நான் விளையாட வேண்டும்',
        'en': 'I want to play',
        'emoji': '🎮',
        'icon': Icons.sports_esports
      },
      {
        'si': 'උදව් ඕනේ',
        'ta': 'உதவி வேண்டும்',
        'en': 'Need help',
        'emoji': '🆘',
        'icon': Icons.live_help
      },
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
        'icon': Icons.restaurant
      },
      {
        'si': 'බොන්න ඕනා',
        'ta': 'குடிக்க வேண்டும்',
        'en': 'Want to drink',
        'emoji': '🥤',
        'icon': Icons.local_drink
      },
      {
        'si': 'නාන්න ඕනා',
        'ta': 'குளிக்க வேண்டும்',
        'en': 'Want to bathe',
        'emoji': '🚿',
        'icon': Icons.shower
      },
      {
        'si': 'සෙල්ලම් කරන්න',
        'ta': 'விளையாட',
        'en': 'Play',
        'emoji': '🎮',
        'icon': Icons.sports_esports
      },
      {
        'si': 'නිදාගන්න',
        'ta': 'தூங்க',
        'en': 'Sleep',
        'emoji': '🛏️',
        'icon': Icons.bed
      },
      {
        'si': 'උදව් ඕනා',
        'ta': 'உதவி வேண்டும்',
        'en': 'Need help',
        'emoji': '🆘',
        'icon': Icons.live_help,
      },
      {
        'si': 'ටොයිලට් යන්න',
        'ta': 'கழிவறைக்கு',
        'en': 'Toilet',
        'emoji': '🚽',
        'icon': Icons.wc
      },
      {
        'si': 'ඇඳුම් ගලවන්න',
        'ta': 'உடை மாற்ற',
        'en': 'Change clothes',
        'emoji': '👕',
        'icon': Icons.checkroom,
      },
    ],
    'actions': [
      {
        'si': 'ඇයි?',
        'ta': 'ஏன்?',
        'en': 'Why?',
        'emoji': '❓',
        'icon': Icons.help_outline
      },
      {
        'si': 'ඔව්',
        'ta': 'ஆம்',
        'en': 'Yes',
        'emoji': '✅',
        'icon': Icons.check_circle
      },
      {
        'si': 'නෑ',
        'ta': 'இல்லை',
        'en': 'No',
        'emoji': '❌',
        'icon': Icons.cancel
      },
      {
        'si': 'කරන්න',
        'ta': 'செய்',
        'en': 'Do it',
        'emoji': '✔️',
        'icon': Icons.check
      },
      {
        'si': 'නවත්වන්න',
        'ta': 'நிறுத்து',
        'en': 'Stop',
        'emoji': '⏹️',
        'icon': Icons.stop
      },
    ],
  },
  'Family | පවුල | குடும்பம்': {
    'icon': Icons.family_restroom,
    'color': Colors.purple,
    'items': [
      {
        'si': 'අම්මා',
        'ta': 'அம்மா',
        'en': 'Mother',
        'emoji': '👩',
        'icon': Icons.female
      },
      {
        'si': 'තාත්තා',
        'ta': 'அப்பா',
        'en': 'Father',
        'emoji': '👨',
        'icon': Icons.male
      },
      {
        'si': 'අක්කා',
        'ta': 'அக்கா',
        'en': 'Sister',
        'emoji': '👧',
        'icon': Icons.child_care
      },
      {
        'si': 'අය්ය',
        'ta': 'அண்ணா',
        'en': 'Brother',
        'emoji': '👦',
        'icon': Icons.child_care
      },
      {
        'si': 'ආච්චි',
        'ta': 'பாட்டி',
        'en': 'Grandmother',
        'emoji': '👵',
        'icon': Icons.person
      },
      {
        'si': 'සීයා',
        'ta': 'தாத்தா',
        'en': 'Grandfather',
        'emoji': '👴',
        'icon': Icons.person
      },
    ],
    'actions': [
      {
        'si': 'අම්මා වගේ',
        'ta': 'அம்மாவைப் போன்று',
        'en': 'Call Mother',
        'emoji': '📞',
        'icon': Icons.call
      },
      {
        'si': 'තාත්තා වගේ',
        'ta': 'அப்பாவைப் போன்று',
        'en': 'Call Father',
        'emoji': '📞',
        'icon': Icons.call
      },
      {
        'si': 'ගෑනු ගන්න',
        'ta': 'அன்புடன்',
        'en': 'Hug',
        'emoji': '🤗',
        'icon': Icons.emoji_emotions
      },
      {
        'si': 'ඔයාගේ නිවාසය',
        'ta': 'உன் வீடு',
        'en': 'Home',
        'emoji': '🏠',
        'icon': Icons.home
      },
    ],
  },
  'Places | ස්ථාන | இடங்கள்': {
    'icon': Icons.location_on,
    'color': Colors.blue,
    'items': [
      {
        'si': 'ගෙදර',
        'ta': 'வீடு',
        'en': 'Home',
        'emoji': '🏠',
        'icon': Icons.home
      },
      {
        'si': 'පාසල',
        'ta': 'பள்ளி',
        'en': 'School',
        'emoji': '🏫',
        'icon': Icons.school
      },
      {
        'si': 'උද්‍යානය',
        'ta': 'பூங்கா',
        'en': 'Park',
        'emoji': '🌳',
        'icon': Icons.park
      },
      {
        'si': 'රෝහල',
        'ta': 'மருத்துவமனை',
        'en': 'Hospital',
        'emoji': '🏥',
        'icon': Icons.local_hospital
      },
      {
        'si': 'කඩය',
        'ta': 'கடை',
        'en': 'Shop',
        'emoji': '🏪',
        'icon': Icons.store
      },
      {
        'si': 'එළියට යන්න',
        'ta': 'வெளியே போக',
        'en': 'Go outside',
        'emoji': '🚗',
        'icon': Icons.directions_car,
      },
    ],
    'actions': [
      {
        'si': 'ගෙදර යමු',
        'ta': 'வீடு போலாம்',
        'en': 'Go home',
        'emoji': '🏠',
        'icon': Icons.home
      },
      {
        'si': 'පාසලට යමු',
        'ta': 'பள்ளிக்கு போகலாம்',
        'en': 'Go to school',
        'emoji': '🏫',
        'icon': Icons.school
      },
      {
        'si': 'උද්‍යානයට යමු',
        'ta': 'பூங்காவுக்கு போகலாம்',
        'en': 'Go to park',
        'emoji': '🌳',
        'icon': Icons.park
      },
      {
        'si': 'රෝහලට යමු',
        'ta': 'மருத்துவமனைக்கு போகலாம்',
        'en': 'Go to hospital',
        'emoji': '🏥',
        'icon': Icons.local_hospital
      },
    ],
  },
  'Yes/No | ඔව්/නැහැ | ஆம்/இல்லை': {
    'icon': Icons.check_circle,
    'color': Colors.teal,
    'items': [
      {
        'si': 'ඔව්',
        'ta': 'ஆம்',
        'en': 'Yes',
        'emoji': '✅',
        'icon': Icons.check_circle
      },
      {
        'si': 'නැහැ',
        'ta': 'இல்லை',
        'en': 'No',
        'emoji': '❌',
        'icon': Icons.cancel
      },
      {
        'si': 'හරි',
        'ta': 'சரி',
        'en': 'OK',
        'emoji': '👍',
        'icon': Icons.thumb_up
      },
      {
        'si': 'කැමතියි',
        'ta': 'விரும்புகிறேன்',
        'en': 'Like',
        'emoji': '💚',
        'icon': Icons.favorite
      },
      {
        'si': 'කැමති නැහැ',
        'ta': 'விரும்பவில்லை',
        'en': 'Don\'t like',
        'emoji': '👎',
        'icon': Icons.thumb_down,
      },
      {
        'si': 'මම දන්නේ නැහැ',
        'ta': 'எனக்கு தெரியாது',
        'en': 'I don\'t know',
        'emoji': '🤷',
        'icon': Icons.help_center
      },
    ],
    'actions': [
      {
        'si': 'ඔබට කැමෙයිද?',
        'ta': 'உங்களுக்கு பிடிக்குமா?',
        'en': 'Do you like it?',
        'emoji': '❓'
      },
      {'si': 'හරි', 'ta': 'சரி', 'en': 'OK', 'emoji': '👍'},
      {'si': 'නැහැ', 'ta': 'இல்லை', 'en': 'No', 'emoji': '❌'},
    ],
  },
};
