#!/usr/bin/env python3
# usage: ./src/python/jinja_tpl_generator/jinja_tpl_generator.py

import sys
import os
import os.path as path
import yaml
import json
import glob
from jinja2 import Environment, BaseLoader
import pprint

product_instance_dir, json_conf_file, dic_yml, pp = '', '', '', ''

def main():
    set_vars()
    generate_templates(dic_yml)
    sys.exit(0)

def set_vars():
    try:
        global product_instance_dir, json_conf_file, dic_yml, pp
        pp = pprint.PrettyPrinter(indent=3)
        product_instance_dir = path.abspath(path.join(__file__ ,"../../../.."))
        read_env_conf_file(product_instance_dir + '/.env') # env agnostic
        env = os.environ['ENV_TYPE']
        dic_yml = read_yaml_file( product_instance_dir + '/cnf/env/' + env  + '.env.yml' )
        json_conf_file = product_instance_dir + '/cnf/env/' + env + '.env.json'
        # print(json.dumps(dic_yml, indent=3, sort_keys=True),  file=open(json_conf_file, 'w'))

    except(IndexError) as error:
        print ("ERROR in set_vars: " , str(error)) 
        traceback.print_stack()
        sys.exit(1)


def read_env_conf_file(f):
    try:
        with open(f, 'r') as fh:
            vars_dict = dict(
                tuple(line.rstrip().split('='))
                for line in fh.readlines() if not line.startswith('#')
            )
        os.environ.update(vars_dict)
    except (Exception) as error:
        print('ERROR in read_env_conf_file:' , error)
        traceback.print_stack()
    finally:
        print("RUNNING in the following env: " , vars_dict)


def read_yaml_file(env_yaml_conf_file):
    with open(env_yaml_conf_file) as f:
        return yaml.load(f, yaml.SafeLoader)


def generate_templates(dic_yml):
    for f in glob.iglob( product_instance_dir + '/src/tpl/**/*.tpl', recursive=True):
        try:
            print ( "read template file: " , f)
            # pp.pprint (dic_yml['env'])
            str_tpl = open(f, 'r').read()
            obj_tpl = Environment(loader=BaseLoader).from_string(str_tpl)
            rendered = obj_tpl.render(dic_yml['env'])
            tgt_fle = f.replace('/src/tpl','',1).replace('.tpl','')
            # print (rendered)
            print(rendered,  file=open(tgt_fle, 'w'))
            print ( "output ready rendered file : " , tgt_fle)
        except Exception as e:
            print ("RENDERING EXCEPTION: \n", str(e))
            traceback.print_stack()
    print("STOP generating templates")


main()
