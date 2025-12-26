import 'package:flutter/material.dart';

final Map<String, List<Map<String, dynamic>>> wordData = {
  'body_parts': [
    {
      'si': 'හස',
      'ta': 'கை',
      'en': 'Hand',
      'emoji': '🤚',
      'actions': [
        {'si': 'හස ස්පර්ශ කරන්න', 'ta': 'கை தொடு', 'en': 'Touch hand'},
        {'si': 'හස ඔසවන්න', 'ta': 'கை உயர்த்து', 'en': 'Raise hand'},
        {'si': 'කතා කරන්න', 'ta': 'கை அசை', 'en': 'Wave hand'}
      ]
    },
    {
      'si': 'පා',
      'ta': 'கால்',
      'en': 'Leg',
      'emoji': '🦵',
      'actions': [
        {'si': 'පා ස්පර්ශ කරන්න', 'ta': 'கால் தொடு', 'en': 'Touch leg'},
        {'si': 'පා ගමන් කරන්න', 'ta': 'கால் நடை', 'en': 'Walk'},
        {'si': 'පා පැනීම', 'ta': 'கால் குதி', 'en': 'Jump'}
      ]
    },
    {
      'si': 'මුහුණ',
      'ta': 'முகம்',
      'en': 'Face',
      'emoji': '😊',
      'actions': [
        {'si': 'මුහුණ සිනාසුනෙන්න', 'ta': 'முகம் சிரி', 'en': 'Smile'},
        {'si': 'මුහුණ සිනාසුනෙන්න', 'ta': 'முகம் ஆச్චரியம்', 'en': 'Surprised'},
        {'si': 'මුහුණ ගිරවෙන්න', 'ta': 'முகம் సాచ్', 'en': 'Sad face'}
      ]
    },
    {
      'si': 'ගස',
      'ta': 'கண்',
      'en': 'Eye',
      'emoji': '👁️',
      'actions': [
        {'si': 'ගස තැබිය යුතු', 'ta': 'கண் திறக்க', 'en': 'Open eyes'},
        {'si': 'ගස වසා දමන්න', 'ta': 'கண் மூட', 'en': 'Close eyes'},
        {'si': 'ගස මිටි කරන්න', 'ta': 'கண் மின்னல்', 'en': 'Blink'}
      ]
    },
    {
      'si': 'කන්',
      'ta': 'காது',
      'en': 'Ear',
      'emoji': '👂',
      'actions': [
        {'si': 'කන් ඇහුම්කා', 'ta': 'காது கேட்க', 'en': 'Listen'},
        {'si': 'කන් ස්පර්ශ කරන්න', 'ta': 'காது தொடு', 'en': 'Touch ear'},
        {'si': 'ශබ්දය අසමින් සිටින්න', 'ta': 'காது ஒலி', 'en': 'Hear sound'}
      ]
    },
    {
      'si': 'නාසය',
      'ta': 'மூக்கு',
      'en': 'Nose',
      'emoji': '👃',
      'actions': [
        {'si': 'නාසයෙන් සුවඳ ගන්න', 'ta': 'மூக்கு வாசனை', 'en': 'Smell'},
        {'si': 'නාසය ස්පර්ශ කරන්න', 'ta': 'மூக்கு தொடு', 'en': 'Touch nose'},
        {'si': 'නාසය පිඩිසි කරන්න', 'ta': 'மூக்கு ఆయ్కా', 'en': 'Blow nose'}
      ]
    },
    {
      'si': 'දිව',
      'ta': 'பல்',
      'en': 'Tooth',
      'emoji': '😁',
      'actions': [
        {'si': 'දිව දෙකඩ', 'ta': 'பல் நொறുக', 'en': 'Bite'},
        {'si': 'දිව ස්පර්ශ කරන්න', 'ta': 'பல் தொடு', 'en': 'Touch tooth'},
        {'si': 'දිව සිනාසුනෙන්න', 'ta': 'பல் புன்னகை', 'en': 'Smile'}
      ]
    },
    {
      'si': 'වාචා',
      'ta': 'வாய்',
      'en': 'Mouth',
      'emoji': '👄',
      'actions': [
        {'si': 'වාචා විවෘත කරන්න', 'ta': 'வாய் திறக்க', 'en': 'Open mouth'},
        {'si': 'වාචා වසා දමන්න', 'ta': 'வாய் மூட', 'en': 'Close mouth'},
        {'si': 'කිම්බීම', 'ta': 'வாய் ஆசை', 'en': 'Yawn'}
      ]
    },
  ],
  'animals': [
    {
      'si': 'බඩවුන්',
      'ta': 'பசு',
      'en': 'Cow',
      'emoji': '🐄',
      'actions': [
        {'si': 'බඩවුන් මෙහෙවිම', 'ta': 'பசு கூப්பிடு', 'en': 'Call cow'},
        {'si': 'බඩවුන් ස්පර්ශ කරන්න', 'ta': 'பசு தொடு', 'en': 'Pet cow'},
        {'si': 'බඩවුන්ගේ හඬ', 'ta': 'பசு கறு', 'en': 'Cow sound'}
      ]
    },
    {
      'si': 'බිතුන්',
      'ta': 'நாய்',
      'en': 'Dog',
      'emoji': '🐕',
      'actions': [
        {'si': 'බිතුන් කෑ', 'ta': 'நாய் சாப்பிடு', 'en': 'Feed dog'},
        {'si': 'බිතුන් සේල', 'ta': 'நாய் விளையாடு', 'en': 'Play with dog'},
        {'si': 'බිතුන්ගේ හඬ', 'ta': 'நாய் குரல்', 'en': 'Dog bark'}
      ]
    },
    {
      'si': 'පූසා',
      'ta': 'பூனை',
      'en': 'Cat',
      'emoji': '🐱',
      'actions': [
        {'si': 'පූසා ස්පර්ශ කරන්න', 'ta': 'பூனை தொடு', 'en': 'Pet cat'},
        {'si': 'පූසා කෑ', 'ta': 'பூனை சாப்பிடு', 'en': 'Feed cat'},
        {'si': 'පූසාගේ හඬ', 'ta': 'பூனை குரல்', 'en': 'Cat sound'}
      ]
    },
    {
      'si': 'හිටිනැටිනා',
      'ta': 'பாம்பு',
      'en': 'Snake',
      'emoji': '🐍',
      'actions': [
        {'si': 'හිටිනැටිනා ගමනය', 'ta': 'பாம்பு நடை', 'en': 'Snake move'},
        {'si': 'හිටිනැටිනා ස්පර්ශ', 'ta': 'பாம்பு தொடு', 'en': 'Touch snake'},
        {'si': 'හිටිනැටිනා හඬ', 'ta': 'பாம்பு உரக்க', 'en': 'Snake hiss'}
      ]
    },
    {
      'si': 'වඩුරා',
      'ta': 'பட்டம்',
      'en': 'Bird',
      'emoji': '🐦',
      'actions': [
        {'si': 'වඩුරා ගිණිසීම', 'ta': 'பட்டம் பாடு', 'en': 'Bird sing'},
        {'si': 'වඩුරා කෑ', 'ta': 'பட்டம் சாப்பிடு', 'en': 'Feed bird'},
        {'si': 'වඩුරා පියාසර', 'ta': 'பட்டம் பறக்க', 'en': 'Bird fly'}
      ]
    },
    {
      'si': 'මසුන්',
      'ta': 'மீன்',
      'en': 'Fish',
      'emoji': '🐟',
      'actions': [
        {'si': 'මසුන් සඳහා ගිණිසි', 'ta': 'மீன் மදය', 'en': 'Fish swim'},
        {'si': 'මසුන් කෑ', 'ta': 'மீன் சாப்பிடு', 'en': 'Feed fish'},
        {'si': 'මසුන් ස්පර්ශ', 'ta': 'மீன் தொடு', 'en': 'Touch fish'}
      ]
    },
    {
      'si': 'ගජා',
      'ta': 'யானை',
      'en': 'Elephant',
      'emoji': '🐘',
      'actions': [
        {'si': 'ගජා ගමනය', 'ta': 'யானை நடை', 'en': 'Elephant walk'},
        {'si': 'ගජා ස්පර්ශ', 'ta': 'யானை தொடு', 'en': 'Touch elephant'},
        {'si': 'ගජා කෑ', 'ta': 'யானை சாப்பிடு', 'en': 'Feed elephant'}
      ]
    },
    {
      'si': 'සිංහ',
      'ta': 'சிங்கம்',
      'en': 'Lion',
      'emoji': '🦁',
      'actions': [
        {'si': 'සිංහ ගර්ජනය', 'ta': 'சிங்கம் கர்ர', 'en': 'Lion roar'},
        {'si': 'සිංහ ගමනය', 'ta': 'சிங்கம் நடை', 'en': 'Lion walk'},
        {'si': 'සිංහ කෑ', 'ta': 'சிங்கம் சாப்பிடு', 'en': 'Lion eat'}
      ]
    },
  ],
  'fruits_vegatables': [
    {
      'si': 'ඇපල්',
      'ta': 'ஆப்பிள்',
      'en': 'Apple',
      'emoji': '🍎',
      'actions': [
        {'si': 'ඇපල් කනවා', 'ta': 'ஆப்பிள் சாப்பிடு', 'en': 'Eat apple'},
        {'si': 'ඇපල් ස්පර්ශ', 'ta': 'ஆப்பிள் தொடு', 'en': 'Touch apple'},
        {'si': 'ඇපල් සුවඳ', 'ta': 'ஆப்பிள் வாசனை', 'en': 'Smell apple'}
      ]
    },
    {
      'si': 'අරවි',
      'ta': 'ஆரஞ்சு',
      'en': 'Orange',
      'emoji': '🍊',
      'actions': [
        {'si': 'අරවි කනවා', 'ta': 'ஆரஞ்சு சாப்பிடு', 'en': 'Eat orange'},
        {'si': 'අරවි ස්පර්ශ', 'ta': 'ஆரஞ்சு தொடு', 'en': 'Touch orange'},
        {'si': 'අරවි කෙටි', 'ta': 'ஆரஞ்சு தோல்', 'en': 'Peel orange'}
      ]
    },
    {
      'si': 'ගම්මිරිස',
      'ta': 'வாழை',
      'en': 'Banana',
      'emoji': '🍌',
      'actions': [
        {'si': 'ගම්මිරිස කනවා', 'ta': 'வாழை சாப்பிடு', 'en': 'Eat banana'},
        {'si': 'ගම්මිරිස කෙටි', 'ta': 'வாழை உரிக்க', 'en': 'Peel banana'},
        {'si': 'ගම්මිරිස ස්පර්ශ', 'ta': 'வாழை தொடு', 'en': 'Touch banana'}
      ]
    },
    {
      'si': 'ස්ට්‍රෝබෙරි',
      'ta': 'ஸ்ட்ராபெரி',
      'en': 'Strawberry',
      'emoji': '🍓',
      'actions': [
        {
          'si': 'ස්ට්‍රෝබෙරි කනවා',
          'ta': 'ஸ்ட்ராபெரி சாப்பிடு',
          'en': 'Eat strawberry'
        },
        {
          'si': 'ස්ට්‍රෝබෙරි ස්පර්ශ',
          'ta': 'ஸ்ட்ராபெரி தொடு',
          'en': 'Touch strawberry'
        },
        {
          'si': 'ස්ට්‍රෝබෙරි සුවඳ',
          'ta': 'ஸ்ட්ராபெரி வாசனை',
          'en': 'Smell strawberry'
        }
      ]
    },
    {
      'si': 'ගෙඩි',
      'ta': 'திராட்சை',
      'en': 'Grape',
      'emoji': '🍇',
      'actions': [
        {'si': 'ගෙඩි කනවා', 'ta': 'திராட்சை சாப்பிடு', 'en': 'Eat grape'},
        {'si': 'ගෙඩි ස්පර්ශ', 'ta': 'திராட்சை தொடு', 'en': 'Touch grape'},
        {'si': 'ගෙඩි බිම්බ', 'ta': 'திராட்சை பீयெ', 'en': 'Grape juice'}
      ]
    },
    {
      'si': 'පයිනැපල්',
      'ta': 'அன்னாசி',
      'en': 'Pineapple',
      'emoji': '🍍',
      'actions': [
        {
          'si': 'පයිනැපල් කනවා',
          'ta': 'அன்னாசி சாப்பிடு',
          'en': 'Eat pineapple'
        },
        {'si': 'පයිනැපල් කෙටි', 'ta': 'அன்னாசி உரிக்க', 'en': 'Peel pineapple'},
        {'si': 'පයිනැපල් ස්පර්ශ', 'ta': 'அன்னாசி தொடு', 'en': 'Touch pineapple'}
      ]
    },
    {
      'si': 'වට්ටක්කා',
      'ta': 'தர்பூசணி',
      'en': 'Watermelon',
      'emoji': '🍉',
      'actions': [
        {
          'si': 'වට්ටක්කා කනවා',
          'ta': 'தர்பூசணி சாப்பிடு',
          'en': 'Eat watermelon'
        },
        {'si': 'වට්ටක්කා කෙටි', 'ta': 'தர்பூசணி வெட்ட', 'en': 'Cut watermelon'},
        {
          'si': 'වට්ටක්කා ස්පර්ශ',
          'ta': 'தர்பூசணி தொடு',
          'en': 'Touch watermelon'
        }
      ]
    },
    {
      'si': 'කජු',
      'ta': 'கேரட்',
      'en': 'Carrot',
      'emoji': '🥕',
      'actions': [
        {'si': 'කජු කනවා', 'ta': 'கேரட் சாப்பிடு', 'en': 'Eat carrot'},
        {'si': 'කජු ස්පර්ශ', 'ta': 'கேரட் தொடு', 'en': 'Touch carrot'},
        {'si': 'කජු පිසින්න', 'ta': 'கேரட் சமை', 'en': 'Cook carrot'}
      ]
    },
  ],
  'objects': [
    {
      'si': 'පොත',
      'ta': 'புத்தகம்',
      'en': 'Book',
      'emoji': '📚',
      'actions': [
        {'si': 'පොත කියවන්න', 'ta': 'புத்தகம் படி', 'en': 'Read book'},
        {'si': 'පොත විවෘත කරන්න', 'ta': 'புத்தகம் திறக்க', 'en': 'Open book'},
        {'si': 'පොත ස්පර්ශ', 'ta': 'புத்தகம் தொடு', 'en': 'Touch book'}
      ]
    },
    {
      'si': 'බෝල',
      'ta': 'பந்து',
      'en': 'Ball',
      'emoji': '⚽',
      'actions': [
        {'si': 'බෝල වලිතට දමන්න', 'ta': 'பந்து தூக்க', 'en': 'Throw ball'},
        {'si': 'බෝල පිඩිසි කරන්න', 'ta': 'பந்து உருட்ட', 'en': 'Roll ball'},
        {'si': 'බෝල ස්පර්ශ', 'ta': 'பந்து தொடு', 'en': 'Touch ball'}
      ]
    },
    {
      'si': 'කුඩ',
      'ta': 'குடை',
      'en': 'Cup',
      'emoji': '☕',
      'actions': [
        {'si': 'කුඩ අරින්න', 'ta': 'குடை பிடி', 'en': 'Hold cup'},
        {'si': 'කුඩ පිරින්න', 'ta': 'குடை நிரப்பு', 'en': 'Fill cup'},
        {'si': 'කුඩ හීස්තින්න', 'ta': 'குடை குடிக்க', 'en': 'Drink from cup'}
      ]
    },
    {
      'si': 'පැන්සල්',
      'ta': 'பென்சில்',
      'en': 'Pencil',
      'emoji': '✏️',
      'actions': [
        {'si': 'පැන්සල් අරින්න', 'ta': 'பென்சில் பிடி', 'en': 'Hold pencil'},
        {'si': 'පැන්සල් ලිවීම', 'ta': 'பென்சில் எழுது', 'en': 'Write pencil'},
        {'si': 'පැන්සල් ස්පර්ශ', 'ta': 'பென்சில் தொடு', 'en': 'Touch pencil'}
      ]
    },
    {
      'si': 'තුවාලුකු',
      'ta': 'மெழுகுவர்த்தி',
      'en': 'Candle',
      'emoji': '🕯️',
      'actions': [
        {
          'si': 'තුවාලුකු ඉතුණු',
          'ta': 'மெழுகுவர்த்தி எரி',
          'en': 'Light candle'
        },
        {
          'si': 'තුවාලුකු ස්පර්ශ',
          'ta': 'மெழுகுவர்த்தி தொடு',
          'en': 'Touch candle'
        },
        {'si': 'තුවාලුකු තලාඩු', 'ta': 'மெழுகுவர்த்தி அணை', 'en': 'Blow candle'}
      ]
    },
    {
      'si': 'දිලි',
      'ta': 'விளக்கு',
      'en': 'Light',
      'emoji': '💡',
      'actions': [
        {'si': 'දිලි දල්', 'ta': 'விளக்கு இயக்க', 'en': 'Turn on light'},
        {'si': 'දිලි බඳ', 'ta': 'விளக்கு அணை', 'en': 'Turn off light'},
        {'si': 'දිලි ස්පර්ශ', 'ta': 'விளக்கு தொடு', 'en': 'Touch light'}
      ]
    },
    {
      'si': 'සිටුවම්',
      'ta': 'நாற்காலி',
      'en': 'Chair',
      'emoji': '🪑',
      'actions': [
        {'si': 'සිටුවම් ගිණිසි', 'ta': 'நாற்காலி உட்கார', 'en': 'Sit on chair'},
        {'si': 'සිටුවම් ස්පර්ශ', 'ta': 'நாற்காலி தொடு', 'en': 'Touch chair'},
        {'si': 'සිටුවම් ගිණිසි නැතිවීම', 'ta': 'நாற்காலி எழு', 'en': 'Stand up'}
      ]
    },
    {
      'si': 'මේස',
      'ta': 'மேज்',
      'en': 'Table',
      'emoji': '🪑',
      'actions': [
        {'si': 'මේස උඩින් දැමුණු', 'ta': 'மேज் மீது வை', 'en': 'Put on table'},
        {'si': 'මේස ස්පර්ශ', 'ta': 'மேज் தொடு', 'en': 'Touch table'},
        {'si': 'මේස ගිණිසි', 'ta': 'மேज் খાও', 'en': 'Eat at table'}
      ]
    },
  ],
  'colors_numbers': [
    {
      'si': 'රතු',
      'ta': 'சிவப்பு',
      'en': 'Red',
      'emoji': '🔴',
      'actions': [
        {'si': 'රතු දෙකිතින්න', 'ta': 'சிவப்பு காட்ட', 'en': 'Show red'},
        {'si': 'රතු සොයන්න', 'ta': 'சிவப்பு தேடு', 'en': 'Find red'},
        {'si': 'රතු ස්පර්ශ', 'ta': 'சிவப்பு தொடு', 'en': 'Touch red'}
      ]
    },
    {
      'si': 'නිල්',
      'ta': 'நீலம்',
      'en': 'Blue',
      'emoji': '🔵',
      'actions': [
        {'si': 'නිල් දෙකිතින්න', 'ta': 'நீலம் காட்ட', 'en': 'Show blue'},
        {'si': 'නිල් සොයන්න', 'ta': 'நீலம் தேடு', 'en': 'Find blue'},
        {'si': 'නිල් ස්පර්ශ', 'ta': 'நீலம் தொடு', 'en': 'Touch blue'}
      ]
    },
    {
      'si': 'කහ',
      'ta': 'மஞ்சள்',
      'en': 'Yellow',
      'emoji': '🟡',
      'actions': [
        {'si': 'කහ දෙකිතින්න', 'ta': 'மஞ்சள் காட்ட', 'en': 'Show yellow'},
        {'si': 'කහ සොයන්න', 'ta': 'மஞ்சள் தேடு', 'en': 'Find yellow'},
        {'si': 'කහ ස්පර්ශ', 'ta': 'மஞ்சள் தொடு', 'en': 'Touch yellow'}
      ]
    },
    {
      'si': 'ගිරවෙ',
      'ta': 'பச்சை',
      'en': 'Green',
      'emoji': '🟢',
      'actions': [
        {'si': 'ගිරවෙ දෙකිතින්න', 'ta': 'பச்சை காட்ட', 'en': 'Show green'},
        {'si': 'ගිරවෙ සොයන්න', 'ta': 'பச்சை தேடு', 'en': 'Find green'},
        {'si': 'ගිරවෙ ස්පර්ශ', 'ta': 'பச்சை தொடு', 'en': 'Touch green'}
      ]
    },
    {
      'si': 'එක',
      'ta': 'ஒன்று',
      'en': 'One',
      'emoji': '1️⃣',
      'actions': [
        {'si': 'එක ගණන් කරන්න', 'ta': 'ஒன்று எண்ண', 'en': 'Count one'},
        {'si': 'එක දෙකිතින්න', 'ta': 'ஒன்று காட்ட', 'en': 'Show one'},
        {'si': 'එක ස්පර්ශ', 'ta': 'ஒன்று தொடு', 'en': 'Touch one'}
      ]
    },
    {
      'si': 'දෙක',
      'ta': 'இரண்டு',
      'en': 'Two',
      'emoji': '2️⃣',
      'actions': [
        {'si': 'දෙක ගණන් කරන්න', 'ta': 'இரண்டு எண்ண', 'en': 'Count two'},
        {'si': 'දෙක දෙකිතින්න', 'ta': 'இரண்டு காட்ட', 'en': 'Show two'},
        {'si': 'දෙක ස්පර්ශ', 'ta': 'இரண்டு தொடு', 'en': 'Touch two'}
      ]
    },
    {
      'si': 'තුන',
      'ta': 'மூன்று',
      'en': 'Three',
      'emoji': '3️⃣',
      'actions': [
        {'si': 'තුන ගණන් කරන්න', 'ta': 'மூன்று எண்ண', 'en': 'Count three'},
        {'si': 'තුන දෙකිතින්න', 'ta': 'மூன்று காட்ட', 'en': 'Show three'},
        {'si': 'තුන ස්පර්ශ', 'ta': 'மூன்று தொடு', 'en': 'Touch three'}
      ]
    },
    {
      'si': 'හතර',
      'ta': 'நான்கு',
      'en': 'Four',
      'emoji': '4️⃣',
      'actions': [
        {'si': 'හතර ගණන් කරන්න', 'ta': 'நான்கு எண்ண', 'en': 'Count four'},
        {'si': 'හතර දෙකිතින්න', 'ta': 'நான்கு காட்ட', 'en': 'Show four'},
        {'si': 'හතර ස්පර්ශ', 'ta': 'நான்கு தொடு', 'en': 'Touch four'}
      ]
    },
  ],
  'feelings': [
    {
      'si': 'සතුටුයි',
      'ta': 'மகிழ்ச்சி',
      'en': 'Happy',
      'emoji': '😊',
      'actions': [
        {
          'si': 'සතුටු සිනාසුනෙන්න',
          'ta': 'மகிழ்ச்சி சிரி',
          'en': 'Smile happy'
        },
        {'si': 'සතුටු නැටුම', 'ta': 'மகிழ்ச்சி நாட்டம்', 'en': 'Dance happy'},
        {'si': 'සතුටු කෝරස්', 'ta': 'மகிழ்ச்சி ஆட', 'en': 'Cheer happy'}
      ]
    },
    {
      'si': 'දුකයි',
      'ta': 'சோகம்',
      'en': 'Sad',
      'emoji': '😢',
      'actions': [
        {'si': 'දුක් කඳුළු', 'ta': 'சோகம் கண்ணீர்', 'en': 'Cry sad'},
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
        {'si': 'කෝපී හඬ', 'ta': 'கோபம் குரல்', 'en': 'Angry shout'},
        {'si': 'කෝපී මුහුණ', 'ta': 'கோபம் முகம்', 'en': 'Angry face'},
        {'si': 'කෝපී පහරදීම', 'ta': 'கோபம் அடி', 'en': 'Angry hit'}
      ]
    },
    {
      'si': 'බයයි',
      'ta': 'பயம்',
      'en': 'Scared',
      'emoji': '😨',
      'actions': [
        {'si': 'බිය මුහුණ', 'ta': 'பயம் முகம்', 'en': 'Scared face'},
        {'si': 'බිය සිතින්න', 'ta': 'பயம் நினை', 'en': 'Think scared'},
        {'si': 'බිය සඳහා ගිණිසි', 'ta': 'பயம் உட்கார', 'en': 'Sit scared'}
      ]
    },
    {
      'si': 'තෙහෙට්ටුයි',
      'ta': 'சோர்வு',
      'en': 'Tired',
      'emoji': '😴',
      'actions': [
        {'si': 'තෙහෙට්ටු නිදුණු', 'ta': 'சோர்வு உறங்கு', 'en': 'Sleep tired'},
        {'si': 'තෙහෙට්ටු මුහුණ', 'ta': 'சோர்வு முகம்', 'en': 'Tired face'},
        {'si': 'තෙහෙට්ටු ඇස', 'ta': 'சோர்வு கண்', 'en': 'Tired eyes'}
      ]
    },
    {
      'si': 'ශීතල',
      'ta': 'குளிர்',
      'en': 'Cold',
      'emoji': '❄️',
      'actions': [
        {'si': 'ශීතල කම්පනය', 'ta': 'குளிர் நடுங்கு', 'en': 'Shiver cold'},
        {'si': 'ශීතල මුහුණ', 'ta': 'குளிர் முகம்', 'en': 'Cold face'},
        {'si': 'ශීතල ඇඳුම්', 'ta': 'குளிர் உடை', 'en': 'Cold clothes'}
      ]
    },
    {
      'si': 'උණුසුම්',
      'ta': 'வெப்பம்',
      'en': 'Hot',
      'emoji': '🔥',
      'actions': [
        {'si': 'උණුසුම් හෙම්බරුම', 'ta': 'வெப்பம் எழுச్', 'en': 'Sweat hot'},
        {'si': 'උණුසුම් පරිවර්තනය', 'ta': 'வெப்பம் ওಹ್', 'en': 'Hot face'},
        {'si': 'උණුසුම් ජලය', 'ta': 'வெப்பம் தண்ணீர்', 'en': 'Hot water'}
      ]
    },
    {
      'si': 'කර්පණ්‍යතා',
      'ta': 'பசி',
      'en': 'Hungry',
      'emoji': '😋',
      'actions': [
        {'si': 'පසුබිම කෑම', 'ta': 'பசி சாப்பிடு', 'en': 'Eat hungry'},
        {'si': 'පසුබිම මුහුණ', 'ta': 'பசி முகம்', 'en': 'Hungry face'},
        {'si': 'පසුබිම විකාශ', 'ta': 'பசி வாயேறு', 'en': 'Hungry mouth'}
      ]
    },
  ],
  'actions': [
    {
      'si': 'දිවීම',
      'ta': 'ஓடுதல்',
      'en': 'Running',
      'emoji': '🏃',
      'actions': [
        {'si': 'වේගයෙන් දිවීම', 'ta': 'வேகமாக ஓடு', 'en': 'Run fast'},
        {'si': 'මන්දයෙන් දිවීම', 'ta': '천천히ஓடு', 'en': 'Run slow'},
        {'si': 'දිවීම නවතින්න', 'ta': 'ஓட நிறுத்து', 'en': 'Stop running'}
      ]
    },
    {
      'si': 'ගමනය',
      'ta': 'நடத்தல்',
      'en': 'Walking',
      'emoji': '🚶',
      'actions': [
        {'si': 'නිකඩ ගමනයි', 'ta': 'வேகமாக நட', 'en': 'Walk fast'},
        {'si': 'මන්දයෙන් ගමනයි', 'ta': '천천히நட', 'en': 'Walk slow'},
        {'si': 'ගමනයි නිතිතම්', 'ta': 'नदินिर्थfixed', 'en': 'Walk forward'}
      ]
    },
    {
      'si': 'පැනීම',
      'ta': 'கூதல்',
      'en': 'Jumping',
      'emoji': '🤸',
      'actions': [
        {'si': 'පැනීම උඩින්', 'ta': 'மேலே குதி', 'en': 'Jump up'},
        {'si': 'පැනීම ඉතිරි', 'ta': 'முன்பு குதி', 'en': 'Jump forward'},
        {'si': 'පැනීම පැත්ത', 'ta': 'பக்கம் குதி', 'en': 'Jump side'}
      ]
    },
    {
      'si': 'නැටීම',
      'ta': 'நாட்டம்',
      'en': 'Dancing',
      'emoji': '💃',
      'actions': [
        {'si': 'වේගයෙන් නැටීම', 'ta': 'வேகமாக நாட்டம்', 'en': 'Dance fast'},
        {'si': 'මන්දයෙන් නැටීම', 'ta': '천천히நாட்டம்', 'en': 'Dance slow'},
        {'si': 'නැටුම් නිතිතම්', 'ta': 'नृत्य बंद', 'en': 'Stop dancing'}
      ]
    },
    {
      'si': 'ටිකෙරුම',
      'ta': 'விளையாட்டு',
      'en': 'Playing',
      'emoji': '🎮',
      'actions': [
        {
          'si': 'ටිකෙරුම ශුරු කරන්න',
          'ta': 'விளையாட்டு शुरु',
          'en': 'Start playing'
        },
        {
          'si': 'ටිකෙරුම නිතිතම්',
          'ta': 'விளையாட்டு நிறுத்து',
          'en': 'Stop playing'
        },
        {'si': 'ටිකෙරුම එක්ස', 'ta': 'விளையாட்டு மாற', 'en': 'Change game'}
      ]
    },
    {
      'si': 'කිම්බීම',
      'ta': 'ஏறுதல்',
      'en': 'Climbing',
      'emoji': '🧗',
      'actions': [
        {'si': 'කිම්බීම ඉතිරි', 'ta': 'ஏறு மேலே', 'en': 'Climb up'},
        {'si': 'කිම්බීම පහළ', 'ta': 'ஏறு கீழே', 'en': 'Climb down'},
        {'si': 'කිම්බීම නිතිතම්', 'ta': 'ஏறு நிறுத்து', 'en': 'Stop climbing'}
      ]
    },
    {
      'si': 'පිම්පීම',
      'ta': 'நீச்சல்',
      'en': 'Swimming',
      'emoji': '🏊',
      'actions': [
        {'si': 'පිම්පීම ශීඩ්', 'ta': 'நீச்சல் வேகமாக', 'en': 'Swim fast'},
        {'si': 'පිම්පීම සෙමින්', 'ta': 'நீச்சல்천천히', 'en': 'Swim slow'},
        {
          'si': 'පිම්පීම නිතිතම්',
          'ta': 'நீச்சல் நிறுத்து',
          'en': 'Stop swimming'
        }
      ]
    },
    {
      'si': 'නින්දා යෑම',
      'ta': 'உறங்குதல்',
      'en': 'Sleeping',
      'emoji': '😴',
      'actions': [
        {'si': 'නිදුණු යෑම', 'ta': 'உறங்கு போ', 'en': 'Go sleep'},
        {'si': 'නිදුණු ඔසවා දිනුම්', 'ta': 'உறங்கு வெளி', 'en': 'Wake up'},
        {'si': 'නිදුණු ගවේසන', 'ta': 'உறங்கு பேச', 'en': 'Sleep talk'}
      ]
    },
  ],
  'sounds_music': [
    {
      'si': 'සිංගීතය',
      'ta': 'இசை',
      'en': 'Music',
      'emoji': '🎵',
      'actions': [
        {'si': 'සිංගීතය ඇහුම්කා', 'ta': 'இசை கேட்க', 'en': 'Listen music'},
        {'si': 'සිංගීතය ඉතිරි කරන්න', 'ta': 'இசை ஆட', 'en': 'Play music'},
        {'si': 'සිංගීතය නිතිතම්', 'ta': 'இசை நிறுத්து', 'en': 'Stop music'}
      ]
    },
    {
      'si': 'ගිටාරය',
      'ta': 'கிதார்',
      'en': 'Guitar',
      'emoji': '🎸',
      'actions': [
        {'si': 'ගිටාරය ඉතිරි කරන්න', 'ta': 'கிதார் வாசி', 'en': 'Play guitar'},
        {'si': 'ගිටාරය ස්පර්ශ', 'ta': 'கிதார் தொடு', 'en': 'Touch guitar'},
        {'si': 'ගිටාරය සිතුම', 'ta': 'கிதார் குண', 'en': 'Strum guitar'}
      ]
    },
    {
      'si': 'පියානෝ',
      'ta': 'பியானோ',
      'en': 'Piano',
      'emoji': '🎹',
      'actions': [
        {'si': 'පියානෝ ඉතිරි කරන්න', 'ta': 'பியானோ வாசி', 'en': 'Play piano'},
        {'si': 'පියානෝ යතුර', 'ta': 'பியानो விசை', 'en': 'Piano key'},
        {'si': 'පියානෝ සිතුම', 'ta': 'பியานो ஓசை', 'en': 'Piano sound'}
      ]
    },
    {
      'si': 'බෙල්ල',
      'ta': 'மணி',
      'en': 'Bell',
      'emoji': '🔔',
      'actions': [
        {'si': 'බෙල්ල දෝ කරන්න', 'ta': 'மணி அடு', 'en': 'Ring bell'},
        {'si': 'බෙල්ල ස්පර්ශ', 'ta': 'மணி தொடு', 'en': 'Touch bell'},
        {'si': 'බෙල්ල හඬ', 'ta': 'மணி ஓசை', 'en': 'Bell sound'}
      ]
    },
    {
      'si': 'ඩ‍ගම්',
      'ta': 'முரளி',
      'en': 'Drum',
      'emoji': '🥁',
      'actions': [
        {'si': 'ඩ‍ගම් පහර', 'ta': 'முரளி அடு', 'en': 'Beat drum'},
        {'si': 'ඩ‍ගම් ස්පර්ශ', 'ta': 'முரளி தொடு', 'en': 'Touch drum'},
        {'si': 'ඩ‍ගම් වේගයි', 'ta': 'முரளி வேகம்', 'en': 'Drum fast'}
      ]
    },
    {
      'si': 'සීතීම',
      'ta': 'விசிறி',
      'en': 'Whistle',
      'emoji': '🎶',
      'actions': [
        {'si': 'සීතීම ඇසුම', 'ta': 'விசிறி ஓசை', 'en': 'Whistle sound'},
        {'si': 'සීතීම ඉතිරි කරන්න', 'ta': 'விசிறி வாசி', 'en': 'Whistle tune'},
        {'si': 'සීතීම නිතිතම්', 'ta': 'விசிறி நிறுத్', 'en': 'Stop whistle'}
      ]
    },
    {
      'si': 'කතා නොවීම',
      'ta': 'மௌனம்',
      'en': 'Silence',
      'emoji': '🤐',
      'actions': [
        {'si': 'නිහඩ සිතින්න', 'ta': 'மௌனம் சிந்த', 'en': 'Think silent'},
        {'si': 'නිහඩ ඉතිරි කරන්න', 'ta': 'மௌனம் பேசு', 'en': 'Be silent'},
        {'si': 'නිහඩ අසුම', 'ta': 'மௌனம் கேட்க', 'en': 'Hear silence'}
      ]
    },
    {
      'si': 'හඬ',
      'ta': 'சப்தம்',
      'en': 'Sound',
      'emoji': '🔊',
      'actions': [
        {'si': 'හඬ තෝරා ගනින්න', 'ta': 'சப்தம் தேர்வு', 'en': 'Choose sound'},
        {'si': 'හඬ වඩුතරම්', 'ta': 'சப்தம் உயர', 'en': 'Louder sound'},
        {'si': 'හඬ මන්දයි', 'ta': 'சப்தம் குறை', 'en': 'Quieter sound'}
      ]
    },
  ],
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
