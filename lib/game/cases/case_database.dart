import '../../data/models/case_model.dart';
import '../../data/models/character_model.dart';
import '../../data/models/evidence_model.dart';

class CaseDatabase {
  static List<GameCase> cases = [
    // ========== القضية 1: جريمة في خان الخليلي ==========
    GameCase(
      id: 'case_001',
      title: 'جريمة في خان الخليلي',
      description: 'تاجر عتيق يُقتل في متجره بخان الخليلي. خنجر فرعوني مختفٍ هو سلاح الجريمة.',
      location: 'خان الخليلي، القاهرة',
      timeOfCrime: '11:30 مساءً، 15 ديسمبر',
      victimName: 'الحاج محمود العطار',
      victimProfile: 'تاجر عتيق، 65 عاماً، معروف بأمانته وثرائه',
      mafiaCount: 2,
      narrativeAmbiguity: 'الجميع يريد الخنجر الفرعوني النادر، لكن من قتل من أجله؟',
      suspects: [
        Character(
          id: 'char_001', name: 'كريم العطار', age: 35, occupation: 'طبيب أسنان',
          personalityTraits: ['طموح', 'مديون', 'عصبي'],
          background: 'نجل القتيل. يعاني من ديون القمار.',
          hiddenMotivation: 'يريد بيع المقتنيات الثمينة لسداد ديونه',
          connectionToVictim: 'نجل القتيل',
        ),
        Character(
          id: 'char_002', name: 'نادية عبدالرحمن', age: 42, occupation: 'مرشدة سياحية',
          personalityTraits: ['ذكية', 'متلاعبة', 'غامضة'],
          background: 'تعمل مع القتيل في تجارة الآثار.',
          hiddenMotivation: 'تعمل لصالح عصابة تهريب آثار دولية',
          connectionToVictim: 'شريكة في تجارة الآثار',
        ),
        Character(
          id: 'char_003', name: 'عماد السيد', age: 50, occupation: 'ضابط شرطة متقاعد',
          personalityTraits: ['صارم', 'منتقم', 'مكتئب'],
          background: 'متقاعد مبكراً بسبب قضية فساد. القتيل شهد ضده.',
          hiddenMotivation: 'يسعى للانتقام ممن دمر مسيرته المهنية',
          connectionToVictim: 'خصم قديم',
        ),
        Character(
          id: 'char_004', name: 'سميحة إبراهيم', age: 28, occupation: 'بائعة عطور',
          personalityTraits: ['جميلة', 'ماكرة', 'يائسة'],
          background: 'كانت تعمل خادمة في بيت القتيل. طُردت قبل شهر.',
          hiddenMotivation: 'تعرف سراً خطيراً عن ماضي القتيل',
          connectionToVictim: 'خادمة سابقة',
        ),
      ],
      evidenceCards: [
        Evidence(id: 'ev_001', title: 'بصمات على الخنجر', description: 'بصمات أصابع حديثة على الخنجر الفرعوني المختفي.', suspiciousHint: 'البصمات تعود لشخص يعاني من حروق في اليد اليمنى', implicatedSuspects: ['char_002', 'char_004'], type: EvidenceType.forensic, visualTheme: 'fingerprint'),
        Evidence(id: 'ev_002', title: 'رسالة تهديد', description: 'رسالة بخط اليد تقول: "ستدفع ثمن خيانتك". وجدت في درج القتيل.', suspiciousHint: 'الخط يشبه خط أحد المقربين', implicatedSuspects: ['char_003', 'char_001'], type: EvidenceType.physical, visualTheme: 'letter'),
        Evidence(id: 'ev_003', title: 'مكالمة منتصف الليل', description: 'سجلات الهاتف تظهر مكالمة من القتيل إلى شخص غامض قبل موته بدقائق.', suspiciousHint: 'الرقم يعود لهاتف غير مسجل', implicatedSuspects: ['char_002', 'char_005'], type: EvidenceType.digital, visualTheme: 'phone'),
        Evidence(id: 'ev_004', title: 'عطر غريب', description: 'رائحة عطر نسائي قوية في مسرح الجريمة.', suspiciousHint: 'العطر مستورد وغير متوفر في مصر', implicatedSuspects: ['char_004', 'char_002'], type: EvidenceType.circumstantial, visualTheme: 'perfume'),
      ],
    ),

    // ========== القضية 2: لغز النيل ==========
    GameCase(
      id: 'case_002',
      title: 'لغز النيل',
      description: 'عالمة آثار مصرية تغرق في ظروف غامضة أثناء رحلة نيلية. الجميع يدعي أنها مجرد حادث.',
      location: 'نيل القاهرة، مركب سياحي',
      timeOfCrime: '2:15 صباحاً، 3 يناير',
      victimName: 'د. منى الشاذلي',
      victimProfile: 'عالمة آثار، 40 عاماً، اكتشفت مقبرة فرعونية قبل أيام',
      mafiaCount: 2,
      narrativeAmbiguity: 'الكل لديه سبب لكراهية منى. لكن من دفعها للنيل؟',
      suspects: [
        Character(id: 'char_005', name: 'د. شريف علام', age: 45, occupation: 'رئيس البعثة الأثرية', personalityTraits: ['غيور', 'منافس', 'متسلط'], background: 'زميل القتيلة. سرق أبحاثها سابقاً.', hiddenMotivation: 'اكتشاف المقبرة كان يجب أن يكون باسمه هو', connectionToVictim: 'رئيسها المباشر'),
        Character(id: 'char_006', name: 'لبنى رأفت', age: 32, occupation: 'صحفية استقصائية', personalityTraits: ['جريئة', 'فضولية', 'متهورة'], background: 'كانت تحقق في فساد بوزارة الآثار.', hiddenMotivation: 'القتيلة كانت مصدرها السري', connectionToVictim: 'مصدر صحفي'),
        Character(id: 'char_007', name: 'محروس الغريب', age: 55, occupation: 'مرشد سياحي', personalityTraits: ['ماكر', 'انتهازي', 'خطير'], background: 'يعمل في تهريب الآثار الصغيرة.', hiddenMotivation: 'القتيلة هددته بكشف سره', connectionToVictim: 'دليلها في الرحلة'),
        Character(id: 'char_008', name: 'د. هالة مختار', age: 38, occupation: 'طبيبة شرعية', personalityTraits: ['باردة', 'دقيقة', 'غامضة'], background: 'صديقة قديمة للقتيلة. بينهما خلاف قديم.', hiddenMotivation: 'القتيلة كانت تعرف سراً طبياً خطيراً عنها', connectionToVictim: 'صديقة قديمة'),
        Character(id: 'char_009', name: 'ريان المصري', age: 29, occupation: 'مصور تحت الماء', personalityTraits: ['مغامر', 'مدمن مخدرات', 'مضطرب'], background: 'كان يصور فيلماً وثائقياً عن الرحلة.', hiddenMotivation: 'مدين بمبلغ كبير لتجار مخدرات', connectionToVictim: 'مصور الرحلة'),
      ],
      evidenceCards: [
        Evidence(id: 'ev_005', title: 'كاميرا تحت الماء', description: 'كاميرا ريان التقطت صورة لشخص يقف خلف د. منى قبل سقوطها.', suspiciousHint: 'الصورة ضبابية لكن تظهر ساعة يد مميزة', implicatedSuspects: ['char_009', 'char_005'], type: EvidenceType.digital, visualTheme: 'camera'),
        Evidence(id: 'ev_006', title: 'تقرير طبي مفقود', description: 'صفحات ممزقة من التقرير الطبي للقتيلة.', suspiciousHint: 'الصفحات تخص تحاليل سموم لم تُجرَ بعد', implicatedSuspects: ['char_008'], type: EvidenceType.physical, visualTheme: 'report'),
        Evidence(id: 'ev_007', title: 'مكالمة تهديد', description: 'رسالة صوتية على هاتف القتيلة: "اسكتي وإلا..."', suspiciousHint: 'الصوت مشوَّه لكنه ذكر اسم المركب', implicatedSuspects: ['char_006', 'char_007'], type: EvidenceType.digital, visualTheme: 'voice'),
        Evidence(id: 'ev_008', title: 'قطعة أثرية صغيرة', description: 'تميمة فرعونية صغيرة وجدت على ظهر المركب.', suspiciousHint: 'التميمة مسروقة من المقبرة المكتشفة حديثاً', implicatedSuspects: ['char_007', 'char_005'], type: EvidenceType.physical, visualTheme: 'artifact'),
      ],
    ),

    // ========== القضية 3: دم في الأقصر ==========
    GameCase(
      id: 'case_003',
      title: 'دم في الأقصر',
      description: 'مدير فندق شهير بالأقصر يُقتل في المعبد الفرعوني. جريمة طقسية غامضة.',
      location: 'معبد الكرنك، الأقصر',
      timeOfCrime: 'منتصف الليل، 20 فبراير',
      victimName: 'فؤاد عبدالظاهر',
      victimProfile: 'مدير فندق 5 نجوم، 52 عاماً، مرتبط بعصابات الآثار',
      mafiaCount: 2,
      narrativeAmbiguity: 'الدم على جدران المعبد. الرسالة مكتوبة بالهيروغليفية.',
      suspects: [
        Character(id: 'char_010', name: 'عزة فهمي', age: 36, occupation: 'مصممة مجوهرات', personalityTraits: ['مبدعة', 'انتقامية', 'مهووسة'], background: 'زوجة القتيل السابقة. تكرهه بشدة.', hiddenMotivation: 'القتيل سرق تصميماً نادراً منها وحقق ثروة', connectionToVictim: 'زوجة سابقة'),
        Character(id: 'char_011', name: 'شادي النوبي', age: 44, occupation: 'مرمم آثار', personalityTraits: ['هادئ', 'مثقف', 'مزدوج الشخصية'], background: 'يعمل في ترميم معابد الأقصر.', hiddenMotivation: 'يكتشف أن القتيل يبيع آثاراً مزيفة للسائحين', connectionToVictim: 'مرمم في الفندق'),
        Character(id: 'char_012', name: 'ناهد سليمان', age: 31, occupation: 'راقصة شرقية', personalityTraits: ['فاتنة', 'مخادعة', 'ذكية'], background: 'تعمل في الفندق. القتيل كان معجباً بها.', hiddenMotivation: 'تبحث عن والدها الحقيقي الذي تعتقد أنه القتيل', connectionToVictim: 'موظفة في الفندق'),
        Character(id: 'char_013', name: 'مصباح الديب', age: 58, occupation: 'تاجر تحف', personalityTraits: ['ثري', 'نافذ', 'قاسٍ'], background: 'منافس القتيل في تجارة التحف.', hiddenMotivation: 'القتيل كان يبتزه بمستندات تدينه', connectionToVictim: 'منافس تجاري'),
      ],
      evidenceCards: [
        Evidence(id: 'ev_009', title: 'نقش دموي', description: 'كتابة هيروغليفية بالدم على الجدار: "الخائن يموت".', suspiciousHint: 'النقش به أخطاء لغوية تدل أن كاتبه ليس خبيراً', implicatedSuspects: ['char_011', 'char_010'], type: EvidenceType.forensic, visualTheme: 'hieroglyphics'),
        Evidence(id: 'ev_010', title: 'قطعة مجوهرات', description: 'حلق ذهبي فرعوني وجد بجانب الجثة.', suspiciousHint: 'الحلق من تصميم عزة فهمي الحديث', implicatedSuspects: ['char_010'], type: EvidenceType.physical, visualTheme: 'jewelry'),
        Evidence(id: 'ev_011', title: 'رسالة نصية', description: 'آخر رسالة على هاتف القتيل: "الليلة، منتصف الليل، المعبد."', suspiciousHint: 'المرسِل مجهول لكن الرقم يبدأ بـ 010', implicatedSuspects: ['char_012', 'char_013'], type: EvidenceType.digital, visualTheme: 'message'),
        Evidence(id: 'ev_012', title: 'بدلة رقص', description: 'طرحة رقص شرقي وجدت معلقة على تمثال.', suspiciousHint: 'الطرحة معطرة بعطر فرنسي نادر', implicatedSuspects: ['char_012'], type: EvidenceType.physical, visualTheme: 'scarf'),
      ],
    ),

    // ========== القضية 4: سم في المولد (4 لاعبين) ==========
    GameCase(
      id: 'case_004',
      title: 'سم في المولد',
      description: 'شيخ طريقة صوفية يموت مسموماً خلال مولد السيدة زينب. الكل أكل من نفس القِدر.',
      location: 'مولد السيدة زينب، القاهرة',
      timeOfCrime: '9:00 مساءً، 10 رمضان',
      victimName: 'الشيخ جاد الحق',
      victimProfile: 'شيخ طريقة صوفية، 70 عاماً، له أتباع كثر وأعداء أكثر',
      mafiaCount: 1,
      narrativeAmbiguity: 'السم في الطعام. لكن الجميع أكل. لماذا مات الشيخ وحده؟',
      suspects: [
        Character(id: 'char_014', name: 'سيد البنا', age: 45, occupation: 'طباخ المولد', personalityTraits: ['ماهر', 'غيور', 'سريع الغضب'], background: 'طباخ مشهور في الموالد. كان تلميذ الشيخ.', hiddenMotivation: 'الشيخ طرده من الطريقة منذ سنوات', connectionToVictim: 'تلميذ سابق'),
        Character(id: 'char_015', name: 'الحاجة زينب', age: 65, occupation: 'قارئة فنجان', personalityTraits: ['روحانية', 'غامضة', 'مسيطرة'], background: 'أشهر عرافة في الحي. الشيخ حاربها.', hiddenMotivation: 'الشيخ فضح ممارساتها أمام الناس', connectionToVictim: 'خصمة روحية'),
        Character(id: 'char_016', name: 'محمود الدرش', age: 38, occupation: 'منشد ديني', personalityTraits: ['موهوب', 'مدمن', 'منافق'], background: 'منشد الطريقة. يعاني من إدمان الأفيون.', hiddenMotivation: 'الشيخ كان سيفضح سره ويطرده من الطريقة', connectionToVictim: 'منشد الطريقة'),
        Character(id: 'char_017', name: 'فاطمة النبوية', age: 42, occupation: 'بائعة حلوى المولد', personalityTraits: ['طيبة', 'مضحية', 'يائسة'], background: 'أرملة وأم لخمسة أطفال. الشيخ وعدها بالزواج.', hiddenMotivation: 'الشيخ أخلف وعده وطردها من بيته', connectionToVictim: 'خادمة سابقة وخطيبة سابقة'),
      ],
      evidenceCards: [
        Evidence(id: 'ev_013', title: 'بقايا السم', description: 'مادة سامة في طبق الشيخ فقط. ليس في القِدر العام.', suspiciousHint: 'السم وُضع بعد توزيع الطعام', implicatedSuspects: ['char_014', 'char_017'], type: EvidenceType.forensic, visualTheme: 'poison'),
        Evidence(id: 'ev_014', title: 'فنجان قهوة', description: 'فنجان قهوة بجانب الشيخ عليه طلاسم غريبة.', suspiciousHint: 'الطلاسم نفسها التي تستخدمها الحاجة زينب', implicatedSuspects: ['char_015'], type: EvidenceType.physical, visualTheme: 'coffee_cup'),
        Evidence(id: 'ev_015', title: 'زجاجة أفيون', description: 'زجاجة أفيون فارغة في مرحاض المسجد القريب.', suspiciousHint: 'الزجاجة من النوع الذي يتعاطاه المنشد', implicatedSuspects: ['char_016'], type: EvidenceType.physical, visualTheme: 'bottle'),
        Evidence(id: 'ev_016', title: 'دفتر تبرعات', description: 'دفتر تبرعات المقام به تلاعب في الأرقام.', suspiciousHint: 'الخط يشبه خط الحارس عبد ربه', implicatedSuspects: ['char_015'], type: EvidenceType.physical, visualTheme: 'notebook'),
      ],
    ),

    // ========== القضية 5: قصر البارون ==========
    GameCase(
      id: 'case_005',
      title: 'قصر البارون',
      description: 'مليونير مصري يُقتل في قصره الأسطوري. كل الحاضرين من النخبة.',
      location: 'قصر البارون إمبان، مصر الجديدة',
      timeOfCrime: 'منتصف الليل، 31 ديسمبر',
      victimName: 'إبراهيم هانم',
      victimProfile: 'مليونير عقارات، 60 عاماً، لُقب ببارون القاهرة',
      mafiaCount: 2,
      narrativeAmbiguity: 'الجميع يريد ثروته. الكل لديه سر يخفيه.',
      suspects: [
        Character(id: 'char_018', name: 'ناهد هانم', age: 28, occupation: 'عارضة أزياء', personalityTraits: ['جميلة', 'مدللة', 'خائفة'], background: 'الزوجة الثالثة للمليونير. تصغره بـ 32 عاماً.', hiddenMotivation: 'اكتشفت أنه سيطلقها بدون تعويض', connectionToVictim: 'زوجة'),
        Character(id: 'char_019', name: 'عادل هانم', age: 35, occupation: 'رجل أعمال فاشل', personalityTraits: ['حسود', 'كسول', 'عدواني'], background: 'الابن الأكبر من الزوجة الأولى.', hiddenMotivation: 'الأب قطع عنه المصروف منذ عام', connectionToVictim: 'ابن'),
        Character(id: 'char_020', name: 'صفية رشدان', age: 55, occupation: 'مديرة أعمال', personalityTraits: ['وفية', 'منظمة', 'مريرة'], background: 'مديرة أعمال القتيل منذ 25 عاماً.', hiddenMotivation: 'القتيل وعدها بنسبة من الشركة ثم تراجع', connectionToVictim: 'مديرة أعمال'),
        Character(id: 'char_021', name: 'فريد كامل', age: 50, occupation: 'محامي العائلة', personalityTraits: ['لامع', 'انتهازي', 'لعوب'], background: 'محامي العائلة. على علاقة سرية بناهد.', hiddenMotivation: 'يخطط للهرب مع الزوجة والأموال', connectionToVictim: 'محامي شخصي'),
        Character(id: 'char_022', name: 'جلال حمدي', age: 62, occupation: 'شريك تجاري', personalityTraits: ['مخضرم', 'جشع', 'خطر'], background: 'شريك القتيل في مشروع ضخم.', hiddenMotivation: 'القتيل كان سيبلغ عنه بتهم فساد', connectionToVictim: 'شريك'),
      ],
      evidenceCards: [
        Evidence(id: 'ev_017', title: 'وصية مزورة', description: 'وصية مزورة تظهر توقيع القتيل. الورثة الجدد: ناهد وفريد.', suspiciousHint: 'الوصية كتبت قبل الحادث بيوم واحد', implicatedSuspects: ['char_018', 'char_021'], type: EvidenceType.physical, visualTheme: 'will'),
        Evidence(id: 'ev_018', title: 'رسائل حب', description: 'رسائل غرامية بين ناهد وفريد على هاتف مسروق.', suspiciousHint: 'الرسائل تخطط لـ"التخلص من العجوز"', implicatedSuspects: ['char_018', 'char_021'], type: EvidenceType.digital, visualTheme: 'love_letters'),
        Evidence(id: 'ev_019', title: 'كسر في الخزنة', description: 'الخزنة مفتوحة. 2 مليون دولار مختفية.', suspiciousHint: 'الخزنة فُتحت بالبصمة بعد الوفاة', implicatedSuspects: ['char_019', 'char_020'], type: EvidenceType.physical, visualTheme: 'safe'),
        Evidence(id: 'ev_020', title: 'بلاغ فساد', description: 'ملف فساد جاهز للتقديم ضد جلال حمدي.', suspiciousHint: 'الملف كان في مكتب القتيل وعليه بصمات جلال', implicatedSuspects: ['char_022'], type: EvidenceType.physical, visualTheme: 'file'),
        Evidence(id: 'ev_021', title: 'شهادة الخادم', description: 'الخادم سمع القتيل يقول: "أنت؟ ماذا تفعل هنا؟" قبل الصرخة.', suspiciousHint: 'القاتل شخص يعرفه القتيل جيداً', implicatedSuspects: ['char_018', 'char_019', 'char_020', 'char_021', 'char_022'], type: EvidenceType.testimony, visualTheme: 'servant'),
      ],
    ),
  ];
}

// ✅ دوال اختيار القضية حسب عدد اللاعبين
class CaseSelector {
  static List<GameCase> getCasesForPlayerCount(int playerCount) {
    return CaseDatabase.cases.where((c) {
      if (playerCount <= 4) return c.suspects.length <= 4;
      if (playerCount <= 6) return c.suspects.length <= 5;
      return true;
    }).toList();
  }

  static GameCase selectRandomCase(int playerCount, {List<String>? excludeIds}) {
    var available = getCasesForPlayerCount(playerCount);
    if (excludeIds != null && excludeIds.isNotEmpty) {
      available = available.where((c) => !excludeIds.contains(c.id)).toList();
    }
    if (available.isEmpty) {
      available = getCasesForPlayerCount(playerCount);
    }
    return available[DateTime.now().millisecondsSinceEpoch % available.length];
  }
}