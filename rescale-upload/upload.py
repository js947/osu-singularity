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

response = r.json()
pprint.pprint(response)

print("::set-output name=status::%s" % r.status_code)
print("::set-output name=id::%s" % response['id'])
