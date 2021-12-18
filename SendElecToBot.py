import os

import requests

from main import run


def send(msg):
    domain = os.environ.get('BOTIP')
    access_token = os.environ.get('BOT_ACCESS_TOKEN')
    id = os.environ.get('GROUP')
    headers = {'Authorization': access_token}
    delete_url = 'delete_msg'
    send_json = {
        'group_id': id,
        'message': "当前剩余电费" + msg
    }
    res = requests.post(url=domain, json=send_json, headers=headers, proxies=None)
    print(res)


if __name__ == '__main__':
    msg = run()
    send(msg)
