require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid
    @word = params[:word]
  end

  def generate_grid
    # TODO: generate random grid of letters
    Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @grid = params[:total_grid]
    @word = params[:word]
    @letters = included?(@word, @grid)
    @english = english_word?(@word)
    @message = message(@word, @grid)
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def message(word, grid)
    if included?(word.upcase, grid)
      if english_word?(word)
        "Congratulations, #{word.upcase} is an english word! "
      else
        "#{word.upcase} is not an english word"
      end
    else
      "Sorry but #{word.upcase} cannot be build out of the following letters: #{grid.upcase}"
    end
  end
end
