class Party < ApplicationRecord
  belongs_to :game
  has_many :solutions

  validates :ten_letters_list, presence: true, length: { is: 10 }
  validates :word, presence: true, length: { in: 2...10 }
  validate :is_dictionnary?, on: :create
  validate :is_present?, on: :create
  validates :available, presence: true, inclusion: { in: [true, false] }

  def is_dictionnary?
    errors.add(:word, "The word isn't in the dictionnary") unless frenchDic.include?(:word)
  end

  def is_present?
    errors.add(:word, "The letters of the word are not all compatibles") unless self.word.chars.all? { |letter| self.ten_letters_list.include?(letter) }
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
