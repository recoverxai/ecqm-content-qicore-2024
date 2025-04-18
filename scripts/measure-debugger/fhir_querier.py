import loguru
import requests
from fhirclient.models import (
    bundle,
    condition,
    domainresource,
    encounter,
    medicationrequest,
    observation,
    procedure,
    servicerequest,
)

import constants as constants

logger = loguru.logger

RESOURCE_MPPING: dict[str, domainresource.DomainResource] = {
    "Encounter": encounter.Encounter,
    "Condition": condition.Condition,
    "MedicationRequest": medicationrequest.MedicationRequest,
    "ServiceRequest": servicerequest.ServiceRequest,
    "Procedure": procedure.Procedure,
    "Observation": observation.Observation,
}


FHIR_SERVER_URL = f"{constants.SCHEME}://{constants.FHIR_SERVER_HOST}:{constants.FHIR_SERVER_PORT}/{constants.FHIR_SERVER_PATH}"


def get_resources_for_patient(resource_type: str, patient_id: str) -> bundle.Bundle:
    request: str = (
        f"{FHIR_SERVER_URL}/{resource_type}?patient={patient_id}&_count={constants.RESOURCE_COUNT}"
    )
    payload: dict[str, str] = {}
    headers: dict[str, str] = {}
    response = requests.request("GET", request, headers=headers, data=payload)
    logger.info(f"Request URL: {request}")
    logger.info(response.text)


if __name__ == "__main__":
    assert (
        FHIR_SERVER_URL == "http://localhost:8089/fhir"
    ), "FHIR_SERVER_URL is incorrect"
    patient_id = "test-123"
    get_resources_for_patient("Encounter", patient_id)
