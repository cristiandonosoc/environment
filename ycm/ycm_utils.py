# separate_tokens splits works within the string, but considers elements in quotes to be one single
# token, even if it has spaces in it.
def separate_tokens(input_string):
    result = []
    current_word = ""
    in_quotes = False
    for char in input_string:
        if char == " " and not in_quotes:
            if current_word:
                result.append(current_word)
                current_word = ""
        elif char == '"':
            in_quotes = not in_quotes
        else:
            current_word += char
    if current_word:
        result.append(current_word)
    return result
