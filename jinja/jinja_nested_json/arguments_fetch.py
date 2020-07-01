#!/usr/bin/env python3
"""
Fetches arguments passed to template_generator.py
"""

import sys


def fetch_arguments(index):
    if len(sys.argv) < 2:
        print('Too few arguments.')
        print('Usage: ' + sys.argv[0] + ' release_issues monthly_issues')
        sys.exit(1)

    table_name = sys.argv[index]
    print('This is the %s argument, table_name_0%s: %s' % (index, index, table_name))  # release_issues
    return table_name
