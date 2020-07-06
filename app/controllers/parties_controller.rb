class PartiesController < ApplicationController
  def new
    @letters = random_letters
    @game = Game.new
    @party = Party.new
    frenchDic
    @bestResults = compare(@dictionnary, @letters)
  end

  def create
    @party = Party.new(party_params)
    raise
  end

  private

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
    @dictionnary = []
    #encoding with utf-8caracters
    File.open(path, 'rb', encoding: "ISO8859-1:utf-8").each do |line|
      if (line.length < 10 && !line.include?("-"))
      #line bien cheloue pour gsub tous les caractères latins spéciaux en pas spéciaux
        @dictionnary << line.mb_chars.unicode_normalize(:nfkc).gsub(/[^\x00-\x7F]/n,'').upcase.to_s.strip
      end
    end
    @dictionnary
  end

  def compare(dictionnary, letters)
    results = []
    dictionnary.each do |word|
      pickLetters = letters.map { |letter| letter }
      word.chars.each { |letter| pickLetters.include?(letter) ? pickLetters.delete_at(pickLetters.index(letter)) : false }
      results << word if word.length == (letters.length - pickLetters.length)
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
