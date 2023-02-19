import json
import os
import zipfile

zip_file_name = "lambda_function.zip"
file_to_zip = "lambda_function.py"

if os.path.exists(zip_file_name):
    print("Removing existing zip file")
    os.remove(zip_file_name)
    
zip_file = zipfile.ZipFile(zip_file_name, "w")
zip_file.write(file_to_zip)
zip_file.close()

def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!, terraform, lambda, python')
    }
    
    