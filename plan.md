# Match Flash Cards: Plan

A matching flashcard study app for kids. A kid (or a parent) enters words with short descriptions. In study mode the app shows one side of a card, and the kid picks the matching other side from a few choices.

## Starting point

- A fresh `flutter create` project. `lib/main.dart` is still the counter demo.
- Only the Android platform folder exists.
- The only dependency so far is `cupertino_icons`.

## Goals

1. **Create cards.** Enter several word/description pairs, then edit or delete them.
2. **Study by matching.** Show one side of a card. The kid taps the matching other side from a set of choices.
3. **Choose the prompt side.** Before a session the kid picks what the prompts show:
   - **Words**: show the word, pick the description.
   - **Descriptions**: show the description, pick the word.
   - **Mix**: each card randomly shows one side or the other.
4. **Always randomize.** Every session uses a new card order, new answer positions and new wrong answers. In Mix mode the side shown is also random.
5. **Light gamification.** Make it rewarding without turning it into a game that distracts from learning.

## User experience

### Screens

1. **Home**
   - The list of card sets (decks), for example "Animals" or "Spelling week 3".
   - A big "+" button to create a deck.
   - Each deck tile shows its name, card count and best star score.
2. **Deck editor**
   - The deck name, plus a list of cards (word + description).
   - "Add card" opens a simple two-field form: **Word** and **What it means**.
   - Swipe or tap to edit or delete a card.
   - The Study button is disabled until the deck has at least **2 cards**. A friendly hint explains why ("Add 1 more card to start playing!").
3. **Study setup**
   - Three large, illustrated toggle buttons: **Words**, **Descriptions**, **Mix**.
   - A round length option: all cards, or 5 / 10 when the deck is large.
   - A big "Play!" button.
4. **Study (matching round)**
   - At the top: a progress bar, current points and a streak flame.
   - In the middle: a large prompt card showing the word or the description.
   - Below: **up to 4 answer tiles** (fewer when the deck is small), each showing the opposite side.
   - **Correct tap:** the tile turns green and bounces, points are added, and the next card slides in.
   - **Wrong tap:** that tile shakes gently and greys out, and the kid can try again. No harsh sounds or red screens. A missed card is re-queued at the end of the round so it gets practiced again.
5. **Round results**
   - 1 to 3 stars, based on how many cards were right on the first try.
   - Points total, best streak and a "New best!" banner when earned.
   - Buttons: **Play again** (reshuffles) and **Back to deck**.

### Kid-friendly design

- Large tap targets (at least 64 dp), rounded cards, bright but readable colors, and big text (20 sp or more).
- Simple words throughout ("Great job!", "Try again!").
- No timers that punish slow readers. Speed never costs points.
- Works in portrait on phones and tablets (`LayoutBuilder` switches the answer grid between 1 and 2 columns).

## Randomization rules

All randomness goes through one injectable `Random` so tests can use a fixed seed.

1. **Card order:** shuffle the deck's cards at the start of every session.
2. **Prompt side:**
   - Words mode always shows the word, Descriptions mode always shows the description.
   - Mix mode picks a side per card with a 50/50 chance, re-rolled each session.
3. **Wrong answers (distractors):** pick `min(3, deckSize - 1)` other cards at random. Use the same side as the correct answer, so all tiles are all words or all descriptions.
4. **Answer positions:** shuffle the correct answer in with the distractors so it never sits in a fixed slot.
5. **Re-queued misses:** a missed card is inserted at a random position among the remaining cards. It never comes back immediately unless it is the last card left.
6. **Duplicates:** if two cards share the same word or description text, never show both as tiles for the same question.

## Gamification

Kept intentionally light:

| Element | Rule |
| --- | --- |
| **Points** | +10 for a correct first try, +5 for a correct second try, +2 after that. |
| **Streak** | Each first-try correct answer in a row grows the flame. At 3, 5 and 10 the kid gets a bonus (+5 / +10 / +20) and a small burst animation. A wrong tap resets the streak quietly. |
| **Stars** | At the end of the round: 3 stars for ≥ 90% first-try correct, 2 stars for ≥ 60%, 1 star for finishing. Every finished round earns at least 1 star. |
| **Best score** | Best stars and points are saved per deck and shown on the Home screen. |
| **Celebration** | A confetti burst on the results screen for 3 stars or a new best. Encouraging messages rotate randomly. |
| **Sound (optional)** | A soft "ding" for correct and a gentle "boop" for wrong, with a mute toggle. This is a later phase. |

## Technical design

### Folder structure

```
lib/
  main.dart                 # runApp + MaterialApp, theme
  models/
    flash_card.dart         # id, word, description
    deck.dart               # id, name, cards, bestStars, bestPoints
    study_mode.dart         # enum StudyMode { words, descriptions, mix }
  data/
    deck_repository.dart    # load/save decks (JSON via shared_preferences)
  logic/
    study_session.dart      # pure Dart: queue, randomization, scoring, streaks
  ui/
    home_screen.dart
    deck_editor_screen.dart
    card_form.dart
    study_setup_screen.dart
    study_screen.dart
    results_screen.dart
    widgets/                # PromptCard, AnswerTile, StreakFlame, StarRow, ProgressHeader
```

### State management

- Use plain `ChangeNotifier` + `ListenableBuilder`, so no extra packages are needed.
  - `DeckRepository` notifies the Home and Deck editor screens.
  - `StudySession` is a `ChangeNotifier` that is created per round and drives the Study screen.
- Keep `StudySession` free of Flutter imports so it is easy to unit test.

### Data and persistence

- `FlashCard` and `Deck` get `toJson` / `fromJson` methods. All decks are stored as one JSON string in `shared_preferences`.
- IDs are generated from a timestamp plus a random suffix, so no `uuid` package is needed.
- On first launch the app seeds a small sample deck (for example, 4 animal words) so the app isn't empty.

### Dependencies to add

- `shared_preferences` for saving decks.
- `image_picker` for card pictures (works on Android, iOS and web).
- Confetti is a small custom animation instead of the `confetti` package.
- Sounds are dropped for now.

### StudySession API (sketch)

```dart
class StudySession extends ChangeNotifier {
  StudySession({required List<FlashCard> cards, required StudyMode mode, Random? random});

  Question get current;          // prompt text, prompt side, List<AnswerOption> options
  int get points;
  int get streak;
  int get bestStreak;
  double get progress;           // 0..1
  bool get isFinished;

  AnswerResult answer(AnswerOption option);  // correct / wrong, updates score & queue
  RoundResult get result;        // stars, points, firstTryCorrect, total
}
```

## Implementation phases

1. **Foundation**
   - Replace the counter demo with `MaterialApp` and a kid-friendly theme.
   - Add the models with JSON support and the repository with `shared_preferences`.
   - Add unit tests for JSON round-trips.
2. **Card management**
   - Build the Home screen (deck list, create / rename / delete) and the Deck editor (add / edit / delete cards, minimum-2 rule).
   - Add widget tests for adding a card.
3. **Study logic**
   - Implement `StudySession`: shuffling, the three modes, distractors, re-queueing and scoring.
   - Add thorough unit tests with a seeded `Random`:
     - order differs between seeds
     - the correct answer is always among the options
     - no duplicate options
     - Mix mode produces both sides
     - re-queue behavior
     - point and star math
4. **Study UI**
   - Build the setup screen, the Study screen (prompt, answer grid, progress, points, streak) and the Results screen.
   - Add tile animations (bounce, shake, slide-in).
   - Add a widget test for a full round on a 2-card deck.
5. **Polish and gamification extras**
   - Confetti, rotating encouragement messages, best-score saving, optional sounds with a mute toggle.
   - Responsive layout for tablets, plus an accessibility pass (semantics labels, text scaling, contrast).
6. **Cleanup**
   - Update the README and `pubspec.yaml` description, and replace the default `widget_test.dart`.
   - Run `dart analyze` until it is clean.

## Testing strategy

- **Unit (`test/logic/`):** `StudySession` covers the randomization rules, scoring, streaks, stars and re-queueing, all with a fixed seed.
- **Unit (`test/models/`):** JSON serialization.
- **Widget (`test/ui/`):** create a deck, add cards, start a session in each mode, answer correctly and incorrectly, and see the results.
- **Manual:** play on an Android emulator to check animations, tap target sizes and text readability.

## Decisions

1. **Decks:** multiple named decks.
2. **Read-aloud:** no text-to-speech.
3. **Pictures:** yes. A card can have an optional picture, chosen from the gallery (or camera on mobile) with `image_picker`.
   - The picture belongs to the **description side**. A description-side prompt or tile shows the picture above the description text, so Words mode shows a word and answers with description + picture.
   - A card needs a word, plus at least a description or a picture.
   - Images are downscaled (max 480 px, JPEG quality 70) and stored as base64 inside the card JSON, which keeps each picture around 30-60 KB and avoids file-path bookkeeping. If decks outgrow `shared_preferences`, move to a database later.
4. **Platforms:** Android only.
5. **Parent lock:** none. Editing is only reachable from the Home and Deck editor screens. The Study screen has no edit actions at all, so a kid mid-round cannot change or delete cards.
