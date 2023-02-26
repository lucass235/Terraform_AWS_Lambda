import err.custom_err as customErr


def validate_user_name(userName):
    if not userName:
        raise customErr.RequiredErr("user name is required")
    return  True    