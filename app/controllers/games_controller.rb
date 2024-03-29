require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # @letters = ("a".."z").to_a.sample(9).join(" ").upcase
    @letters = ('a'..'z').to_a.sample(9)
  end

  def score
    @word = params[:word]
    @grid = params[:letters]

    cookies[:score] = 0 if cookies[:score].nil?
    @points = @word.length * 2
    @in_grid = in_grid?(@word, @grid)
    @english_word = check_validity(@word)

    # @output = if in_grid?(@word) && check_validity(@word)
    #             cookies[:score] = cookies[:score].to_i + points
    #             "Congrats, it's a valid word. Score: #{points}! Total score: #{cookies[:score]}"
    #           elsif !check_validity(@word)
    #             "Sorry but #{@word} is not a valid word."
    #           else
    #             "Sorry but #{@word} can't be built out of #{@grid}"
    #           end
  end

  private

  def check_validity(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_result = open(url).read
    result = JSON.parse(word_result)
    result['found']
  end

  def in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.downcase.count(letter) }
  end
end
