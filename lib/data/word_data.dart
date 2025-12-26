import 'package:flutter/material.dart';

// Import all word data files
import 'word_data/body_parts.dart';
import 'word_data/animals.dart';
import 'word_data/fruits_vegetables.dart';
import 'word_data/objects.dart';
import 'word_data/colors_numbers.dart';
import 'word_data/feelings.dart';
import 'word_data/actions.dart';
import 'word_data/sounds_music.dart';
import 'word_data/food.dart';
import 'word_data/household.dart';
import 'word_data/colors.dart';
import 'word_data/numbers.dart';
import 'word_data/needs.dart';
import 'word_data/sentences.dart';

/// Main word data map that combines all categories
/// This map is used throughout the app to access vocabulary data
final Map<String, List<Map<String, dynamic>>> wordData = {
  'body_parts': bodyParts,
  'animals': animals,
  'fruits_vegetables': fruitsVegetables,
  'objects': objects,
  'colors_numbers': colorsNumbers,
  'feelings': feelings,
  'actions': actions,
  'sounds_music': soundsMusic,
  'food': food,
  'household': household,
  'colors': colors,
  'numbers': numbers,
  'needs': needs,
  'sentences': sentences,
};

// Legacy categories for compatibility
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
        'actions': [
          {'si': 'බත් කනවා', 'ta': 'சோறு சாப்பிடு', 'en': 'Eat rice'},
          {'si': 'බත් පිසින්න', 'ta': 'சோறு சமை', 'en': 'Cook rice'},
          {'si': 'බත් ස්පර්ශ', 'ta': 'சோறு தொடு', 'en': 'Touch rice'}
        ]
      },
      {
        'si': 'රොටි',
        'ta': 'ரொட்டி',
        'en': 'Bread',
        'emoji': '🍞',
        'actions': [
          {'si': 'රොටි කනවා', 'ta': 'ரொட்டி சாப்பிடு', 'en': 'Eat bread'},
          {'si': 'රොටි කෙටි', 'ta': 'ரொட்டி வெட்ட', 'en': 'Cut bread'},
          {'si': 'රොටි ස්පර්ශ', 'ta': 'ரொட்டி தொடு', 'en': 'Touch bread'}
        ]
      },
      {
        'si': 'වතුර',
        'ta': 'தண்ணீர்',
        'en': 'Water',
        'emoji': '💧',
        'actions': [
          {
            'si': 'වතුර හීස්තින්න',
            'ta': 'தண்ணீர் குடிக்க',
            'en': 'Drink water'
          },
          {'si': 'වතුර ඉතිරි කරන්න', 'ta': 'தண்ணீர் ஊற்று', 'en': 'Pour water'},
          {'si': 'වතුර ස්පර්ශ', 'ta': 'தண்ணீர் தொடு', 'en': 'Touch water'}
        ]
      },
      {
        'si': 'කිරි',
        'ta': 'பால்',
        'en': 'Milk',
        'emoji': '🥛',
        'actions': [
          {'si': 'කිරි හීස්තින්න', 'ta': 'பால் குடிக்க', 'en': 'Drink milk'},
          {'si': 'කිරි ගරුණු', 'ta': 'பால் சூடு', 'en': 'Warm milk'},
          {'si': 'කිරි ස්පර්ශ', 'ta': 'பால் தொடு', 'en': 'Touch milk'}
        ]
      },
      {
        'si': 'පලතුරු',
        'ta': 'பழங்கள்',
        'en': 'Fruits',
        'emoji': '🍎',
        'actions': [
          {'si': 'පලතුරු කනවා', 'ta': 'பழங்கள் சாப்பிடு', 'en': 'Eat fruits'},
          {'si': 'පලතුරු සොයන්න', 'ta': 'பழங்கள் தேடு', 'en': 'Find fruits'},
          {'si': 'පලතුරු ස්පර්ශ', 'ta': 'பழங்கள் தொடு', 'en': 'Touch fruits'}
        ]
      },
      {
        'si': 'කෑම',
        'ta': 'உணவு',
        'en': 'Food',
        'emoji': '🍽️',
        'actions': [
          {'si': 'කෑම කනවා', 'ta': 'உணவு சாப்பிடு', 'en': 'Eat food'},
          {'si': 'කෑම ගිණිසි', 'ta': 'உணவு இருக்கிறது', 'en': 'Food ready'},
          {'si': 'කෑම ස්පර්ශ', 'ta': 'உணவு தொடு', 'en': 'Touch food'}
        ]
      },
      {
        'si': 'චොකලට්',
        'ta': 'சாக்லேட்',
        'en': 'Chocolate',
        'emoji': '🍫',
        'actions': [
          {
            'si': 'චොකලට් කනවා',
            'ta': 'சாக்லேட் சாப்பிடு',
            'en': 'Eat chocolate'
          },
          {
            'si': 'චොකලට් ස්පර්ශ',
            'ta': 'சாக்லேட் தொடு',
            'en': 'Touch chocolate'
          },
          {'si': 'චොකලට් රස', 'ta': 'சாக்லேட் طعم', 'en': 'Taste chocolate'}
        ]
      },
      {
        'si': 'අයිස්ක්‍රීම්',
        'ta': 'ஐஸ்கிரீம்',
        'en': 'Ice cream',
        'emoji': '🍦',
        'actions': [
          {
            'si': 'අයිස්ක්‍රීම් කනවා',
            'ta': 'ஐஸ்கிரீம் சாப்பிடு',
            'en': 'Eat ice cream'
          },
          {
            'si': 'අයිස්ක්‍රීම් ස්පර්ශ',
            'ta': 'ஐஸ்கிரீம் தொடு',
            'en': 'Touch ice cream'
          },
          {
            'si': 'අයිස්ක්‍රීම් ශීතල',
            'ta': 'ஐஸ்கிரீம் குளிர்',
            'en': 'Ice cream cold'
          }
        ]
      },
    ],
  },
  'Feelings | හැඟීම් | உணர்வுகள්': {
    'icon': Icons.sentiment_satisfied,
    'color': Colors.pink,
    'items': [
      {
        'si': 'සතුටුයි',
        'ta': 'மகிழ்ச்சி',
        'en': 'Happy',
        'emoji': '😊',
        'actions': [
          {'si': 'සතුටු සිනාසුනෙන්න', 'ta': 'மகிழ்ச்சி சிரி', 'en': 'Smile'},
          {'si': 'සතුටු නැටුම', 'ta': 'மகிழ்ச்சி நாட்டம்', 'en': 'Dance'},
          {'si': 'සතුටු කෝරස්', 'ta': 'மகிழ்ச்சி ஆட', 'en': 'Cheer'}
        ]
      },
      {
        'si': 'දුකයි',
        'ta': 'சோகம்',
        'en': 'Sad',
        'emoji': '😢',
        'actions': [
          {'si': 'දුක් කඳුළු', 'ta': 'சோகம் கண்ணீர்', 'en': 'Cry'},
          {'si': 'දුක් මුහුණ', 'ta': 'சோகம் முகம்', 'en': 'Sad face'},
          {'si': 'දුක් සිතින්න', 'ta': 'சோகம் நினை', 'en': 'Think sad'}
        ]
      },
      {
        'si': 'කෝපයි',
        'ta': 'கோபம்',
        'en': 'Angry',
        'emoji': '😠',
        'actions': [
          {'si': 'කෝපී හඬ', 'ta': 'கோபம் குரல்', 'en': 'Shout'},
          {'si': 'කෝපී මුහුණ', 'ta': 'கோபம் முகம்', 'en': 'Angry face'},
          {'si': 'කෝපී පහරදීම', 'ta': 'கோபம் அடி', 'en': 'Hit'}
        ]
      },
      {
        'si': 'බයයි',
        'ta': 'பயம்',
        'en': 'Scared',
        'emoji': '😨',
        'actions': [
          {'si': 'බිය මුහුණ', 'ta': 'பயம் முகம்', 'en': 'Scared face'},
          {'si': 'බිය සිතින්න', 'ta': 'பயம் நினை', 'en': 'Feel scared'},
          {'si': 'බිය සඳහා ගිණිසි', 'ta': 'பயம் உட்கார', 'en': 'Hide'}
        ]
      },
      {
        'si': 'වෙහෙසයි',
        'ta': 'சோர்வு',
        'en': 'Tired',
        'emoji': '😴',
        'actions': [
          {'si': 'තෙහෙට්ටු නිදුණු', 'ta': 'சோர்வு உறங்கு', 'en': 'Sleep'},
          {'si': 'තෙහෙට්ටු මුහුණ', 'ta': 'சோர்வு முகம்', 'en': 'Tired face'},
          {'si': 'තෙහෙට්ටු ඇස', 'ta': 'சோர்வு கண்', 'en': 'Close eyes'}
        ]
      },
      {
        'si': 'ආදරයි',
        'ta': 'அன்பு',
        'en': 'Love',
        'emoji': '❤️',
        'actions': [
          {'si': 'ආදර අඩිල්ල', 'ta': 'அன்பு கோலம்', 'en': 'Heart'},
          {'si': 'ආදර ගිණිසි', 'ta': 'அன்பு வாழ', 'en': 'Love you'},
          {'si': 'ආදර සිතින්න', 'ta': 'அன்பு நினை', 'en': 'Think love'}
        ]
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
        'actions': [
          {'si': 'කෑම අවශ්‍යයි', 'ta': 'உணவு வேண்டும்', 'en': 'I want food'},
          {'si': 'බත් කනවා', 'ta': 'சோறு சாப்பிடு', 'en': 'Eat rice'},
          {'si': 'සුවඳ කනවා', 'ta': 'உணவு வாசனை', 'en': 'Food smells good'}
        ]
      },
      {
        'si': 'බොන්න ඕනා',
        'ta': 'குடிக்க வேண்டும்',
        'en': 'Want to drink',
        'emoji': '🥤',
        'actions': [
          {
            'si': 'වතුර අවශ්‍යයි',
            'ta': 'தண்ணீர் வேண்டும்',
            'en': 'I want water'
          },
          {'si': 'කිරි හීස්තින්න', 'ta': 'பால் குடிக்க', 'en': 'Drink milk'},
          {'si': 'ශීතල පිරිසිඳු', 'ta': 'குளிர் பানம்', 'en': 'Cold drink'}
        ]
      },
      {
        'si': 'නාන්න ඕනා',
        'ta': 'குளிக்க வேண்டும்',
        'en': 'Want to bathe',
        'emoji': '🚿',
        'actions': [
          {
            'si': 'නාන්න අවශ්‍යයි',
            'ta': 'குளிக்க வேண்டும்',
            'en': 'I need bath'
          },
          {'si': 'උණුසුම් වතුර', 'ta': 'சூடான தண்ணீர்', 'en': 'Warm water'},
          {'si': 'සබු භාවිතයි', 'ta': 'சோப்பு பயன்படுத்த', 'en': 'Use soap'}
        ]
      },
      {
        'si': 'සෙල්ලම් කරන්න',
        'ta': 'விளையாட',
        'en': 'Play',
        'emoji': '🎮',
        'actions': [
          {
            'si': 'සෙල්ලම් කරන්න අවශ්‍යයි',
            'ta': 'விளையாட வேண்டும்',
            'en': 'Want play'
          },
          {'si': 'බෝල සෙල්ලම්', 'ta': 'பந்து விளையாட', 'en': 'Play ball'},
          {
            'si': 'ඔබ සාથ සෙල්ලම්',
            'ta': 'உன்னுடன் விளையாட',
            'en': 'Play with you'
          }
        ]
      },
      {
        'si': 'නිදාගන්න',
        'ta': 'தூங்க',
        'en': 'Sleep',
        'emoji': '🛏️',
        'actions': [
          {
            'si': 'නිදාගන්න අවශ්‍යයි',
            'ta': 'தூங்க வேண்டும்',
            'en': 'I need sleep'
          },
          {'si': 'ඇඳුම් ගලවන්න', 'ta': 'உடை மாற', 'en': 'Change clothes'},
          {'si': 'ආලෝකය අවුරුදු', 'ta': 'விளக்கு அணை', 'en': 'Lights off'}
        ]
      },
      {
        'si': 'උදව් ඕනා',
        'ta': 'உதவி வேண்டும்',
        'en': 'Need help',
        'emoji': '🆘',
        'actions': [
          {'si': 'උදව් කරන්න ඉවසා', 'ta': 'உதவி சொல்ல', 'en': 'Please help'},
          {'si': 'කුමක් සිදුවුණේ', 'ta': 'என்ன நடந்தது', 'en': 'What happened'},
          {
            'si': 'ඔබ අවශ්‍ය දෙයි',
            'ta': 'உனக்கு என்ன வேண்டும்',
            'en': 'What do you need'
          }
        ]
      },
      {
        'si': 'ටොයිලට් යන්න',
        'ta': 'கழிவறைக்கு',
        'en': 'Toilet',
        'emoji': '🚽',
        'actions': [
          {
            'si': 'ටොයිලට් යන්න අවශ්‍යයි',
            'ta': 'கழிவறை வேண்டும்',
            'en': 'I need toilet'
          },
          {'si': 'වාසර කාමරය', 'ta': 'இளிவு அறை', 'en': 'Restroom'},
          {
            'si': 'ටොයිලට් ඉතිරි කරන්න',
            'ta': 'கழிவறைக்குப் போ',
            'en': 'Go toilet'
          }
        ]
      },
      {
        'si': 'ඇඳුම් ගලවන්න',
        'ta': 'உடை மாற்ற',
        'en': 'Change clothes',
        'emoji': '👕',
        'actions': [
          {'si': 'නව ඇඳුම්', 'ta': 'புதிய உடை', 'en': 'New clothes'},
          {'si': 'උණුසුම් ඇඳුම්', 'ta': 'சூடான உடை', 'en': 'Warm clothes'},
          {'si': 'ශීතල ඇඳුම්', 'ta': 'குளிர் உடை', 'en': 'Cool clothes'}
        ]
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
        'actions': [
          {'si': 'අම්මා සඳහා', 'ta': 'அம்மாவைப் பற்றி', 'en': 'About mother'},
          {'si': 'අම්මා වෙතට', 'ta': 'அம்மாவை அழைக්க', 'en': 'Call mother'},
          {'si': 'අම්මා සමීපයි', 'ta': 'அம்மாவை தொட', 'en': 'Hug mother'}
        ]
      },
      {
        'si': 'තාත්තා',
        'ta': 'அப்பா',
        'en': 'Father',
        'emoji': '👨',
        'actions': [
          {'si': 'තාත්තා සඳහා', 'ta': 'அப्पாவைப் பற්றி', 'en': 'About father'},
          {'si': 'තාත්තා වෙතට', 'ta': 'अप्पावை அழைக్క', 'en': 'Call father'},
          {'si': 'තාත්තා සමීපයි', 'ta': 'અप్पாவை தொட', 'en': 'Hug father'}
        ]
      },
      {
        'si': 'අක්කා',
        'ta': 'அக்கா',
        'en': 'Sister',
        'emoji': '👧',
        'actions': [
          {'si': 'අක්කා සඳහා', 'ta': 'அக்காவைப் பற்றி', 'en': 'About sister'},
          {'si': 'අක්කා වෙතට', 'ta': 'அக्काவை அழைக़க', 'en': 'Call sister'},
          {
            'si': 'අක්කා සෙල්ලම්',
            'ta': 'அக్కาவுடன் விளையாட',
            'en': 'Play with sister'
          }
        ]
      },
      {
        'si': 'අය්ය',
        'ta': 'அண்ணா',
        'en': 'Brother',
        'emoji': '👦',
        'actions': [
          {'si': 'අය්ය සඳහා', 'ta': 'அண்ணாவைप் பற்றி', 'en': 'About brother'},
          {'si': 'අය්ය වෙතට', 'ta': 'அண్ణावை அழைക්క', 'en': 'Call brother'},
          {
            'si': 'අය්ය සෙල්ලම්',
            'ta': 'அண्ணாவுடன் விளையாட',
            'en': 'Play with brother'
          }
        ]
      },
      {
        'si': 'ආච්චි',
        'ta': 'பாட்டி',
        'en': 'Grandmother',
        'emoji': '👵',
        'actions': [
          {
            'si': 'ආච්චි සඳහා',
            'ta': 'பாட్టியைப் பற்றி',
            'en': 'About grandmother'
          },
          {
            'si': 'ආච්චි වෙතට',
            'ta': 'பாட్టியை அழைக্க',
            'en': 'Call grandmother'
          },
          {'si': 'ආච්චි සමීපයි', 'ta': 'பாட్టியை தொட', 'en': 'Hug grandmother'}
        ]
      },
      {
        'si': 'සීයා',
        'ta': 'தாத்தா',
        'en': 'Grandfather',
        'emoji': '👴',
        'actions': [
          {
            'si': 'සීයා සඳහා',
            'ta': 'தாத්தாவைப் பற்றி',
            'en': 'About grandfather'
          },
          {
            'si': 'සීයා වෙතට',
            'ta': 'தாத్తாவை அழைக్క',
            'en': 'Call grandfather'
          },
          {'si': 'සීයා සමීපයි', 'ta': 'தாත్తாவை தொட', 'en': 'Hug grandfather'}
        ]
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
        'actions': [
          {'si': 'ගෙදරට යන්න', 'ta': 'வீட்டுக்குப் போ', 'en': 'Go home'},
          {'si': 'ගෙදරේ සිටින්න', 'ta': 'வீட்டில் உட்கார', 'en': 'Stay home'},
          {'si': 'ගෙදර සරුසරු', 'ta': 'வீட்டை পরிষ்கரி', 'en': 'Clean home'}
        ]
      },
      {
        'si': 'පාසල',
        'ta': 'பள்ளி',
        'en': 'School',
        'emoji': '🏫',
        'actions': [
          {'si': 'පාසලට යන්න', 'ta': 'பள్ளிக்குப் போ', 'en': 'Go school'},
          {'si': 'පාසලේ ගිණිසි', 'ta': 'பள்ளியில் உட்கார', 'en': 'At school'},
          {'si': 'පාසල ඉගෙනුම්', 'ta': 'பள்ளி கற்கை', 'en': 'Learn at school'}
        ]
      },
      {
        'si': 'උද්‍යානය',
        'ta': 'பூங்கா',
        'en': 'Park',
        'emoji': '🌳',
        'actions': [
          {'si': 'උද්‍යානයට යන්න', 'ta': 'பூங්காவுக்குப் போ', 'en': 'Go park'},
          {
            'si': 'උද්‍යානයේ සෙල්ලම්',
            'ta': 'பூங்காவில் விளையாட',
            'en': 'Play in park'
          },
          {'si': 'උද්‍යානය සුන්දර', 'ta': 'பூங்கா아름다워', 'en': 'Park beautiful'}
        ]
      },
      {
        'si': 'රෝහල',
        'ta': 'மருத்துவமனை',
        'en': 'Hospital',
        'emoji': '🏥',
        'actions': [
          {
            'si': 'රෝහලට යන්න',
            'ta': 'மருத்துவமனைக்குப் போ',
            'en': 'Go hospital'
          },
          {
            'si': 'රෝහලේ ඩාක්ටර්',
            'ta': 'மருத்துவமனை வைத்தியர்',
            'en': 'Hospital doctor'
          },
          {'si': 'රෝහල සහාය', 'ta': 'மருத்துவமனை உதவி', 'en': 'Hospital help'}
        ]
      },
      {
        'si': 'කඩය',
        'ta': 'கடை',
        'en': 'Shop',
        'emoji': '🏪',
        'actions': [
          {'si': 'කඩයට යන්න', 'ta': 'கடைக்குப் போ', 'en': 'Go shop'},
          {'si': 'කඩයේ සෙවීම', 'ta': 'கடையில் வாங்கு', 'en': 'Shop buying'},
          {'si': 'කඩය නිල්වල', 'ta': 'கடை வாசல்', 'en': 'Shop door'}
        ]
      },
      {
        'si': 'එළියට යන්න',
        'ta': 'வெளியே போக',
        'en': 'Go outside',
        'emoji': '🚗',
        'actions': [
          {
            'si': 'එළියට යන්න අවශ්‍යයි',
            'ta': 'வெளியே போக வேண்டும்',
            'en': 'Want go outside'
          },
          {'si': 'තාපතිය ලස්සන', 'ta': 'வெளி நல్ல', 'en': 'Outside nice'},
          {'si': 'වාහනයට නැඟින්න', 'ta': 'கார் ஏற', 'en': 'Get in car'}
        ]
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
        'actions': [
          {'si': 'ඔව් තරම් ස්පष්ඨ', 'ta': 'ஆம் தெளிவு', 'en': 'Yes clear'},
          {'si': 'ඔව් සहमtি', 'ta': 'ஆம் உடன்பாடு', 'en': 'Yes agree'},
          {'si': 'ඔව් නිස්සන්දෙහ', 'ta': 'ஆம் ঠीক', 'en': 'Yes correct'}
        ]
      },
      {
        'si': 'නැහැ',
        'ta': 'இல்லை',
        'en': 'No',
        'emoji': '❌',
        'actions': [
          {'si': 'නැහැ නිසි', 'ta': 'இல்லை திறமை', 'en': 'No thanks'},
          {
            'si': 'නැහැ අවශ්‍යයි නොවේ',
            'ta': 'இல்லை வேண்டாம்',
            'en': 'No not want'
          },
          {'si': 'නැහැ බුද්ධිමතිය', 'ta': 'இல்லை புரி', 'en': 'No understand'}
        ]
      },
      {
        'si': 'හරි',
        'ta': 'சரி',
        'en': 'OK',
        'emoji': '👍',
        'actions': [
          {'si': 'හරි නිලංකර', 'ta': 'சரி சம்மதം', 'en': 'OK agree'},
          {'si': 'හරි තිබෙන', 'ta': 'சரி சரியாக', 'en': 'OK correct'},
          {'si': 'හරි ගිණිසි', 'ta': 'சரி உட்கார', 'en': 'OK sit'}
        ]
      },
      {
        'si': 'කැමතියි',
        'ta': 'விரும்புகிறேன்',
        'en': 'Like',
        'emoji': '💚',
        'actions': [
          {
            'si': 'කැමතිය ඇත්තේ',
            'ta': 'விரும்பு நன்றாக',
            'en': 'Like very much'
          },
          {'si': 'කැමතිය වඩුතරම්', 'ta': 'விரும்பு அதிக', 'en': 'Like more'},
          {'si': 'කැමතිය ඔබ', 'ta': 'விரும்புகிறேன் உனை', 'en': 'Like you'}
        ]
      },
      {
        'si': 'කැමති නැහැ',
        'ta': 'விரும்பவில்லை',
        'en': 'Don\'t like',
        'emoji': '👎',
        'actions': [
          {
            'si': 'කැමති නැහැ ඇතිටි',
            'ta': 'விரும்பவில்லை அனேகமாக',
            'en': 'Not like at all'
          },
          {
            'si': 'කැමති නැහැ එය',
            'ta': 'விரும்பவில்லை அதை',
            'en': 'Not like it'
          },
          {
            'si': 'කැමති නැහැ කිසිවෙක්',
            'ta': 'விரும்பவில்லை ஒன்றும்',
            'en': 'Not like nothing'
          }
        ]
      },
      {
        'si': 'මම දන්නේ නැහැ',
        'ta': 'எனக்கு தெரியாது',
        'en': 'I don\'t know',
        'emoji': '🤷',
        'actions': [
          {
            'si': 'දන්නේ නැත්තෙ එය',
            'ta': 'தெரியாது அது',
            'en': 'Don\'t know that'
          },
          {
            'si': 'දන්නේ නැත්තෙ කිසිවෙක්',
            'ta': 'தெரியாது ஒன்றும்',
            'en': 'Don\'t know anything'
          },
          {
            'si': 'සහාය කරන්න කරුණාකර',
            'ta': 'உதவிய செய় தயவு',
            'en': 'Help please'
          }
        ]
      },
    ],
  },
};
