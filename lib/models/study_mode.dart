enum StudyMode {
  words('Words', 'See a word, find what it means'),
  descriptions('Descriptions', 'See what it means, find the word'),
  mix('Mix', 'A surprise of both');

  const StudyMode(this.label, this.hint);

  final String label;
  final String hint;
}
