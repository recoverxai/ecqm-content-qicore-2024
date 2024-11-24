"""
A utility script to debug MIPS measures across a patient population.

Workflow - 
- Run the base library expressions for a patient -
    - Initial Population
    - Denominator
    - Denominator Exclusions
    - Denominator Exceptions
    - Numerator
    - Numerator Exclusions
- For each base library, 
    - Decompose the base library into sub-libraries
        - For each sub-library
            - Find the resource types it looks for within the []
                - Encounter
                - Condition
                - MedicationRequest
                - ServiceRequest
                - Observation
            - Find the value of the resource, e.g. - [Observation: "Chlamydia Screening]
            - Fetch the valueset / concept code associated with the resource value
            - Fetch all resources of the `type` 
            - Search for concept code / valueset in the resource value
"""

import loguru
from fhirclient.models import (
    condition,
    domainresource,
    encounter,
    medicationrequest,
    observation,
    procedure,
    servicerequest,
)

import constants
import expression_decomposer
import library_decomposer
import library_evaluator as lib_eval

logger = loguru.logger


class MeasureFhirResource:
    type: domainresource.DomainResource
    value: str
    value_set: str


CMS153_IP_Mapping: list[str] = [
    "Age In Measurement Period",
    "Patient Gender",
    "Qualifying Encounters",
    "Assessments Identifying Sexual Activity",
    "Diagnoses Identifying Sexual Activity",
    "Active Contraceptive Medications",
    "Ordered Contraceptive Medications",
    "Laboratory Tests Identifying Sexual Activity",
    "Laboratory Tests Identifying Sexual Activity But Not Pregnancy",
    "Diagnostic Studies Identifying Sexual Activity",
    "Procedures Identifying Sexual Activity",
]

LIBRARY_TO_FHIR_RESOURCE_TYPE_MAPPING: dict[str, list[str]] = {
    "Age In Measurement Period": [],
    "Patient Gender": [],
    "Qualifying Encounters": [encounter.Encounter],
    "Assessments Identifying Sexual Activity": [observation.Observation],
    "Diagnoses Identifying Sexual Activity": [condition.Condition],
    "Active Contraceptive Medications": [medicationrequest.MedicationRequest],
    "Ordered Contraceptive Medications": [medicationrequest.MedicationRequest],
    "Laboratory Tests Identifying Sexual Activity": [servicerequest.ServiceRequest],
    "Laboratory Tests Identifying Sexual Activity But Not Pregnancy": [
        servicerequest.ServiceRequest
    ],
    "Diagnostic Studies Identifying Sexual Activity": [servicerequest.ServiceRequest],
    "Procedures Identifying Sexual Activity": [procedure.Procedure],
}


def main():
    library_evaluator = lib_eval.LibraryEvaluator()
    
    # Decompose the CQL
    CQL_FILE_PATH = constants.CQL_DIR_BASEPATH + "ChlamydiaScreeninginWomenFHIR.cql"
    with open(CQL_FILE_PATH, "r") as file:
        cql_content = file.read()

    # mapping from library expression name to its definition
    library_definitions: dict[str, str] = library_decomposer.parse_cql_definition(cql_content)

    for library_definition in library_definitions:
        # for initial population
        if library_definition in CMS153_IP_Mapping:
            nova_perf_query_params = lib_eval.QueryParams(
                periodStart="2024-01-01",
                periodEnd="2025-01-01",
                clearCache="true",
                patientIds="14f50c031d6764952ab559e54182bf1314b4233fc1fea3e2fa087ebf8a96cdb7",
                libraryId="ChlamydiaScreeninginWomenFHIR",
                expressions=library_definition,
            )
            nova_perf_result = library_evaluator.evaluate_library(query_params=nova_perf_query_params)




if __name__ == "__main__":
    main()
