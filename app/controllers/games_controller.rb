class GamesController < ApplicationController
  def new
    @letters = random_letters
    @game = Game.new
    @party = Party.new
    frenchDic
    raise
  end

  private
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
    @file = []
    #encoding with utf-8caracters
    File.open(path, 'rb', encoding: "ISO8859-1:utf-8").each do |line|
      #line bien cheloue pour gsub tous les caractères latins spéciaux en pas spéciaux
      @file << line.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase.to_s.strip
    end
  end
end
