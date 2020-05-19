#!/usr/bin/env python
import os, sys
import requests

token = os.environ['RESCALE_API_TOKEN']
platform = os.environ['RESCALE_PLATFORM']
filename = sys.argv[1]

requests.post(
  'https://%s/api/v2/files/contents/' % platform,
  headers={'Content-Type': 'multipart/form-data',
           'Authorization': 'Token %s' % token},
  files={'file': open(filename, 'rb')}
)
