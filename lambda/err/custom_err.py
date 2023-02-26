
class NotFoundErr(Exception):
    def __init__(self, msg):
        self.msg = msg


class RequiredErr(Exception):
    def __init__(self, msg):
        self.msg = msg


class InvalidErr(Exception):
    def __init__(self, msg):
        self.msg = msg
