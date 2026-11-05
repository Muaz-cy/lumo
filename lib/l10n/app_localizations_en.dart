// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lumo';

  @override
  String get splashTagline => 'Your home, back home.';

  @override
  String get onboardingHeadline1 => 'Discover\ndifferently.';

  @override
  String get onboardingSubheadline1 =>
      'Curated Ethiopian real estate,\npersonalized for the diaspora.';

  @override
  String get onboardingHeadline2 => 'Invest with\nconfidence.';

  @override
  String get onboardingSubheadline2 =>
      'Transparent pricing.\nVerified listings. No surprises.';

  @override
  String get onboardingHeadline3 => 'Your trusted\nadvisor.';

  @override
  String get onboardingSubheadline3 =>
      'We don\'t just list properties.\nWe guide your decision.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Create account';

  @override
  String get authEmail => 'Email address';

  @override
  String get authPassword => 'Password';

  @override
  String get authFullName => 'Full name';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authContinueAsGuest => 'Browse without account';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authSignInWithGoogle => 'Continue with Google';

  @override
  String get authSignInWithApple => 'Continue with Apple';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeDiscover => 'Discover today.';

  @override
  String get homeFeatured => 'Featured';

  @override
  String get homeTrending => 'Trending now';

  @override
  String get homeNewListings => 'New listings';

  @override
  String get homeForYou => 'For you';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNeighborhoods => 'Explore neighborhoods';

  @override
  String get homeInvestmentPicks => 'Investment picks';

  @override
  String get searchPlaceholder => 'Search properties, neighborhoods...';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchTrending => 'Trending';

  @override
  String get searchNoResults => 'No properties found';

  @override
  String get searchNoResultsHint =>
      'Try a different neighborhood or price range.';

  @override
  String propertyBedrooms(int count) {
    return '$count bed';
  }

  @override
  String propertyBathrooms(int count) {
    return '$count bath';
  }

  @override
  String propertyArea(double area) {
    return '$area m²';
  }

  @override
  String get propertyVerified => 'Verified';

  @override
  String get propertyFeatured => 'Featured';

  @override
  String get propertyNewListing => 'New';

  @override
  String get propertyForSale => 'For Sale';

  @override
  String get propertyForRent => 'For Rent';

  @override
  String get propertyTitleDeedConfirmed => 'Title deed confirmed';

  @override
  String get propertyTeamVerified => 'Lumo verified';

  @override
  String get propertyAbout => 'About this property';

  @override
  String get propertyFeatures => 'Features';

  @override
  String get propertyLocation => 'Location';

  @override
  String get propertyNeighborhood => 'Neighborhood';

  @override
  String get propertyInvestmentInsight => 'Investment insight';

  @override
  String get propertyPriceHistory => 'Price history';

  @override
  String get propertyNearby => 'Nearby properties';

  @override
  String get propertyContact => 'Express interest';

  @override
  String get propertySave => 'Save';

  @override
  String get propertySaved => 'Saved';

  @override
  String get propertyShare => 'Share';

  @override
  String propertyFloor(int number) {
    return 'Floor $number';
  }

  @override
  String propertyYearBuilt(int year) {
    return 'Built $year';
  }

  @override
  String priceETB(String amount) {
    return 'ETB $amount';
  }

  @override
  String priceUSD(String amount) {
    return '≈ USD $amount';
  }

  @override
  String pricePerSqm(String amount) {
    return 'ETB $amount/m²';
  }

  @override
  String exchangeRateUpdated(String time) {
    return 'Rate updated $time';
  }

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedEmpty => 'Nothing saved yet';

  @override
  String get savedEmptyHint => 'Properties you save will appear here.';

  @override
  String get savedStartExploring => 'Start exploring';

  @override
  String get inquiryTitle => 'Express Interest';

  @override
  String get inquirySubtitle => 'Our team will reach out within 24 hours.';

  @override
  String get inquiryName => 'Your name';

  @override
  String get inquiryPhone => 'Phone number';

  @override
  String get inquiryMessage => 'Message (optional)';

  @override
  String get inquiryMessageHint =>
      'Tell us about your timeline, budget, or any questions.';

  @override
  String get inquirySubmit => 'Send inquiry';

  @override
  String get inquirySuccess => 'Inquiry sent';

  @override
  String get inquirySuccessMessage =>
      'Our team will contact you within 24 hours.';

  @override
  String get inquiryMyInquiries => 'My inquiries';

  @override
  String neighborhoodAbout(String name) {
    return 'About $name';
  }

  @override
  String neighborhoodGrowth(String percent) {
    return '$percent% growth';
  }

  @override
  String neighborhoodAvgPrice(String price) {
    return 'Avg. ETB $price/m²';
  }

  @override
  String get brokerSubmitListing => 'Submit a listing';

  @override
  String get brokerMyListings => 'My listings';

  @override
  String get brokerStatusPending => 'Under review';

  @override
  String get brokerStatusApproved => 'Live';

  @override
  String get brokerStatusRejected => 'Not approved';

  @override
  String get brokerReviewNote =>
      'Our team reviews listings within 3 business days. We may visit the property in person.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileSaved => 'Saved properties';

  @override
  String get profileInquiries => 'My inquiries';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileBrokerPortal => 'Broker portal';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsCurrency => 'Currency display';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of service';

  @override
  String get settingsAbout => 'About Lumo';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'You\'re all caught up';

  @override
  String get notificationsEmptyHint =>
      'We\'ll notify you about your saved properties and inquiries.';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get errorNetwork => 'Check your connection and try again.';

  @override
  String get errorRetry => 'Try again';

  @override
  String get errorGoBack => 'Go back';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorNotFoundHint => 'This property may no longer be available.';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterPropertyType => 'Property type';

  @override
  String get filterPriceRange => 'Price range';

  @override
  String get filterBedrooms => 'Bedrooms';

  @override
  String get filterBathrooms => 'Bathrooms';

  @override
  String get filterAreaRange => 'Area (m²)';

  @override
  String get filterNeighborhood => 'Neighborhood';

  @override
  String get filterApply => 'Apply filters';

  @override
  String get filterReset => 'Reset';

  @override
  String filterResults(int count) {
    return '$count properties';
  }

  @override
  String get typeApartment => 'Apartment';

  @override
  String get typeVilla => 'Villa';

  @override
  String get typeCommercial => 'Commercial';

  @override
  String get typeLand => 'Land';

  @override
  String get typeOffice => 'Office';

  @override
  String get typeWarehouse => 'Warehouse';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navSaved => 'Saved';

  @override
  String get navInquiries => 'Inquiries';

  @override
  String get navProfile => 'Profile';
}
