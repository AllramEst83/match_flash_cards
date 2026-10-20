import '../models/deck.dart';
import '../models/flash_card.dart';
import '../models/ids.dart';

/// Decks that ship with the app. Each is added once, by [key], so a deck the
/// user deletes does not come back. Delete an entry (and its builder) to
/// change the starter content (see DeckRepository._load).
typedef BundledDeck = ({String key, Deck Function() build});

final bundledDecks = <BundledDeck>[
  (key: 'materia', build: _materia),
  (key: 'vasatiden', build: _vasatiden),
];

Deck _deck(String name, List<(String, String)> cards) => Deck(
  id: newId(),
  name: name,
  cards: [
    for (final (word, description) in cards)
      FlashCard(id: newId(), word: word, description: description),
  ],
);

Deck _materia() => _deck('Materia och material', const [
  (
    'grundämne',
    'ett ämne som består av en enda sorts atom ( ex guld, svavel, syre)',
  ),
  (
    'metaller',
    'en stor grupp av grundämnen som leder värme och el och blänker. '
        'De flesta grundämnena är metaller',
  ),
  ('lösning', 'en blandning där man inte kan se olika beståndsdelar.'),
  (
    'rent ämne',
    'är ett ämne som innehåller bara en sorts kemiskt ämne. '
        'ex guld, destillerat vatten',
  ),
  (
    'materia',
    'är något som man kan väga. Allt som går att väga är alltså materia.',
  ),
  ('material', 'är något som vi kan tillverka saker av.'),
  ('halvmetaller', 'ämne som liknar både metall och icke-metall'),
  (
    'kemisk förening eller förening',
    'ett ämne som består av minst två sorters atomer ( ex vatten)',
  ),
  ('blandning', 'när det finns fler en ett ämne blandat i något'),
  ('icke-metaller', 'grundämne som inte har metalliska egenskaper'),
]);

/// Questions 1-26 of the worksheet "Vasatiden - läsning och frågor", answered
/// from its text. Questions 27-32 are open opinion questions, so they are left
/// out.
Deck _vasatiden() => _deck('Vasatiden', const [
  (
    'Vad var Kalmarunionen?',
    'Sedan 1389 samarbetade Danmark, Norge och Sverige i en union. '
        'Hela Norden skulle ha samma kung, unionskungen.',
  ),
  (
    'Vad var en riksföreståndare?',
    'Varje land hade en egen riksföreståndare, som skulle vara i '
        'kungens ställe och styra landet när kungen inte var där.',
  ),
  (
    'Varför var många svenska bönder missnöjda med unionskungen?',
    'Makten hade flyttats till en kung i Danmark, som inte lyssnade på '
        'dem. De ville inte heller vara med om de krig som unionskungen '
        'startade.',
  ),
  (
    'Vilka två personer kämpade om makten över Sverige i början av '
        '1500-talet?',
    'Kristian II, kung i Danmark, och Sten Sture den yngre, Sveriges '
        'riksföreståndare. Båda ville ha makten över Sverige.',
  ),
  (
    'Vem var Kristina Gyllenstierna och vad gjorde hon?',
    'Hon var Sten Sture den yngres änka och en av de viktigaste '
        'motståndsledarna mot kung Kristian. Hon kontrollerade Stockholm '
        'och fortsatte kämpa tills staden till slut tvingades kapitulera.',
  ),
  (
    'Vad hände under Stockholms blodbad år 1520?',
    'I november 1520 dömdes flera svenska frälsemän och biskopar till '
        'döden efter snabba rättegångar, anklagade för att vara kättare. '
        'Ungefär hundra personer avrättades på Stortorget i Stockholm, '
        'bland dem biskopar, borgmästare, borgare och tjänare.',
  ),
  (
    'Varför började Kristian II kallas Kristian Tyrann?',
    'Efter blodbadet lät han avrätta fler, bland annat i Norrköping, '
        'Linköping, Vadstena och Jönköping. Han ville också införa nya '
        'skatter, förbjuda bönderna att ha vapen och göra det svårare att '
        'handla med länder utanför Norden. Han blev alltmer avskydd.',
  ),
  (
    'Vem ledde upproret mot Kristian II?',
    'En ung man som hette Gustav Eriksson, mer känd som Gustav Vasa.',
  ),
  (
    'Vilket år blev Gustav Vasa kung?',
    'Den 6 juni 1523 valdes Gustav Vasa till svensk kung vid ett möte i '
        'Strängnäs.',
  ),
  (
    'Vad hände med Kalmarunionen när Gustav Vasa blev kung?',
    'Sverige lämnade unionen och blev ett självständigt land. Danmark '
        'och Norge fortsatte att vara i union.',
  ),
  (
    'Varför behövde Gustav Vasa mycket pengar?',
    'Kriget mot danskarna hade kostat mycket pengar och Sverige hade '
        'stora skulder. Han ville dessutom bygga upp en stark armé.',
  ),
  (
    'Vad menas med att en bonde var självägande?',
    'Bondefamiljen ägde själva jorden de arbetade på. De betalade skatt '
        'till kungen, men var fria och ingen bestämde helt över deras '
        'liv eller arbete.',
  ),
  (
    'Ge två exempel på arbeten som barn kunde göra under 1500-talet.',
    'Barn kunde hjälpa till hemma med att mjölka kor, mata djur och '
        'passa sina småsyskon. Äldre barn kunde skickas iväg för att '
        'arbeta hos andra familjer, som dräng eller piga.',
  ),
  (
    'Varför var gruvorna i Falun och Sala viktiga?',
    'I Falun bröt man koppar och i Sala fanns en silvergruva. Silvret '
        'användes bland annat för att göra mynt, och en del sparades i '
        'skattkammaren på Stockholms slott.',
  ),
  (
    'Vad var ett avlatsbrev?',
    'Ett brev som kyrkan sålde och som sades kunna minska människors '
        'straff efter döden.',
  ),
  (
    'Varför kritiserade Martin Luther den katolska kyrkan?',
    'Luther tyckte att det viktigaste var Bibeln och att människor inte '
        'behövde be till helgon eller köpa avlatsbrev. Många tyckte att '
        'det var orättvist att betala pengar för att bli förlåten av Gud.',
  ),
  (
    'Vad betyder reformationen?',
    'Att Sverige steg för steg, under många år, lämnade den katolska '
        'kyrkan och blev protestantiskt. Det innebar bland annat att '
        'kungen fick större kontroll över kyrkan.',
  ),
  (
    'Nämn två saker som förändrades i den svenska kyrkan under '
        'reformationen.',
    'Präster fick gifta sig, gudstjänster hölls på svenska och helgon '
        'skulle inte längre dyrkas.',
  ),
  (
    'Varför blev bönderna arga när Gustav Vasa ville ta kyrkklockorna?',
    'Gustav Vasa behövde pengar och bestämde att kyrkorna skulle lämna '
        'ifrån sig en av sina största kyrkklockor. Klockorna skulle '
        'smältas ner och säljas.',
  ),
  (
    'Vad var Dackefejden och vem ledde upproret?',
    'Ett stort uppror 1542 i Småland mot Gustav Vasa, eftersom kungen '
        'tog kyrkans saker, krävde höga skatter och hade hårda regler. '
        'Det leddes av Nils Dacke.',
  ),
  (
    'Hur använde Gustav Vasa propaganda?',
    'Han anställde en historieskrivare som skrev berättelser om hans '
        'liv och hans kamp mot Danmark. Propaganda betyder att försöka '
        'påverka människor så att de tycker eller tänker på ett visst '
        'sätt.',
  ),
  (
    'Vad betyder det att kronan blev ärftlig?',
    'Att kungatiteln går i arv inom kungens egen familj, i stället för '
        'att kungar väljs av mäktiga personer. Sverige blev ett arvrike.',
  ),
  (
    'Vem blev kung efter Gustav Vasa?',
    'Hans äldsta son Erik blev automatiskt kung när Gustav Vasa dog '
        '1560. Han tog namnet Erik XIV.',
  ),
  (
    'Vad var Sturemorden?',
    'Erik XIV var mycket misstänksam och trodde att han var omgiven av '
        'fiender. Han lät avrätta flera män från den mäktiga släkten '
        'Sture.',
  ),
  (
    'Varför uppstod en konflikt kring Sigismund?',
    'Sigismund uppfostrades som katolik och blev först kung över Polen '
        'och senare även över Sverige. Sverige var alltså ett '
        'protestantiskt land med en katolsk kung, vilket ledde till '
        'konflikt.',
  ),
  (
    'Vem blev kung efter att Sigismund hade förlorat makten i Sverige?',
    'Gustav Vasas son Karl, som var protestant. Hans soldater besegrade '
        'Sigismunds vid slaget vid Stångebro, och Karl blev senare kung '
        'under namnet Karl IX.',
  ),
]);
