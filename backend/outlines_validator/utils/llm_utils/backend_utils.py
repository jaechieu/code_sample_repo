import requests, json


def get_group_types_from_backend():
    json_output = {}
    while json_output == {}:
        request_output = requests.get(
            "REDACTED_LAMBDA_URL",
        )
        json_output = json.loads(request_output.content)
    return json_output["groupTypesOptionList"]


def get_categories_from_backend():
    json_output = {}
    while json_output == {}:
        request_output = requests.get(
            "REDACTED_LAMBDA_URL",
        )
        json_output = json.loads(request_output.content)
    return json_output["categoriesOptionList"]


def get_group_types_in_json(activity_json):
    output_map = {}
    for activity in activity_json:
        activity_type = activity["name"].split(" - ")[0].lower()
        if activity_type in output_map:
            output_map[activity_type] += 1
        else:
            output_map[activity_type] = 1
    return output_map


def get_activities_in_city(city):
    json_output = {}
    while json_output == {}:
        request_output = requests.get(
            "REDACTED_LAMBDA_URL",
            params={"city": city},
        )
        json_output = json.loads(request_output.content)
    return json_output
