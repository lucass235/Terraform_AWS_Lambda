
def data_validate(user, email):
    try:
        data = {}
        data['ID'] = user['id']
        data['Name'] = user['localizedFirstName']
        data['LastName'] = user['localizedLastName']
        data['Email'] = email['elements'][0]['handle~']['emailAddress']
        return data
    except Exception as err:
        raise err
        