import json
from json import dumps
import api.linkedin as linkedin
import validation.user_name as validateUser
import validation.data as validateData
import err.custom_err as customErr


def lambda_handler(event, context):

    try:

        user_name = event['queryStringParameters']['userName']
        validateUser.validate_user_name(user_name)
        data_api_linkedin = linkedin.getData(user_name)
        data_api_linkedin_email = linkedin.getEmail(user_name)
        data = validateData.data_validate(
            data_api_linkedin, data_api_linkedin_email)

        body = {
            "ID": data['ID'],
            "name": data['Name'],
            "lastName": data['LastName'],
            "email": data['Email']
        }

        response = {
            'statusCode': 200,
            'body': json.dumps(body)
        }
        return response

    except customErr.NotFoundErr as err:
        return {
            'statusCode': 404,
            'body': dumps(F'{err}')
        }

    except customErr.RequiredErr as err:
        return {
            'statusCode': 407,
            'body': dumps(F'{err}')
        }

    except Exception as err:
        return {
            'statusCode': 500,
            'body': json.dumps(F'{err}')
        }
