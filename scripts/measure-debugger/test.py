import pprint

import requests

url_pass = "http://localhost:8051/library/evaluation?periodStart=2024-01-01&periodEnd=2025-01-01&clearCache=true&expressions=Laboratory Tests Identifying Sexual Activity&libraryId=ChlamydiaScreeninginWomenFHIR&patientIds=51249f421ad8b97f8bd60d3428cbe7449895675526cc2234229f8503a74c3c6b"
url_fail = "http://localhost:8051/library/evaluation?periodStart=2024-01-01&periodEnd=2025-01-01&clearCache=true&expressions=Laboratory Tests Identifying Sexual Activity&patientIds=14f50c031d6764952ab559e54182bf1314b4233fc1fea3e2fa087ebf8a96cdb7&libraryId=ChlamydiaScreeninginWomenFHIR"
payload = {}
headers = {}

# response = requests.request("GET", url_pass, headers=headers, data=payload)
response = requests.request("GET", url_fail, headers=headers, data=payload)

response_json = response.json()
print(type(response_json))
print(not (response_json))
if type(response_json) == list:
    for item in response_json:
        print(type(item))
pprint.pprint(response_json)
