class Party < ApplicationRecord
  belongs_to :game
  has_many :solutions, dependent: :destroy

  validates :ten_letters_list, presence: true
  validates :word, presence: true, length: { in: 2...10 }
  validate :is_dictionnary?, on: :create
  validate :is_present?, on: :create
  # validates :available, presence: true, inclusion: { in: [true, false] }

  def is_dictionnary?
    errors.add(:word, "isn't in the dictionnary") unless frenchDic.include?(self.word.upcase)
  end

  def is_present?
    errors.add(:word, "'s letters are not all compatibles") unless allPresent(self.word, self.ten_letters_list)
  end

  def allPresent(word, letters)
    pickLetters = letters.chars.map { |letter| letter }
    word.upcase.chars.each { |letter| pickLetters.delete_at(pickLetters.index(letter)) if pickLetters.include?(letter) }
    true if word.length == (letters.length - pickLetters.length)
  end

  def frenchDic
    path = File.join(Rails.root, 'lib', 'data', 'liste_francais.txt')
    dictionnary = []
    File.open(path, 'rb', encoding: "ISO8859-1:utf-8").each do |line|
      if (line.length < 10 && !line.include?("-"))
        dictionnary << line.mb_chars.unicode_normalize(:nfkc).gsub(/[^\x00-\x7F]/n,'').upcase.to_s.strip
      end
    end
    dictionnary
  end
end
