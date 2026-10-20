// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Match Flash Cards';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get keep => 'Keep';

  @override
  String get delete => 'Delete';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSwedish => 'Svenska';

  @override
  String get myDecks => 'My Decks';

  @override
  String get noDecks =>
      'No decks yet!\nTap \"New deck\" to make your first one.';

  @override
  String get newDeck => 'New deck';

  @override
  String get nameYourDeck => 'Name your deck';

  @override
  String get deckNameHint => 'Animals, Spelling week 3, ...';

  @override
  String get rename => 'Rename';

  @override
  String get renameDeck => 'Rename deck';

  @override
  String deleteDeckTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteDeckMessage => 'All of its cards will be deleted too.';

  @override
  String cardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String bestPoints(int points) {
    return '$points pts';
  }

  @override
  String get emptyDeck =>
      'This deck is empty.\nTap \"Add card\" to add a word and what it means.';

  @override
  String get addTwoCards => 'Add 2 cards to start playing!';

  @override
  String get addOneMoreCard => 'Add 1 more card to start playing!';

  @override
  String get study => 'Study';

  @override
  String get addCard => 'Add card';

  @override
  String deleteCardTitle(String word) {
    return 'Delete \"$word\"?';
  }

  @override
  String get deleteCardMessage => 'This card will be removed from the deck.';

  @override
  String get deleteCardTooltip => 'Delete card';

  @override
  String get editCard => 'Edit card';

  @override
  String get newCard => 'New card';

  @override
  String get wordLabel => 'Word';

  @override
  String get descriptionLabel => 'What it means';

  @override
  String get typeTheWord => 'Type the word';

  @override
  String get addPicture => 'Add picture';

  @override
  String get changePicture => 'Change picture';

  @override
  String get removePicture => 'Remove picture';

  @override
  String get needDescriptionOrPicture => 'Add a description or a picture';

  @override
  String get save => 'Save';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get pictureError => 'Couldn\'t get that picture. Try again!';

  @override
  String get whatToSee => 'What do you want to see?';

  @override
  String get modeWords => 'Words';

  @override
  String get modeWordsHint => 'See a word, find what it means';

  @override
  String get modeDescriptions => 'Descriptions';

  @override
  String get modeDescriptionsHint => 'See what it means, find the word';

  @override
  String get modeMix => 'Mix';

  @override
  String get modeMixHint => 'A surprise of both';

  @override
  String get howManyCards => 'How many cards?';

  @override
  String allCards(int count) {
    return 'All $count';
  }

  @override
  String get play => 'Play!';

  @override
  String get whichMatches => 'Which one matches?';

  @override
  String get tryAgain => 'Try again!';

  @override
  String streakBonus(int streak, int bonus) {
    return '🔥 $streak in a row! +$bonus bonus';
  }

  @override
  String get cheer1 => 'Great job!';

  @override
  String get cheer2 => 'You got it!';

  @override
  String get cheer3 => 'Awesome!';

  @override
  String get cheer4 => 'Nice one!';

  @override
  String get cheer5 => 'Super!';

  @override
  String get cheer6 => 'Yes!';

  @override
  String get stopTitle => 'Stop playing?';

  @override
  String get stopMessage => 'Your points for this round will be lost.';

  @override
  String get stop => 'Stop';

  @override
  String get keepPlaying => 'Keep playing';

  @override
  String get stopTooltip => 'Stop playing';

  @override
  String get resultPerfect1 => 'Perfect round!';

  @override
  String get resultPerfect2 => 'You are a star!';

  @override
  String get resultPerfect3 => 'Wow, amazing!';

  @override
  String get resultGood1 => 'Great work!';

  @override
  String get resultGood2 => 'Almost perfect!';

  @override
  String get resultGood3 => 'Nice going!';

  @override
  String get resultTry1 => 'Good try! Play again to earn more stars.';

  @override
  String get resultTry2 => 'Keep practicing!';

  @override
  String get newBest => 'New best!';

  @override
  String pointsTotal(int points) {
    return '$points points';
  }

  @override
  String firstTryScore(int correct, int total) {
    return '$correct of $total right on the first try';
  }

  @override
  String bestStreak(int streak) {
    return 'Best streak: 🔥 $streak';
  }

  @override
  String get playAgain => 'Play again';

  @override
  String backToDeck(String deck) {
    return 'Back to $deck';
  }
}
