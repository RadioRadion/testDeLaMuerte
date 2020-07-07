class PartiesController < ApplicationController
  # before_action :init

  def new
    @letters = random_letters
    @party = Party.new
  end

  def create
    @dictionnary = frenchDic
    @game = game_init
    @party = Party.new(party_params)
    @party.ten_letters_list = @@letters.join
    @party.game = @game
    @party.available = false
    @solutions = compare
    @party.save!
  end

  private

  def game_init
    return Game.new if (current_user.games.blank? || current_user.games.last.parties.length == 5)
    current_user.games.last
  end

  def party_params
    params.require(:party).permit(:word)
  end

  def random_letters
    random_letters = (voyels + consonants).shuffle
  end

  def voyels
    voyels = []
    5.times { voyels << ["A", "E", "I", "O", "U", "Y"].sample }
    voyels
  end

  def consonants
    consonants = []
    5.times { consonants << ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"].sample }
    consonants
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

  def compare
    results = []
    dictionnary.each do |word|
      pickLetters = @@letters.map { |letter| letter }
      word.chars.each { |letter| pickLetters.include?(letter) ? pickLetters.delete_at(pickLetters.index(letter)) : false }
      results << word if word.length == (@@letters.length - pickLetters.length)
    end
    return results.sort{|x, y| x.length <=> y.length}.last(10)
  end

end
  ######première fonction compare qui ne marche qu'avec un ordinateur quantique
  # def compare(dictionnary)
  #   allResults = []
  #   n = 10
  #   until n < 1
  #     @letters.permutation(n).to_a.each do |possibility|
  #       allResults << possibility if dictionnary.include?(possibility.join)
  #       break allResults if allResults.length > 9
  #     end
  #     n -= 1
  #   end
  # end
