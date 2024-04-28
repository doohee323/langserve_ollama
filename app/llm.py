from langchain_openai import ChatOpenAI
from langchain_community.chat_models import ChatOllama
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate

# LangChain이 지원하는 다른 채팅 모델을 사용합니다. 여기서는 Ollama를 사용합니다.
llm = ChatOllama(model="EEVE-Korean-10.8B:latest")

# llm = ChatOpenAI(
#     base_url="http://sionic.chat:8001/v1",
#     api_key="934c4bbc-c384-4bea-af82-1450d7f8128d",
#     model="xionic-ko-llama-3-70b",
# )
