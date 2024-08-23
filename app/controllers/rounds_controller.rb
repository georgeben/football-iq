class RoundsController < ApplicationController
  def start
    @footballer = Footballer.random
    @round = Round.create(footballer: @footballer)

    p @round
  end

  def new_guess
    @round = Round.find(params[:id])
    
    prompt = @round.footballer.build_prompt
    user_message = new_guess_params[:message]

    @response = GeminiAiService.new(max_output_tokens: 100).generate_content(user_message:, prompt:)
    @round.guesses.create!(message: user_message, response: @response)

    total_guesses = @round.total_guesses + 1
    if @response == "Correct"
      @round.update(result: :success, total_guesses:)
    else
      update = { total_guesses: }
      update[:result] = :failed if total_guesses >= Round::MAX_ATTEMPTS

      @round.update(update)
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def new_guess_params
    params.require(:guess).permit(:message)
  end
end
