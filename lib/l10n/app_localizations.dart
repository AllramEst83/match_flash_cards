import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

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
    Locale('en'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Match Flash Cards'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSwedish.
  ///
  /// In en, this message translates to:
  /// **'Svenska'**
  String get languageSwedish;

  /// No description provided for @myDecks.
  ///
  /// In en, this message translates to:
  /// **'My Decks'**
  String get myDecks;

  /// No description provided for @noDecks.
  ///
  /// In en, this message translates to:
  /// **'No decks yet!\nTap \"New deck\" to make your first one.'**
  String get noDecks;

  /// No description provided for @newDeck.
  ///
  /// In en, this message translates to:
  /// **'New deck'**
  String get newDeck;

  /// No description provided for @nameYourDeck.
  ///
  /// In en, this message translates to:
  /// **'Name your deck'**
  String get nameYourDeck;

  /// No description provided for @deckNameHint.
  ///
  /// In en, this message translates to:
  /// **'Animals, Spelling week 3, ...'**
  String get deckNameHint;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @renameDeck.
  ///
  /// In en, this message translates to:
  /// **'Rename deck'**
  String get renameDeck;

  /// No description provided for @deleteDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteDeckTitle(String name);

  /// No description provided for @deleteDeckMessage.
  ///
  /// In en, this message translates to:
  /// **'All of its cards will be deleted too.'**
  String get deleteDeckMessage;

  /// No description provided for @cardCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card} other{{count} cards}}'**
  String cardCount(int count);

  /// No description provided for @bestPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String bestPoints(int points);

  /// No description provided for @emptyDeck.
  ///
  /// In en, this message translates to:
  /// **'This deck is empty.\nTap \"Add card\" to add a word and what it means.'**
  String get emptyDeck;

  /// No description provided for @addTwoCards.
  ///
  /// In en, this message translates to:
  /// **'Add 2 cards to start playing!'**
  String get addTwoCards;

  /// No description provided for @addOneMoreCard.
  ///
  /// In en, this message translates to:
  /// **'Add 1 more card to start playing!'**
  String get addOneMoreCard;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get addCard;

  /// No description provided for @deleteCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{word}\"?'**
  String deleteCardTitle(String word);

  /// No description provided for @deleteCardMessage.
  ///
  /// In en, this message translates to:
  /// **'This card will be removed from the deck.'**
  String get deleteCardMessage;

  /// No description provided for @deleteCardTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete card'**
  String get deleteCardTooltip;

  /// No description provided for @editCard.
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get editCard;

  /// No description provided for @newCard.
  ///
  /// In en, this message translates to:
  /// **'New card'**
  String get newCard;

  /// No description provided for @wordLabel.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get wordLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'What it means'**
  String get descriptionLabel;

  /// No description provided for @typeTheWord.
  ///
  /// In en, this message translates to:
  /// **'Type the word'**
  String get typeTheWord;

  /// No description provided for @addPicture.
  ///
  /// In en, this message translates to:
  /// **'Add picture'**
  String get addPicture;

  /// No description provided for @changePicture.
  ///
  /// In en, this message translates to:
  /// **'Change picture'**
  String get changePicture;

  /// No description provided for @removePicture.
  ///
  /// In en, this message translates to:
  /// **'Remove picture'**
  String get removePicture;

  /// No description provided for @needDescriptionOrPicture.
  ///
  /// In en, this message translates to:
  /// **'Add a description or a picture'**
  String get needDescriptionOrPicture;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @pictureError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get that picture. Try again!'**
  String get pictureError;

  /// No description provided for @whatToSee.
  ///
  /// In en, this message translates to:
  /// **'What do you want to see?'**
  String get whatToSee;

  /// No description provided for @modeWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get modeWords;

  /// No description provided for @modeWordsHint.
  ///
  /// In en, this message translates to:
  /// **'See a word, find what it means'**
  String get modeWordsHint;

  /// No description provided for @modeDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Descriptions'**
  String get modeDescriptions;

  /// No description provided for @modeDescriptionsHint.
  ///
  /// In en, this message translates to:
  /// **'See what it means, find the word'**
  String get modeDescriptionsHint;

  /// No description provided for @modeMix.
  ///
  /// In en, this message translates to:
  /// **'Mix'**
  String get modeMix;

  /// No description provided for @modeMixHint.
  ///
  /// In en, this message translates to:
  /// **'A surprise of both'**
  String get modeMixHint;

  /// No description provided for @howManyCards.
  ///
  /// In en, this message translates to:
  /// **'How many cards?'**
  String get howManyCards;

  /// No description provided for @allCards.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String allCards(int count);

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play!'**
  String get play;

  /// No description provided for @whichMatches.
  ///
  /// In en, this message translates to:
  /// **'Which one matches?'**
  String get whichMatches;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again!'**
  String get tryAgain;

  /// No description provided for @streakBonus.
  ///
  /// In en, this message translates to:
  /// **'🔥 {streak} in a row! +{bonus} bonus'**
  String streakBonus(int streak, int bonus);

  /// No description provided for @cheer1.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get cheer1;

  /// No description provided for @cheer2.
  ///
  /// In en, this message translates to:
  /// **'You got it!'**
  String get cheer2;

  /// No description provided for @cheer3.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get cheer3;

  /// No description provided for @cheer4.
  ///
  /// In en, this message translates to:
  /// **'Nice one!'**
  String get cheer4;

  /// No description provided for @cheer5.
  ///
  /// In en, this message translates to:
  /// **'Super!'**
  String get cheer5;

  /// No description provided for @cheer6.
  ///
  /// In en, this message translates to:
  /// **'Yes!'**
  String get cheer6;

  /// No description provided for @stopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop playing?'**
  String get stopTitle;

  /// No description provided for @stopMessage.
  ///
  /// In en, this message translates to:
  /// **'Your points for this round will be lost.'**
  String get stopMessage;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @keepPlaying.
  ///
  /// In en, this message translates to:
  /// **'Keep playing'**
  String get keepPlaying;

  /// No description provided for @stopTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop playing'**
  String get stopTooltip;

  /// No description provided for @resultPerfect1.
  ///
  /// In en, this message translates to:
  /// **'Perfect round!'**
  String get resultPerfect1;

  /// No description provided for @resultPerfect2.
  ///
  /// In en, this message translates to:
  /// **'You are a star!'**
  String get resultPerfect2;

  /// No description provided for @resultPerfect3.
  ///
  /// In en, this message translates to:
  /// **'Wow, amazing!'**
  String get resultPerfect3;

  /// No description provided for @resultGood1.
  ///
  /// In en, this message translates to:
  /// **'Great work!'**
  String get resultGood1;

  /// No description provided for @resultGood2.
  ///
  /// In en, this message translates to:
  /// **'Almost perfect!'**
  String get resultGood2;

  /// No description provided for @resultGood3.
  ///
  /// In en, this message translates to:
  /// **'Nice going!'**
  String get resultGood3;

  /// No description provided for @resultTry1.
  ///
  /// In en, this message translates to:
  /// **'Good try! Play again to earn more stars.'**
  String get resultTry1;

  /// No description provided for @resultTry2.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing!'**
  String get resultTry2;

  /// No description provided for @newBest.
  ///
  /// In en, this message translates to:
  /// **'New best!'**
  String get newBest;

  /// No description provided for @pointsTotal.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String pointsTotal(int points);

  /// No description provided for @firstTryScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} right on the first try'**
  String firstTryScore(int correct, int total);

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak: 🔥 {streak}'**
  String bestStreak(int streak);

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @practiceTricky.
  ///
  /// In en, this message translates to:
  /// **'Practice tricky words ({count})'**
  String practiceTricky(int count);

  /// No description provided for @trickyWords.
  ///
  /// In en, this message translates to:
  /// **'Tricky words ({count})'**
  String trickyWords(int count);

  /// No description provided for @backToDeck.
  ///
  /// In en, this message translates to:
  /// **'Back to {deck}'**
  String backToDeck(String deck);
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
      <String>['en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
