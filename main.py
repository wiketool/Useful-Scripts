# -*- coding: utf-8 -*-
# !/usr/bin/env python
# Copyright 2021 ZhangT. All Rights Reserved.
# Author: zhangt2333
# main.py 2021/5/25 0:25
import os

import spider


def run():
    building = os.environ.get('BUILDING')
    room = os.environ.get('ROOM')
    result_str = str(spider.query('010000', building, room))
    print(result_str)
    print("执行成功")
    return result_str

