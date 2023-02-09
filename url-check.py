import os
import requests

# try:
#     url_test = os.environ["url"]
# except KeyError:

url_test = os.environ['url']
y='http://' + url_test

def get_status():
    x = requests.get(y)
    print(x.status_code)
    return str(x.status_code)
get_status()