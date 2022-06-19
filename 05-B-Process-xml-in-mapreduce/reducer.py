#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from collections import defaultdict as defaultdict

# some constants for local debugging
_input_file = 'input.txt'
_output_file = 'output.txt'

def _reducer():
    """ Reducer that iterates through provided input and just prints it."""

    for line in sys.stdin:
        line = line.strip()
        tag, text = line.split('\t')
        print('{0}:\t{1}'.format(tag, text))

def run(from_file=False):
    """ Running scripts methods """

    if (from_file):
        sys.stdin = open(_input_file, "r")
        sys.stdout = open(_output_file, "w")

    _reducer()

if __name__ == '__main__':
    #run(True)
    run()