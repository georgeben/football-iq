class RoundsController < ApplicationController
  def start
    @footballer = Footballer.random
    @round = Round.create(footballer: @footballer)

    p @round
  end

  def new_guess
    @round = Round.find(params[:id])
    puts "Name:  #{@round.footballer.name}"
    
    prompt = @round.footballer.build_prompt
    user_message = new_guess_params[:message]

    @response = GeminiAiService.new(max_output_tokens: 100).generate_content(user_message:, prompt:)
    @round.guesses.create!(message: user_message, response: @response)

    if @response == "Correct"
      @round.update(result: :success, total_guesses: @round.total_guesses + 1)
    else 
      @round.update(total_guesses: @round.total_guesses + 1)
    end

    # whenever a round is updated, broadcast it to the view

    puts "Response! #{@response}"

    # for html render new_guess
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def new_guess_params
    params.require(:guess).permit(:message)
  end
end
