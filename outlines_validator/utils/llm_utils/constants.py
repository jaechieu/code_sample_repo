from .backend_utils import (
    get_activities_in_city,
    get_group_types_in_json,
    get_categories_from_backend,
    get_group_types_from_backend,
)

csv_regex = r"\^([\^,]+(?:,[\^,]+)*)\$|\^\$"
decimal_regex = r"^[0-9]+\.[0-9]+$"
specific_field_instruction_map = {
    "name": "Generate one name with the following requirements based on the text on screen and other information given. Make sure the name is of the form 'Activity Type - Unique Identifier', where 'Activity Type' is taken from the field_values_map's value for name, and Unique Identifier is a 2-3 word statement that describes the activity. If the field_values_map doesn't have an activity type that fits, make one that follows the same naming convention as previous values. Make sure the regex in regex_map for name is followed. Make sure the name of the host or the name of the business is not included in the 'Activity Type' or 'Unique Identifier' at all, even partially. If you have trouble finding the unique identifier, just use the neighborhood. Don't respond with anything besides something that follows the regular expression. Do not explain any reasoning.",
    "description": "Generate a description with the following requirements based on the text on screen and other information given. Make sure the description field value is at least 800 characters. Replace all line breaks in the description with a \n. Make sure the name of the host or business is not included in the description, even partially. If it already has \n in it, don't remove them. Ensure the description is professional, cool, and informative, include specific information about the activity and what's included. Briefly talk about who it's good for and the value from doing the activity. Write it in second person. Don't use question. Refer to the booking/offering in third person. Don't include information about pricing, group size, duration, the booking process, making a reservation, payment, or the name of the company/business offering it. Use a greeting that plays on the activity, and use newlines to make the text more readable. Remove all special characters that are not '\n'. Don't use accented characters. Do not explain any reasoning.",
    "datetimeJson": "Put an escape character (forward slash \ ) in front of all double quotes in this field. Then, wrap the entire datetimeJson value in a pair of quotes to make it a string.",
    "duration": "Make sure it is a value between 1.0 and 4.0",
    "photos": "Leave blank",
    "googleInfo": "Leave blank",
    "googlePlaceId": "Leave blank",
    "googleReviews": "Leave blank",
    "googleCustomerPics": "Leave blank",
    "minimumBookAheadBuffer": "Must be at least 1.0",
    "rsvpBuffer": "Must be at least 1.0",
    "reviews": "Don't change. Replace all accented characters with non-accented characters.",
}
field_values_map = {
    "name": list(
        get_group_types_in_json(get_activities_in_city("San Francisco")).keys()
    ),
    "tags": list(get_categories_from_backend()),
    "groupType": list(get_group_types_from_backend()),
    "canHavePhotographer": ["true", "false"],
    "reservationType": ["per-person", "group"],
}
regex_map = {
    "id": r"^([1-9]{1}|[1-9]+[0-9]+)$",
    "name": r"^[^-]*-[^-]*$",
    "phoneNumber": r"^\+[0-9]+$",
    "location": r"^[^,]*,[^,]*,[^,]*,[^,]*[^,]$",
    "latitude": r"^([0-9]{1,3}\.[0-9]+)|(\-[0-9]{1,3}\.[0-9]+)$",
    "longitude": r"^([0-9]{1,3}\.[0-9]+)|(\-[0-9]{1,3}\.[0-9]+)$",
    "duration": decimal_regex,
    "minimumBookAheadBuffer": decimal_regex,
    # used for tags, included fields, bring fields, photos, groupTypes
    "tags": csv_regex,
    "includedFood": csv_regex,
    "includedDrinks": csv_regex,
    "includedMisc": csv_regex,
    "includedEquipment": csv_regex,
    "bringFood": csv_regex,
    "bringDrinks": csv_regex,
    "bringMisc": csv_regex,
    "bringEquipment": csv_regex,
    "url": r"/[A-Za-z]+:\/\/w+\..*\./gm",
    "price": r"^([0-9]){1,2}\.([0-9]){1,2}$",
    "rating": r"^[0-5]{1}\.[0-9]{1,2}$",
    "ratingSampleSize": r"^[0-9]{1,4}$",
    "minPeople": r"^([2-9]{1}|[1-9]{1}[0-9]{1})$",
    "maxPeople": r"^([2-9]{1}|[1-9]{1}[0-9]{1})$",
    "rank": r"^[0-5]{1}$",
    "reviews": r"^([^\|^\_]*\|[^\|^\_]*){3}[^\|^_]*((?:_([^\|^\_]*\|[^\|^\_]*){3}[^\|^_\s]*))*[^\|^_]$|^$",
    "faq": r"^([^\|^\_]+\|[^\|^\_]+(?:_[^\|^\_]+\|[^\|^\_]+)*)$|^$",
}
