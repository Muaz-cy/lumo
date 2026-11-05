// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appName => 'ሉሞ';

  @override
  String get splashTagline => 'ቤትዎ፣ ወደ ቤት።';

  @override
  String get onboardingHeadline1 => 'በተለየ መንገድ\nያግኙ።';

  @override
  String get onboardingSubheadline1 => 'ለዲያስፖራ የተዘጋጀ\nየኢትዮጵያ ሪል እስቴት።';

  @override
  String get onboardingHeadline2 => 'በእምነት\nይዋዕሉ።';

  @override
  String get onboardingSubheadline2 =>
      'ግልጽ ዋጋ።\nተረጋግጦ የቀረበ ዝርዝር። ምንም አስደንጋጭ ነገር የለም።';

  @override
  String get onboardingHeadline3 => 'የሚታመን\nአማካሪዎ።';

  @override
  String get onboardingSubheadline3 => 'ቤቶችን ብቻ አንዘረዝርም።\nውሳኔዎን እንመራለን።';

  @override
  String get onboardingContinue => 'ቀጥል';

  @override
  String get onboardingGetStarted => 'ጀምር';

  @override
  String get onboardingSkip => 'ዝለል';

  @override
  String get authSignIn => 'ግባ';

  @override
  String get authSignUp => 'መለያ ፍጠር';

  @override
  String get authEmail => 'የኢሜይል አድራሻ';

  @override
  String get authPassword => 'የይለፍ ቃል';

  @override
  String get authFullName => 'ሙሉ ስም';

  @override
  String get authForgotPassword => 'የይለፍ ቃል ረሳህ?';

  @override
  String get authNoAccount => 'መለያ የለህም?';

  @override
  String get authHaveAccount => 'መለያ አለህ?';

  @override
  String get authContinueAsGuest => 'ያለ መለያ ዳስስ';

  @override
  String get authOrContinueWith => 'ወይም በዚህ ቀጥል';

  @override
  String get authSignInWithGoogle => 'በGoogle ቀጥል';

  @override
  String get authSignInWithApple => 'በApple ቀጥል';

  @override
  String get homeGreetingMorning => 'እንደምን አደርክ';

  @override
  String get homeGreetingAfternoon => 'እንደምን ዋልክ';

  @override
  String get homeGreetingEvening => 'እንደምን አመሸህ';

  @override
  String get homeDiscover => 'ዛሬ ያግኙ።';

  @override
  String get homeFeatured => 'ተለይቶ የቀረበ';

  @override
  String get homeTrending => 'አሁን ተፈላጊ';

  @override
  String get homeNewListings => 'አዲስ ዝርዝሮች';

  @override
  String get homeForYou => 'ለእርስዎ';

  @override
  String get homeSeeAll => 'ሁሉንም ይመልከቱ';

  @override
  String get homeNeighborhoods => 'አካባቢዎችን ያስሱ';

  @override
  String get homeInvestmentPicks => 'የኢንቨስትመንት ምርጫዎች';

  @override
  String get searchPlaceholder => 'ቤቶችን፣ አካባቢዎችን ይፈልጉ...';

  @override
  String get searchRecent => 'የቅርብ ጊዜ ፍለጋዎች';

  @override
  String get searchTrending => 'ተፈላጊ';

  @override
  String get searchNoResults => 'ምንም ቤት አልተገኘም';

  @override
  String get searchNoResultsHint => 'ሌላ አካባቢ ወይም የዋጋ ክልል ይሞክሩ።';

  @override
  String propertyBedrooms(int count) {
    return '$count መኝታ';
  }

  @override
  String propertyBathrooms(int count) {
    return '$count መታጠቢያ';
  }

  @override
  String propertyArea(double area) {
    return '$area ካሬ ሜትር';
  }

  @override
  String get propertyVerified => 'ተረጋግጧል';

  @override
  String get propertyFeatured => 'ተለይቶ የቀረበ';

  @override
  String get propertyNewListing => 'አዲስ';

  @override
  String get propertyForSale => 'ለሽያጭ';

  @override
  String get propertyForRent => 'ለኪራይ';

  @override
  String get propertyTitleDeedConfirmed => 'የቤት ሰነድ ተረጋግጧል';

  @override
  String get propertyTeamVerified => 'በሉሞ ተረጋግጧል';

  @override
  String get propertyAbout => 'ስለ ቤቱ';

  @override
  String get propertyFeatures => 'ባህሪያት';

  @override
  String get propertyLocation => 'አካባቢ';

  @override
  String get propertyNeighborhood => 'ሰፈር';

  @override
  String get propertyInvestmentInsight => 'የኢንቨስትመንት ትንታኔ';

  @override
  String get propertyPriceHistory => 'የዋጋ ታሪክ';

  @override
  String get propertyNearby => 'አቅራቢያ ያሉ ቤቶች';

  @override
  String get propertyContact => 'ፍላጎት ያሳዩ';

  @override
  String get propertySave => 'አስቀምጥ';

  @override
  String get propertySaved => 'ተቀምጧል';

  @override
  String get propertyShare => 'አጋራ';

  @override
  String propertyFloor(int number) {
    return 'ፎቅ $number';
  }

  @override
  String propertyYearBuilt(int year) {
    return 'የተሰራው $year';
  }

  @override
  String priceETB(String amount) {
    return 'ብር $amount';
  }

  @override
  String priceUSD(String amount) {
    return '≈ ዶላር $amount';
  }

  @override
  String pricePerSqm(String amount) {
    return 'ብር $amount/ካሬ ሜ';
  }

  @override
  String exchangeRateUpdated(String time) {
    return 'ዋጋ የተዘመነው $time';
  }

  @override
  String get savedTitle => 'የተቀመጡ';

  @override
  String get savedEmpty => 'ምንም አልተቀመጠም';

  @override
  String get savedEmptyHint => 'የሚቀምጧቸው ቤቶች እዚህ ይታያሉ።';

  @override
  String get savedStartExploring => 'ማሰስ ጀምር';

  @override
  String get inquiryTitle => 'ፍላጎት ያሳዩ';

  @override
  String get inquirySubtitle => 'ቡድናችን በ24 ሰዓት ውስጥ ያነጋግርዎታል።';

  @override
  String get inquiryName => 'ስምዎ';

  @override
  String get inquiryPhone => 'ስልክ ቁጥር';

  @override
  String get inquiryMessage => 'መልዕክት (አማራጭ)';

  @override
  String get inquiryMessageHint => 'ስለ ጊዜዎ፣ በጀትዎ ወይም ጥያቄዎ ይንገሩን።';

  @override
  String get inquirySubmit => 'ጥያቄ ላክ';

  @override
  String get inquirySuccess => 'ጥያቄ ተልኳል';

  @override
  String get inquirySuccessMessage => 'ቡድናችን በ24 ሰዓት ውስጥ ያነጋግርዎታል።';

  @override
  String get inquiryMyInquiries => 'ጥያቄዎቼ';

  @override
  String neighborhoodAbout(String name) {
    return 'ስለ $name';
  }

  @override
  String neighborhoodGrowth(String percent) {
    return '$percent% እድገት';
  }

  @override
  String neighborhoodAvgPrice(String price) {
    return 'አማካይ ብር $price/ካሬ ሜ';
  }

  @override
  String get brokerSubmitListing => 'ዝርዝር አስገባ';

  @override
  String get brokerMyListings => 'ዝርዝሮቼ';

  @override
  String get brokerStatusPending => 'በግምገማ ላይ';

  @override
  String get brokerStatusApproved => 'ቀጥሎ ነው';

  @override
  String get brokerStatusRejected => 'አልተፈቀደም';

  @override
  String get brokerReviewNote =>
      'ቡድናችን ዝርዝሮችን በ3 የስራ ቀናት ውስጥ ይገመግማል። ቦታውን በአካል ሊጎበኝ ይችላል።';

  @override
  String get profileTitle => 'መገለጫ';

  @override
  String get profileAccount => 'መለያ';

  @override
  String get profileSaved => 'የተቀመጡ ቤቶች';

  @override
  String get profileInquiries => 'ጥያቄዎቼ';

  @override
  String get profileSettings => 'ቅንብሮች';

  @override
  String get profileSignOut => 'ውጣ';

  @override
  String get profileBrokerPortal => 'የደላላ ፖርታል';

  @override
  String get settingsTitle => 'ቅንብሮች';

  @override
  String get settingsLanguage => 'ቋንቋ';

  @override
  String get settingsTheme => 'መልክ';

  @override
  String get settingsThemeLight => 'ብርሃን';

  @override
  String get settingsThemeDark => 'ጨለማ';

  @override
  String get settingsThemeSystem => 'ስርዓት';

  @override
  String get settingsCurrency => 'የምንዛሬ ማሳያ';

  @override
  String get settingsNotifications => 'ማሳወቂያዎች';

  @override
  String get settingsPrivacy => 'የግላዊነት ፖሊሲ';

  @override
  String get settingsTerms => 'የአገልግሎት ውሎች';

  @override
  String get settingsAbout => 'ስለ ሉሞ';

  @override
  String settingsVersion(String version) {
    return 'ስሪት $version';
  }

  @override
  String get notificationsTitle => 'ማሳወቂያዎች';

  @override
  String get notificationsEmpty => 'ሁሉም ተነቦዋል';

  @override
  String get notificationsEmptyHint => 'ስለ የተቀመጡ ቤቶችዎ እና ጥያቄዎችዎ እናሳውቅዎታለን።';

  @override
  String get errorGeneric => 'ችግር ተፈጥሯል።';

  @override
  String get errorNetwork => 'ግንኙነትዎን ያረጋግጡ እና እንደገና ይሞክሩ።';

  @override
  String get errorRetry => 'እንደገና ሞክር';

  @override
  String get errorGoBack => 'ተመለስ';

  @override
  String get errorNotFound => 'አልተገኘም';

  @override
  String get errorNotFoundHint => 'ይህ ቤት ከእንግዲህ ላይኖር ይችላል።';

  @override
  String get filterTitle => 'አጣራ';

  @override
  String get filterPropertyType => 'የቤት አይነት';

  @override
  String get filterPriceRange => 'የዋጋ ክልል';

  @override
  String get filterBedrooms => 'መኝታ ቤቶች';

  @override
  String get filterBathrooms => 'መታጠቢያ ቤቶች';

  @override
  String get filterAreaRange => 'ስፋት (ካሬ ሜ)';

  @override
  String get filterNeighborhood => 'ሰፈር';

  @override
  String get filterApply => 'አጣሪዎችን ተግብር';

  @override
  String get filterReset => 'ዳግም አስጀምር';

  @override
  String filterResults(int count) {
    return '$count ቤቶች';
  }

  @override
  String get typeApartment => 'አፓርትመንት';

  @override
  String get typeVilla => 'ቪላ';

  @override
  String get typeCommercial => 'ንግድ';

  @override
  String get typeLand => 'መሬት';

  @override
  String get typeOffice => 'ቢሮ';

  @override
  String get typeWarehouse => 'መጋዘን';

  @override
  String get navHome => 'ዋና';

  @override
  String get navSearch => 'ፈልግ';

  @override
  String get navSaved => 'የተቀመጡ';

  @override
  String get navInquiries => 'ጥያቄዎች';

  @override
  String get navProfile => 'መገለጫ';
}
