class GeminiAiService

  attr_reader :temperature, :max_output_tokens

  def initialize(max_output_tokens:, temperature: 0.1)
    @temperature = temperature
    @max_output_tokens = max_output_tokens

    @client = Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: Rails.application.credentials.dig(:gemini, :api_key),
        version: 'v1beta'
      },
      options: { model: 'gemini-1.5-flash', server_sent_events: false }
    )
  end

  def generate_content(user_message:, prompt:)
    result = @client.generate_content({
      generationConfig: get_generation_config,
      system_instruction: {
        role: 'user',
        parts: {
            text: prompt
        }
      },
      contents: { 
        role: 'user',
        parts: { 
          text: user_message 
        } 
      }
    })

    result.dig("candidates", 0, "content", "parts", 0, "text")&.strip
  end

  private 

  def get_generation_config
    {
      temperature: temperature,
      maxOutputTokens: max_output_tokens
    }
  end
end