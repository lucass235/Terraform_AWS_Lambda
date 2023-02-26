import os
import requests
import err.custom_err as customErr
from dotenv import load_dotenv
load_dotenv()

def getData(user_name):
    try:
        request = requests.get(os.getenv("URL_LINKEDIN_ID"))
        if user_name == 'notFound':
            raise customErr.NotFoundErr("User name not found")
        return request.json()
    except Exception as err:
        raise err
    

def getEmail(user_name):
    try:
        request = requests.get(os.getenv("URL_LINKEDIN_EMAIL"))
        if user_name == 'notFound':
            raise customErr.NotFoundErr("User name not found")
        return request.json()
    except Exception as err:
        raise err
   