from .llm_interface import ModelInterface
from .constants import specific_field_instruction_map, regex_map, field_values_map
from .backend_utils import get_activities_in_city
import json
import random


def get_n_activities_from_db_as_examples(
    n,
    *,
    include_photos=False,
    include_reviews=False,
    include_frequently_asked_questions=False,
    include_google_customer_pics=False,
    include_google_reviews=False,
    include_google_place_id=False,
):
    activities_in_db = get_activities_in_city("San Francisco")
    random.shuffle(activities_in_db)
    n_activities_list = activities_in_db[:n]

    for activity in n_activities_list:
        if not include_photos:
            activity["photos"] = ""
        if not include_reviews:
            activity["reviews"] = ""
        if not include_frequently_asked_questions:
            activity["frequentlyAskedQuestions"] = ""
        if not include_google_customer_pics:
            activity["googleCustomerPics"] = ""
        if not include_google_reviews:
            activity["googleReviews"] = ""
        if not include_google_place_id:
            activity["googlePlaceId"] = ""

    output = [
        json.dumps(
            activity,
            indent=2,
            separators=(",", ": "),
        )
        for activity in n_activities_list
    ]
    return output


def get_n_examples_of_fields_from_db(*, n, field_name):
    activities_in_db = get_activities_in_city("San Francisco")
    random.shuffle(activities_in_db)
    n_activities_list = activities_in_db[:n]
    output = []
    for activity in n_activities_list:
        output.append({field_name: activity[field_name]})

    return output


def create_generate_activity_prompt():

    return ModelInterface.combine_prompt_with_context(
        context=f"""
            You are a language model meant to make fake data for activities. I will give you 5 inputs, a json template, a list of example activities, a specific_field_instruction_map, a regex_map, and a field_values_map. For any activity you generate follow these instructions:
            
            1. Make sure to follow the json schema.
            
            2. Make sure there are no duplicate fields. 
            
            3. For each field, use the specific_field_instruction_map to generate a field if it's in the keys, but follow the examples otherwise. 
            
            4. For each field, if it exists in the keys of the field_values_map, then only use the values provided in the field_values_map. 
            
            5. Use the corresponding regex provided in the regex_map below. If there is a field in the json template but is not in the examples, makes it's value an empty string "".

            specific_field_instruction_map: {specific_field_instruction_map}
            
            regex_map: {regex_map}
            
            field_values_map: {field_values_map}
            
            """,
        prompt="Generate one activity for water polo using the instructions given in the context.",
        examples=get_n_activities_from_db_as_examples(3),
    )


def create_validate_activity_prompt(*, activity_to_validate):
    return ModelInterface.combine_prompt_with_context(
        context=f"""
            You are a language model meant to make data for activities and validate they are correct. I will give you 5 inputs, an activity to validate, a list of previously validated activities, a specific_field_instruction_map, a regex_map, and a field_values_map. Using these 5 inputs, you must do the following:
            
            1. Check if the activity to validate follows the regular expressions provided in regex_map. If the value doesn't follow the corresponding regular expression, generate a value for that field based on what it was previously that does follow the regular expression.
            
            2. Make sure there are no duplicate fields. 
            
            3. Check if the activity to validate follows the instructions provided in specific_field_instruction_map for the corresponding field. If there is no entry in the specific_field_instruction_map, use the examples instead. If the value doesn't follow the corresponding instruction, generate a value for that field based on what it was previously that does follow the specific field instruction.
            
            4. Check if the values in the activity to validate are allowed based on the field_values_map. If they are not allowed, replace them with a value from the field_values_map. Note that the name field is an exception.
            
            Activity to Validate: {activity_to_validate}
            
            specific_field_instruction_map: {specific_field_instruction_map}
            
            regex_map: {regex_map}
            
            field_values_map: {field_values_map}
            
            """,
        prompt="Check the activity to validate based on the information given in the context. Return a version of the activity to validate that passes all the above checks.",
        examples=get_n_activities_from_db_as_examples(3),
    )
