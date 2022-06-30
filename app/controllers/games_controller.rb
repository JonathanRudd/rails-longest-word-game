require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    @word = ''

    game_letters = ('A'..'Z').to_a.sample(10)
    @letters = game_letters
  end

  def score
    @grid = params[:letters]
    @attempt = params[:word]
    @result = run_game(@attempt, @grid)
  end

  def included?(attempt, grid)
    attempt.split('').all? { |letter| grid.include? letter }
  end

  def run_game(attempt, grid)
    result = {}
    result[:translation] = check_translation(attempt)
    result[:message] = result_message(attempt, result[:translation], grid)
    result # why do I need to return result here?
  end

  private

  def result_message(attempt, translation, grid)
    if translation
      if included?(attempt.upcase, grid)
        ["Congratulations! #{attempt} is a valid English word!"]
      else
        ["Sorry but #{attempt} can't be build out of #{grid} "]
      end
    else
      ["Sorry but #{attempt} does not seem to be a valid English word..."]
    end
  end

  def check_translation(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word.downcase}")
    json = JSON.parse(response.read.to_s)
    json["found"]
    # want to retrieve the value of the found key (either true or false
  end
end
