#!/usr/bin/env python3
"""
Usage:
python template_generator.py release_issues monthly_issues
"""

import json
from jinja2 import Environment, FileSystemLoader
from os_environ_fetch import fetch_environment_variables  # os_environ_fetch.py
from arguments_fetch import fetch_arguments               # arguments_fetch.py


def main():
    fetch_environment_variables()
    table_name_01 = fetch_arguments(1)          # 1 == first argument, sys.argv[1]
    table_name_02 = fetch_arguments(2)

    cnf_file = set_variables()
    all_content = load_json(cnf_file)

    prepare_template(all_content, cnf_file)


def set_variables():
    cnf_file: str = 'templates/dev.env.json'
    return cnf_file


# loading json from file
def load_json(cnf_file):
    with open(cnf_file, 'r') as json_file:
        env_dict = json.load(json_file)

    all_content = env_dict['env']  # removing top env category
    return all_content


# jinja environment setting
def prepare_template(all_content, cnf_file):
    file_loader = FileSystemLoader('templates')
    env = Environment(loader=file_loader)
    template = env.get_template('about.html')

    output = template.render(all_content=all_content, cnf_file=cnf_file)
    print(output)


main()