#!/usr/bin/env python
import os, sys
import pprint
import requests

token = os.environ['INPUT_RESCALE_TOKEN']
platform = os.environ['INPUT_RESCALE_PLATFORM']
filename = sys.argv[1]

with open(filename, 'rb') as f:
    r = requests.post(
      'https://%s/api/v2/files/contents/' % platform,
      headers={#'Content-Type': 'multipart/form-data',
               'Authorization': 'Token %s' % token},
      files={'file': f}
    )

print("status=", r.status_code)
print("response")
pprint.pprint(r.json())
