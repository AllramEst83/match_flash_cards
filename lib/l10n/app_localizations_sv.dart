// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Matcha kort';

  @override
  String get cancel => 'Avbryt';

  @override
  String get ok => 'OK';

  @override
  String get keep => 'Behåll';

  @override
  String get delete => 'Ta bort';

  @override
  String get settings => 'Inställningar';

  @override
  String get language => 'Språk';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSwedish => 'Svenska';

  @override
  String get myDecks => 'Mina kortlekar';

  @override
  String get noDecks =>
      'Inga kortlekar än!\nTryck på \"Ny kortlek\" för att göra din första.';

  @override
  String get newDeck => 'Ny kortlek';

  @override
  String get nameYourDeck => 'Döp din kortlek';

  @override
  String get deckNameHint => 'Djur, Stavning vecka 3, ...';

  @override
  String get rename => 'Byt namn';

  @override
  String get renameDeck => 'Byt namn på kortleken';

  @override
  String deleteDeckTitle(String name) {
    return 'Ta bort \"$name\"?';
  }

  @override
  String get deleteDeckMessage => 'Alla kort i kortleken tas också bort.';

  @override
  String cardCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kort',
      one: '1 kort',
    );
    return '$_temp0';
  }

  @override
  String bestPoints(int points) {
    return '$points p';
  }

  @override
  String get emptyDeck =>
      'Den här kortleken är tom.\nTryck på \"Lägg till kort\" och skriv ett ord och vad det betyder.';

  @override
  String get addTwoCards => 'Lägg till 2 kort för att börja spela!';

  @override
  String get addOneMoreCard => 'Lägg till ett kort till för att börja spela!';

  @override
  String get study => 'Öva';

  @override
  String get addCard => 'Lägg till kort';

  @override
  String deleteCardTitle(String word) {
    return 'Ta bort \"$word\"?';
  }

  @override
  String get deleteCardMessage => 'Kortet tas bort från kortleken.';

  @override
  String get deleteCardTooltip => 'Ta bort kort';

  @override
  String get editCard => 'Ändra kort';

  @override
  String get newCard => 'Nytt kort';

  @override
  String get wordLabel => 'Ord';

  @override
  String get descriptionLabel => 'Vad det betyder';

  @override
  String get typeTheWord => 'Skriv ordet';

  @override
  String get addPicture => 'Lägg till bild';

  @override
  String get changePicture => 'Byt bild';

  @override
  String get removePicture => 'Ta bort bilden';

  @override
  String get needDescriptionOrPicture =>
      'Lägg till en förklaring eller en bild';

  @override
  String get save => 'Spara';

  @override
  String get chooseFromGallery => 'Välj från galleriet';

  @override
  String get takePhoto => 'Ta ett foto';

  @override
  String get pictureError => 'Det gick inte att hämta bilden. Försök igen!';

  @override
  String get whatToSee => 'Vad vill du se?';

  @override
  String get modeWords => 'Ord';

  @override
  String get modeWordsHint => 'Se ett ord, hitta vad det betyder';

  @override
  String get modeDescriptions => 'Förklaringar';

  @override
  String get modeDescriptionsHint => 'Se en förklaring, hitta ordet';

  @override
  String get modeMix => 'Blandat';

  @override
  String get modeMixHint => 'Lite av varje';

  @override
  String get howManyCards => 'Hur många kort?';

  @override
  String allCards(int count) {
    return 'Alla $count';
  }

  @override
  String get play => 'Kör!';

  @override
  String get whichMatches => 'Vilket passar?';

  @override
  String get tryAgain => 'Försök igen!';

  @override
  String streakBonus(int streak, int bonus) {
    return '🔥 $streak i rad! +$bonus bonus';
  }

  @override
  String get cheer1 => 'Bra jobbat!';

  @override
  String get cheer2 => 'Du klarade det!';

  @override
  String get cheer3 => 'Grymt!';

  @override
  String get cheer4 => 'Snyggt!';

  @override
  String get cheer5 => 'Super!';

  @override
  String get cheer6 => 'Ja!';

  @override
  String get stopTitle => 'Vill du sluta spela?';

  @override
  String get stopMessage => 'Dina poäng för den här omgången försvinner.';

  @override
  String get stop => 'Sluta';

  @override
  String get keepPlaying => 'Fortsätt spela';

  @override
  String get stopTooltip => 'Sluta spela';

  @override
  String get resultPerfect1 => 'Perfekt omgång!';

  @override
  String get resultPerfect2 => 'Du är en stjärna!';

  @override
  String get resultPerfect3 => 'Wow, helt fantastiskt!';

  @override
  String get resultGood1 => 'Bra jobbat!';

  @override
  String get resultGood2 => 'Nästan perfekt!';

  @override
  String get resultGood3 => 'Snyggt gjort!';

  @override
  String get resultTry1 => 'Bra försök! Spela igen för att få fler stjärnor.';

  @override
  String get resultTry2 => 'Fortsätt öva!';

  @override
  String get newBest => 'Nytt rekord!';

  @override
  String pointsTotal(int points) {
    return '$points poäng';
  }

  @override
  String firstTryScore(int correct, int total) {
    return '$correct av $total rätt på första försöket';
  }

  @override
  String bestStreak(int streak) {
    return 'Längsta raden: 🔥 $streak';
  }

  @override
  String get playAgain => 'Spela igen';

  @override
  String backToDeck(String deck) {
    return 'Tillbaka till $deck';
  }
}
