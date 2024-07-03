from utils.llm_utils import llm_interface

if __name__ == "__main__":

    model_interface = llm_interface.ModelInterface(
        model_name="mistral-8b",
        temperature=0.1,
        self_host=True,
    )

    prompt = model_interface.combine_prompt_with_context(
        prompt="Validate this activity Json provided in the context",
        context="""{
            Json that would be validated
        }""",
        examples="""{      
            Examples that would have been pulled from the database    
        }""",
    )
    
    result = model_interface.ask_question(
        prompt=prompt,
    )
    
    print("\n\n")
    print(result)
    print("\n\n")
