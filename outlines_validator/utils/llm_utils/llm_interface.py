from outlines import models, generate, prompt
from outlines.models.openai import OpenAIConfig, OpenAI
import torch
from openai import AsyncOpenAI
from transformers import AutoTokenizer
from vllm_client import SamplingParams

self_host_api_key = "EMPTY"
self_host_url = "REDACTED_LAMBDA_URL"

model_choices = [
    "gpt-3.5-turbo",
    "gpt-4",
    "mistral-7b",
    "mistral-8b",
    "llama-8b",
    "llama-70b",
    "llama-70b-gptq",
    "grok-1",
    "sn-13b",
]

hugging_face_names = {
    "mistral-7b": "mistralai/Mistral-7B-Instruct-v0.2",
    "mistral-8b": "mistralai/Mixtral-8x7B-Instruct-v0.1",
    "llama-8b": "gradientai/Llama-3-8B-Instruct-262k",
    "llama-70b": "meta-llama/Meta-Llama-3-70B-Instruct",
    "llama-70b-gptq": "MaziyarPanahi/Meta-Llama-3-70B-Instruct-GPTQ",
    "grok-1": "hpcai-tech/grok-1",
    "sn-13b": "sambanovasystems/SN-13B-8k-Instruct",
}

constants_map = {
    "temperature": 1.0,
    "do_sample": True,
    "trust_remote_code": True,
    "torch_dtype": torch.float16,
    "device_map": "auto",
}

vllm_constants_map = {
    "trust_remote_code": True,
}


class ModelInterface:
    def __init__(
        self,
        *,
        model_name: str,
        api_key="",
        model_kwargs={},
        temperature=constants_map["temperature"],
        do_sample=constants_map["do_sample"],
        trust_remote_code=constants_map["trust_remote_code"],
        torch_dtype=constants_map["torch_dtype"],
        device_map=constants_map["device_map"],
        use_vllm=False,
        self_host=False,
    ):
        self.model_name = model_name
        self.self_host = self_host
        if model_name.lower() not in model_choices:
            raise Exception(
                f"Model Choice invalid! Please choose from the following: {model_choices}"
            )
        else:
            constants_map = (
                {
                    "temperature": temperature,
                    "do_sample": do_sample,
                    "trust_remote_code": trust_remote_code,
                    "torch_dtype": torch_dtype,
                    "device_map": device_map,
                }
                if use_vllm == False
                else {
                    "trust_remote_code": trust_remote_code,
                }
            )
            merged_kwargs = dict(constants_map.items() | model_kwargs.items())

            self.initiate_model(
                model_name=model_name.lower(),
                api_key=api_key,
                temperature=temperature,
                model_kwargs=merged_kwargs,
                use_vllm=use_vllm,
                self_host=self_host,
            )

    def initiate_model(
        self,
        *,
        model_name: str,
        api_key,
        temperature,
        model_kwargs,
        use_vllm,
        self_host,
    ):
        if self_host == True:
            client = AsyncOpenAI(
                api_key=self_host_api_key,
                base_url=self_host_url,
            )
            config = OpenAIConfig(
                model=hugging_face_names[model_name],
                temperature=temperature,
            )
            tokenizer = AutoTokenizer.from_pretrained(
                hugging_face_names[model_name],
                **{"padding_side": "left"},
            )
            self.model = OpenAI(
                client,
                config,
                tokenizer=tokenizer,
            )
        elif "gpt-" in model_name:
            if api_key == "":
                raise Exception(f"API Key needed for gpt model!")
            else:
                self.model = models.openai(
                    model_name,
                    api_key=api_key,
                    config=OpenAIConfig(
                        temperature=temperature,
                    ),
                )
        elif use_vllm:
            self.model = models.vllm(
                hugging_face_names[model_name],
                **model_kwargs,
            )
        else:
            self.model = models.transformers(
                hugging_face_names[model_name],
                model_kwargs=model_kwargs,
            )

    @prompt
    def combine_prompt_with_context(
        *, prompt: str, context: str, examples: list = []
    ) -> None:
        """
        Context: {{ context }}
        --------
        Prompt: {{ prompt }}
        --------
        Examples
        --------
        {% for example in examples %}
        Example: {{ example }}
        {% endfor %}
        """

    def ask_for_a_choice(
        self,
        *,
        prompt: str,
        choices: list[str],
        max_tokens=None,
        params=SamplingParams(),
    ) -> str:
        """
        The choices must be a list of str like ["Positive", "Negative"]
        """
        try:
            generator = generate.choice(self.model, choices)
            return generator(
                prompt,
                max_tokens=max_tokens,
            )
        except Exception as e:
            print(e)

    def ask_question(
        self,
        *,
        prompt: str,
        regex_for_output="",
        max_characters=None,
        stop_at="",
        params=SamplingParams(),
    ) -> str:
        try:
            if regex_for_output != "":
                generator = generate.regex(self.model, regex_for_output)
                answer = generator(
                    prompt,
                    max_tokens=max_characters,
                )
                return answer
            else:
                if stop_at != "":
                    generator = generate.text(self.model)
                    answer = generator(
                        prompt,
                        max_tokens=max_characters,
                        stop_at=stop_at,
                    )
                else:
                    generator = generate.text(self.model)
                    answer = generator(
                        prompt,
                        max_tokens=max_characters,
                    )
                return answer
        except Exception as e:
            print(e)

    def generate_json(
        self,
        *,
        prompt: str,
        json_schema: str,
        params=SamplingParams(),
    ):
        """
        The json_schema needs to be a string structured like this:
        {
            "title": "User",
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "last_name": {"type": "string"},
                "id": {"type": "integer"},
            }
        }
        """
        try:
            if "gpt" in self.model_name or self.self_host == True:
                adjusted_prompt = f"The provided json schema is {json_schema}\n{prompt}"
                return self.ask_question(
                    prompt=adjusted_prompt,
                )
            else:
                generator = generate.json(
                    self.model,
                    json_schema,
                )
                return generator(
                    prompt,
                )
        except Exception as e:
            print(e)


@prompt
def create_prompt_for_generating_with_instructions(
    *, prompt: str, instructions: str, examples: list = []
) -> None:
    """
    Prompt: {{ prompt }}
    --------
    Instructions: {{ instructions }}
    --------
    Examples
    --------
    {% for example in examples %}
    Example: {{ example }}
    {% endfor %}
    """
