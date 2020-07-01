#!/usr/bin/env python3

"""
Fetches environment variables to be used within template_generator.py
"""

import os


def fetch_environment_variables():
    key = 'HOME'
    value = os.getenv(key)

    # Print the value of 'HOME'
    # environment variable
    print("Value of 'HOME' environment variable:", value)
