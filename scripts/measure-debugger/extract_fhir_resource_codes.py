import datetime
import json
import os
import pprint
import re
from typing import Dict, List

import pandas as pd
import requests
from fhirclient.models.bundle import Bundle
from fhirclient.models.coding import Coding
from fhirclient.models.condition import Condition
from fhirclient.models.diagnosticreport import DiagnosticReport
from fhirclient.models.documentreference import DocumentReference
from fhirclient.models.observation import Observation
from fhirclient.models.procedure import Procedure
from fhirclient.models.servicerequest import ServiceRequest
from tenacity import retry, retry_if_exception, stop_after_attempt, wait_exponential
from tqdm import tqdm

FHIR_BASE_URL = "http://localhost:8089/fhir"


def should_retry(exception):
    print(f"Retrying due to exception: {exception}")
    return True
    # return isinstance(exception, requests.exceptions.HTTPError) and exception.response.status_code == 504


@retry(
    stop=stop_after_attempt(5),
    wait=wait_exponential(multiplier=1, min=4, max=10),
    retry=retry_if_exception(should_retry),
)
def get_resources_with_retry(url, headers, params):
    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()  # Raise an error for bad responses
    return response


def coding_to_string(coding):
    """
    Convert a FHIR Coding object to a string representation.

    Args:
        coding (Coding): The FHIR Coding object.

    Returns:
        str: The string representation of the Coding object.
    """
    system = coding.system if coding.system else ""
    code = coding.code if coding.code else ""
    display = coding.display if coding.display else ""
    return f"{system}::{code}::{display}"


def extract_procedure(resource):
    res = Procedure(resource)
    coding = res.code.coding if res.code and res.code.coding else []
    text = res.code.text
    id = res.id

    def extract_performed_datetime(resource: Procedure):
        if resource.performedDateTime:
            return res.performedDateTime.isostring
        if resource.performedPeriod:
            return resource.performedPeriod
        if resource.performedString:
            return resource.performedString
        if resource.performedRange:
            return resource.performedRange
        if resource.performedAge:
            return resource.performedAge
        return ""

    ts = extract_performed_datetime(res)
    status = res.status
    return coding, text, id, ts, status


def extract_condition(resource):
    res = Condition(resource)
    coding = res.code.coding if res.code and res.code.coding else []
    text = res.code.text
    id = res.id

    def extract_performed_datetime(resource: Condition):
        if resource.onsetDateTime:
            return res.onsetDateTime.isostring
        if resource.onsetPeriod:
            return resource.onsetPeriod
        if resource.onsetString:
            return resource.onsetString
        if resource.onsetRange:
            return resource.onsetRange
        if resource.onsetAge:
            return resource.onsetAge
        return ""

    ts = extract_performed_datetime(res)
    status = ""
    return coding, text, id, ts, status


def extract_observation(resource):
    res = Observation(resource)
    coding = res.code.coding if res.code and res.code.coding else []
    text = res.code.text
    if "Pap" in text or "HPV" in text:
        print(f"Observation: {text}")
    id = res.id

    def extract_effective_datetime(resource: Observation):
        if resource.effectiveDateTime:
            return res.effectiveDateTime.isostring
        if resource.effectiveInstant:
            return resource.effectiveInstant
        if resource.effectivePeriod:
            return resource.effectivePeriod
        if resource.effectiveTiming:
            return resource.effectiveTiming

    ts = extract_effective_datetime(res)
    status = res.status
    return coding, text, id, ts, status


def extract_service_request(resource):
    res = ServiceRequest(resource)
    coding = res.code.coding if res.code and res.code.coding else []
    text = res.code.text
    id = res.id

    def extract_datetime(resource: ServiceRequest):
        if resource.occurrenceDateTime:
            return res.occurrenceDateTime.isostring
        if resource.occurrencePeriod:
            t = "- "
            if res.occurrencePeriod.start:
                t = f"{res.occurrencePeriod.start.isostring} - "
            if res.occurrencePeriod.end:
                t = f"{t}{res.occurrencePeriod.end.isostring}"
            return t
        if resource.occurrenceTiming and resource.occurrenceTiming.code:
            return resource.occurrenceTiming.code.text
        return ""

    ts = extract_datetime(res)
    status = res.status
    return coding, text, id, ts, status


def extract_document_reference(resource):
    res = DocumentReference(resource)
    id = res.id
    ts = res.date.isostring
    status = res.status
    attachments = [{c.attachment.title, c.attachment.url} for c in res.content]
    return {
        "type": res.resource_type,
        "attachments": attachments,
        "timestamp": ts,
        "status": status,
        "id": id,
    }


def extract_diagnostic_report(resource):
    res = DiagnosticReport(resource)
    id = res.id

    def extract_datetime(res: DiagnosticReport):
        if res.effectiveDateTime:
            return res.effectiveDateTime.isostring
        if res.effectivePeriod:
            t = "- "
            if res.effectivePeriod.start:
                t = f"{res.effectivePeriod.start.isostring} - "
            if res.effectivePeriod.end:
                t = f"{t}{res.effectivePeriod.end.isostring}"
            return t
        return ""

    ts = extract_datetime(res)
    status = res.status
    attachments = [{c.title, c.url} for c in res.presentedForm]
    return {
        "type": res.resource_type,
        "attachments": attachments,
        "timestamp": ts,
        "status": status,
        "id": id,
    }


def extract(resource):
    try:
        resource["text"]["div"] = ""
        if resource["resourceType"] == "Procedure":
            coding, text, id, ts, status = extract_procedure(resource)
        elif resource["resourceType"] == "Condition":
            coding, text, id, ts, status = extract_condition(resource)
        elif resource["resourceType"] == "Observation":
            coding, text, id, ts, status = extract_observation(resource)
        elif resource["resourceType"] == "ServiceRequest":
            coding, text, id, ts, status = extract_service_request(resource)
        elif resource["resourceType"] == "DocumentReference":
            return extract_document_reference(resource)
        elif resource["resourceType"] == "DiagnosticReport":
            return extract_diagnostic_report(resource)
        return {
            "coding": [str(code) for code in coding],
            "text": text,
            "id": "",
            "timestamp": ts,
            "status": status,
            "resource_type": resource["resourceType"],
        }
    except Exception as e:
        print(f"Error parsing {resource['resourceType']}: {e}")
        return {}


def get_codes_for_procedures(patientId: str):
    """
    Search for patients based on their postal code and return their IDs.
    """

    url = f"{FHIR_BASE_URL}/Procedure?patient={patientId}"
    resource_count = 10000
    headers = {"Accept": "application/fhir+json"}
    params = {"_count": resource_count, "_offset": 0}
    count = 0
    results = []
    while url:
        response = get_resources_with_retry(url, headers, params)
        count += 1
        response.raise_for_status()  # Raise an error for bad responses
        bundle: Dict = response.json()
        for entry in bundle["entry"] if "entry" in bundle else []:
            results.append(extract(entry["resource"]))
        url = next(
            (link.get("url") for link in bundle["link"] if link["relation"] == "next"),
            None,
        )
        params = None  # Clear params because 'next' link includes all necessary params
        # print(f'Processed {count * resource_count}, {len(results)} results')

    return results


def get_codes_for_conditions(patientId: str):
    """
    Search for patients based on their postal code and return their IDs.
    """

    url = f"{FHIR_BASE_URL}/Condition?patient={patientId}"
    resource_count = 10000
    headers = {"Accept": "application/fhir+json"}
    params = {"_count": resource_count, "_offset": 0}
    count = 0
    results = []
    while url:
        response = get_resources_with_retry(url, headers, params)
        count += 1
        response.raise_for_status()  # Raise an error for bad responses
        bundle: Dict = response.json()
        for entry in bundle["entry"]:
            results.append(extract(entry["resource"]))
        url = next(
            (link.get("url") for link in bundle["link"] if link["relation"] == "next"),
            None,
        )
        params = None  # Clear params because 'next' link includes all necessary params
        # print(f'Processed {count * resource_count}, {len(results)} results')

    return results


def get_codes_for_observations(patientId: str):
    """
    Search for patients based on their postal code and return their IDs.
    """

    url = f"{FHIR_BASE_URL}/Observation?patient={patientId}"
    resource_count = 10000
    headers = {"Accept": "application/fhir+json"}
    params = {"_count": resource_count, "_offset": 0}
    count = 0
    results = []
    while url:
        response = get_resources_with_retry(url, headers, params)
        count += 1
        response.raise_for_status()  # Raise an error for bad responses
        bundle: Dict = response.json()
        for entry in bundle["entry"]:
            results.append(extract(entry["resource"]))
        url = next(
            (link.get("url") for link in bundle["link"] if link["relation"] == "next"),
            None,
        )
        params = None  # Clear params because 'next' link includes all necessary params
        # print(f'Processed {count * resource_count}, {len(results)} results')

    return results


def get_codes_for_service_requests(patientId: str):
    """
    Search for patients based on their postal code and return their IDs.
    """

    url = f"{FHIR_BASE_URL}/ServiceRequest?patient={patientId}"
    resource_count = 10000
    headers = {"Accept": "application/fhir+json"}
    params = {"_count": resource_count, "_offset": 0}
    count = 0
    results = []
    while url:
        response = get_resources_with_retry(url, headers, params)
        count += 1
        response.raise_for_status()  # Raise an error for bad responses
        bundle: Dict = response.json()
        for entry in bundle["entry"] if "entry" in bundle else []:
            results.append(extract(entry["resource"]))
        url = next(
            (link.get("url") for link in bundle["link"] if link["relation"] == "next"),
            None,
        )
        params = None  # Clear params because 'next' link includes all necessary params
        # print(f'Processed {count * resource_count}, {len(results)} results')

    return results


def get_document_references(patientId: str):
    """
    Search for patients based on their postal code and return their IDs.
    """

    url = f"{FHIR_BASE_URL}/DocumentReference?patient={patientId}"
    resource_count = 10000
    headers = {"Accept": "application/fhir+json"}
    params = {"_count": resource_count, "_offset": 0}
    count = 0
    results = []
    while url:
        response = get_resources_with_retry(url, headers, params)
        count += 1
        response.raise_for_status()  # Raise an error for bad responses
        bundle: Dict = response.json()
        for entry in bundle["entry"]:
            results.append(extract(entry["resource"]))
        url = next(
            (link.get("url") for link in bundle["link"] if link["relation"] == "next"),
            None,
        )
        params = None  # Clear params because 'next' link includes all necessary params
        # print(f'Processed {count * resource_count}, {len(results)} results')

    return results


def get_diagnostic_reports(patientId: str):
    """
    Search for patients based on their postal code and return their IDs.
    """

    url = f"{FHIR_BASE_URL}/DiagnosticReport?patient={patientId}"
    resource_count = 10000
    headers = {"Accept": "application/fhir+json"}
    params = {"_count": resource_count, "_offset": 0}
    count = 0
    results = []
    while url:
        response = get_resources_with_retry(url, headers, params)
        count += 1
        response.raise_for_status()  # Raise an error for bad responses
        bundle: Dict = response.json()
        for entry in bundle["entry"]:
            results.append(extract(entry["resource"]))
        url = next(
            (link.get("url") for link in bundle["link"] if link["relation"] == "next"),
            None,
        )
        params = None  # Clear params because 'next' link includes all necessary params
        # print(f'Processed {count * resource_count}, {len(results)} results')

    return results


def save_to_csv(output_path, unmatched_codes):
    df = pd.DataFrame(unmatched_codes.items(), columns=["Code", "Count"])
    df[["system", "code", "display"]] = df["Code"].str.split(";;", expand=True)
    df.drop(columns=["Code"], inplace=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    output_filename = f"{output_path}/servicerequest_unmapped_codes_{timestamp}.csv"
    df.to_csv(output_filename, index=False)


def print_result(result: Dict, patient: str):
    key_words = ["vag", "inter", "hiv", "phenx", "child"]
    if any(
        re.search(
            keyword,
            "".join([c.display if c.display else "" for c in result.get("coding")]),
            re.IGNORECASE,
        )
        for keyword in key_words
    ) or any(
        re.search(keyword, result.get("text"), re.IGNORECASE) for keyword in key_words
    ):
        print(
            f"{patient}, {result.get('resource_type')}, {result.get('id')}, {result.get('timestamp')}, {result.get('status')}, {result.get('text')}, {[coding_to_string(c) for c in result.get('coding')]}"
        )


def main():
    patients: list[str] = [
        "14f50c031d6764952ab559e54182bf1314b4233fc1fea3e2fa087ebf8a96cdb7"
    ]
    for patient in patients:
        # results = get_codes_for_procedures(patient)
        # for result in results:
        #     print_result(result)
        # results: List[Dict] = get_codes_for_observations(patient)
        # for result in results:
        #     print(result)
        # print_result(result, patient)
        results = get_codes_for_service_requests(patient)
        for result in results:
            print(result)
            # print_result(result, patient)
        # results = get_codes_for_conditions(patient)
        # for result in results:
        #     print(result)
        # print_result(result, patient)
        # print(patient)
        # results = get_document_references(patient)
        # for result in results:
        #     print(result)
        # results = get_diagnostic_reports(patient)
        # for result in results:
        #     print(result)


if __name__ == "__main__":
    main()
