#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from collections import defaultdict as defaultdict
from xml.etree import ElementTree

import uuid  # added

# some constants for local debugging
_input_file = 'input.txt'
_output_file = 'output.txt'

def _mapper():
    """ Mapper that reads whole XML file and sends it to Reducer."""

    xml = ''
    unique_key = str(uuid.uuid4().get_hex().upper())

    for line in sys.stdin:
        line = line.strip()
        xml += line #+ '\n'

    print ('{0}\t{1}'.format(unique_key, xml))

    try:
        root = ElementTree.fromstring(xml)
        print ('{0}\t{1}'.format(unique_key, str(root)))
    except Exception,ex:
        print ('{0}\t[e]{1}'.format(unique_key, str(ex)))


def run(from_file=False):
    """ Running scripts methods """

    if (from_file):
        sys.stdin = open(_input_file, "r")
        sys.stdout = open(_output_file, "w")

    _mapper()

if __name__ == '__main__':
    #run(True)
    run()