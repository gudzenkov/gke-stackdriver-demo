#!/usr/local/bin/python3
import os, http.client, ssl, json, click, csv
from flask import Flask, request, make_response, jsonify, render_template
from flask_cli import FlaskCLI

app = Flask(__name__)
FlaskCLI(app)

@app.cli.command()
@click.argument('uptime_checks_dict', type=click.File('r'))
@click.argument('terraform_file', type=click.File('w'))
def render(uptime_checks_dict,terraform_file):
  click.echo("Loading dict {}..".format(uptime_checks_dict.name))
  uptime_checks=csv.DictReader(uptime_checks_dict, fieldnames=['name','uri', 'code', 'auth', 'matcher'], delimiter='\t')
  # for row in uptime_checks:
  #   print(row)

  click.echo("Generating {}..".format(terraform_file.name))
  rendered = render_template('uptime_checks.tf.j2', checks=uptime_checks)
  terraform_file.write(rendered)
  terraform_file.close()
  click.echo("Done.".format())

if __name__ == "__main__":
    render()
