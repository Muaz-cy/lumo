import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lumo'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your home, back home.'**
  String get splashTagline;

  /// No description provided for @onboardingHeadline1.
  ///
  /// In en, this message translates to:
  /// **'Discover\ndifferently.'**
  String get onboardingHeadline1;

  /// No description provided for @onboardingSubheadline1.
  ///
  /// In en, this message translates to:
  /// **'Curated Ethiopian real estate,\npersonalized for the diaspora.'**
  String get onboardingSubheadline1;

  /// No description provided for @onboardingHeadline2.
  ///
  /// In en, this message translates to:
  /// **'Invest with\nconfidence.'**
  String get onboardingHeadline2;

  /// No description provided for @onboardingSubheadline2.
  ///
  /// In en, this message translates to:
  /// **'Transparent pricing.\nVerified listings. No surprises.'**
  String get onboardingSubheadline2;

  /// No description provided for @onboardingHeadline3.
  ///
  /// In en, this message translates to:
  /// **'Your trusted\nadvisor.'**
  String get onboardingHeadline3;

  /// No description provided for @onboardingSubheadline3.
  ///
  /// In en, this message translates to:
  /// **'We don\'t just list properties.\nWe guide your decision.'**
  String get onboardingSubheadline3;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUp;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Browse without account'**
  String get authContinueAsGuest;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authSignInWithGoogle;

  /// No description provided for @authSignInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authSignInWithApple;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover today.'**
  String get homeDiscover;

  /// No description provided for @homeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get homeFeatured;

  /// No description provided for @homeTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending now'**
  String get homeTrending;

  /// No description provided for @homeNewListings.
  ///
  /// In en, this message translates to:
  /// **'New listings'**
  String get homeNewListings;

  /// No description provided for @homeForYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get homeForYou;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeNeighborhoods.
  ///
  /// In en, this message translates to:
  /// **'Explore neighborhoods'**
  String get homeNeighborhoods;

  /// No description provided for @homeInvestmentPicks.
  ///
  /// In en, this message translates to:
  /// **'Investment picks'**
  String get homeInvestmentPicks;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search properties, neighborhoods...'**
  String get searchPlaceholder;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get searchTrending;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different neighborhood or price range.'**
  String get searchNoResultsHint;

  /// No description provided for @propertyBedrooms.
  ///
  /// In en, this message translates to:
  /// **'{count} bed'**
  String propertyBedrooms(int count);

  /// No description provided for @propertyBathrooms.
  ///
  /// In en, this message translates to:
  /// **'{count} bath'**
  String propertyBathrooms(int count);

  /// No description provided for @propertyArea.
  ///
  /// In en, this message translates to:
  /// **'{area} m²'**
  String propertyArea(double area);

  /// No description provided for @propertyVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get propertyVerified;

  /// No description provided for @propertyFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get propertyFeatured;

  /// No description provided for @propertyNewListing.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get propertyNewListing;

  /// No description provided for @propertyForSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get propertyForSale;

  /// No description provided for @propertyForRent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get propertyForRent;

  /// No description provided for @propertyTitleDeedConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Title deed confirmed'**
  String get propertyTitleDeedConfirmed;

  /// No description provided for @propertyTeamVerified.
  ///
  /// In en, this message translates to:
  /// **'Lumo verified'**
  String get propertyTeamVerified;

  /// No description provided for @propertyAbout.
  ///
  /// In en, this message translates to:
  /// **'About this property'**
  String get propertyAbout;

  /// No description provided for @propertyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get propertyFeatures;

  /// No description provided for @propertyLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get propertyLocation;

  /// No description provided for @propertyNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get propertyNeighborhood;

  /// No description provided for @propertyInvestmentInsight.
  ///
  /// In en, this message translates to:
  /// **'Investment insight'**
  String get propertyInvestmentInsight;

  /// No description provided for @propertyPriceHistory.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get propertyPriceHistory;

  /// No description provided for @propertyNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby properties'**
  String get propertyNearby;

  /// No description provided for @propertyContact.
  ///
  /// In en, this message translates to:
  /// **'Express interest'**
  String get propertyContact;

  /// No description provided for @propertySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get propertySave;

  /// No description provided for @propertySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get propertySaved;

  /// No description provided for @propertyShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get propertyShare;

  /// No description provided for @propertyFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor {number}'**
  String propertyFloor(int number);

  /// No description provided for @propertyYearBuilt.
  ///
  /// In en, this message translates to:
  /// **'Built {year}'**
  String propertyYearBuilt(int year);

  /// No description provided for @priceETB.
  ///
  /// In en, this message translates to:
  /// **'ETB {amount}'**
  String priceETB(String amount);

  /// No description provided for @priceUSD.
  ///
  /// In en, this message translates to:
  /// **'≈ USD {amount}'**
  String priceUSD(String amount);

  /// No description provided for @pricePerSqm.
  ///
  /// In en, this message translates to:
  /// **'ETB {amount}/m²'**
  String pricePerSqm(String amount);

  /// No description provided for @exchangeRateUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rate updated {time}'**
  String exchangeRateUpdated(String time);

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get savedEmpty;

  /// No description provided for @savedEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Properties you save will appear here.'**
  String get savedEmptyHint;

  /// No description provided for @savedStartExploring.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get savedStartExploring;

  /// No description provided for @inquiryTitle.
  ///
  /// In en, this message translates to:
  /// **'Express Interest'**
  String get inquiryTitle;

  /// No description provided for @inquirySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our team will reach out within 24 hours.'**
  String get inquirySubtitle;

  /// No description provided for @inquiryName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get inquiryName;

  /// No description provided for @inquiryPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get inquiryPhone;

  /// No description provided for @inquiryMessage.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get inquiryMessage;

  /// No description provided for @inquiryMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your timeline, budget, or any questions.'**
  String get inquiryMessageHint;

  /// No description provided for @inquirySubmit.
  ///
  /// In en, this message translates to:
  /// **'Send inquiry'**
  String get inquirySubmit;

  /// No description provided for @inquirySuccess.
  ///
  /// In en, this message translates to:
  /// **'Inquiry sent'**
  String get inquirySuccess;

  /// No description provided for @inquirySuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Our team will contact you within 24 hours.'**
  String get inquirySuccessMessage;

  /// No description provided for @inquiryMyInquiries.
  ///
  /// In en, this message translates to:
  /// **'My inquiries'**
  String get inquiryMyInquiries;

  /// No description provided for @neighborhoodAbout.
  ///
  /// In en, this message translates to:
  /// **'About {name}'**
  String neighborhoodAbout(String name);

  /// No description provided for @neighborhoodGrowth.
  ///
  /// In en, this message translates to:
  /// **'{percent}% growth'**
  String neighborhoodGrowth(String percent);

  /// No description provided for @neighborhoodAvgPrice.
  ///
  /// In en, this message translates to:
  /// **'Avg. ETB {price}/m²'**
  String neighborhoodAvgPrice(String price);

  /// No description provided for @brokerSubmitListing.
  ///
  /// In en, this message translates to:
  /// **'Submit a listing'**
  String get brokerSubmitListing;

  /// No description provided for @brokerMyListings.
  ///
  /// In en, this message translates to:
  /// **'My listings'**
  String get brokerMyListings;

  /// No description provided for @brokerStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get brokerStatusPending;

  /// No description provided for @brokerStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get brokerStatusApproved;

  /// No description provided for @brokerStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get brokerStatusRejected;

  /// No description provided for @brokerReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Our team reviews listings within 3 business days. We may visit the property in person.'**
  String get brokerReviewNote;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccount;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved properties'**
  String get profileSaved;

  /// No description provided for @profileInquiries.
  ///
  /// In en, this message translates to:
  /// **'My inquiries'**
  String get profileInquiries;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileBrokerPortal.
  ///
  /// In en, this message translates to:
  /// **'Broker portal'**
  String get profileBrokerPortal;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency display'**
  String get settingsCurrency;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get settingsTerms;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Lumo'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you about your saved properties and inquiries.'**
  String get notificationsEmptyHint;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorRetry;

  /// No description provided for @errorGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get errorGoBack;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errorNotFound;

  /// No description provided for @errorNotFoundHint.
  ///
  /// In en, this message translates to:
  /// **'This property may no longer be available.'**
  String get errorNotFoundHint;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get filterPropertyType;

  /// No description provided for @filterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get filterPriceRange;

  /// No description provided for @filterBedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get filterBedrooms;

  /// No description provided for @filterBathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get filterBathrooms;

  /// No description provided for @filterAreaRange.
  ///
  /// In en, this message translates to:
  /// **'Area (m²)'**
  String get filterAreaRange;

  /// No description provided for @filterNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get filterNeighborhood;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filterApply;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @filterResults.
  ///
  /// In en, this message translates to:
  /// **'{count} properties'**
  String filterResults(int count);

  /// No description provided for @typeApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get typeApartment;

  /// No description provided for @typeVilla.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get typeVilla;

  /// No description provided for @typeCommercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get typeCommercial;

  /// No description provided for @typeLand.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get typeLand;

  /// No description provided for @typeOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get typeOffice;

  /// No description provided for @typeWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get typeWarehouse;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navInquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get navInquiries;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
