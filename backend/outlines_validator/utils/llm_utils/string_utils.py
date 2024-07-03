import json


def generate_outlines_json_schema_from_json(*, title, json_input):
    json_dict = (
        json.loads(json_input, strict=False) if type(json_input) == str else json_input
    )
    formatted_dict = {"title": title, "type": "object", "properties": {}}
    for key, value in json_dict.items():
        formatted_dict["properties"][key] = {"type": "string"}
    formatted_json = json.dumps(formatted_dict, indent=4)
    return formatted_json
