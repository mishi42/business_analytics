library(LLMAgentR)
library(chatLLM)

my_llm_wrapper <- call_llm(
  api_key = "ollama",
  provider    = "openai",
  model       = "llama3.2",
  max_tokens  = 30,
  verbose = TRUE,
  endpoint_url = "http://localhost:11434/v1/chat/completions"
)

coder_agent <- build_code_agent(
  llm = my_llm_wrapper,
  max_tries = 3,
  backoff = 2,
  verbose = T,
)

result <- coder_agent("Write an R function to standardize numeric columns in a data frame using dplyr. No examples or explanation")

result
