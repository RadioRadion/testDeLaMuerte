class PartiesController < ApplicationController

  def new
    game_init
    @letters = random_letters
    @party = Party.new
  end

  def create
    @dictionnary = frenchDic
    @letters = params[:party][:ten_letters_list]
    @game = current_user.games.last
    @party = Party.new(party_params)
    @party.ten_letters_list = @letters
    @party.game = @game
    @party.available = true
    @solutions = compare(@dictionnary, @letters)
    if @party.save
      save_scores
      save_solutions
      redirect_to party_path(@party)
    else
      render :new
    end
  end

  def show
    @game = current_user.games.last
    @party = Party.find(params[:id])
    @solutions = Solution.where(party_id: @party)
  end

  private

  def save_solutions
    @solutions.reverse.each do |solution|
      Solution.create!(word: solution, party_id: @party.id)
    end
  end

  def save_scores
    actual_score = 0
    @game.parties.all.each do |party|
      actual_score += party.word.length
    end
    current_user.best_score = actual_score if actual_score > current_user.best_score
    current_user.update!(actual_score: actual_score, best_score: current_user.best_score)
  end

  def game_init
    if (current_user.games.blank? || current_user.games.last.parties.length == 5)
      @game = Game.create!(user_id: current_user.id)
    else
      @game = current_user.games.last
    end
  end

  def party_params
    params.require(:party).permit(:word)
  end

  def random_letters
    random_letters = (voyels + consonants).shuffle.join
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

  def compare(dictionnary, letters)
    results = []
    dictionnary.each do |word|
      pickLetters = letters.chars.map { |letter| letter }
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
