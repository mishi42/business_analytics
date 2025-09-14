
# check the models can be used
library(ollamar)
ollamar::list_models(host = "http://ollama:11434")

library(mall)
data("reviews")

# apply sentiment analysis to review data
options(.mall_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))

reviews |>
  llm_sentiment(review)


