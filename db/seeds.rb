30.times do
  phrase = Faker::Lorem.words(number: 6)
  translation = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  Phrase.create phrase: phrase, translation: translation, category: rand(1...4)
end
