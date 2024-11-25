import pprint
from typing import NamedTuple, TypedDict

import loguru
import pydantic as pydantic
import requests

import constants as constants

# Constants
BASE_URL: str = (
    f"{constants.SCHEME}://{constants.NOVA_PERFORMNCE_HOST}:{constants.NOVA_PERFORMNCE_PORT}/{constants.NOVA_PERFORMNCE_PATH}"
)

logger = loguru.logger


class QueryParams(TypedDict):
    periodStart: str
    periodEnd: str
    clearCache: str
    patientIds: str
    libraryId: str
    expressions: str


def build_query_param_string(query_params: QueryParams) -> str:
    query_params_str = "&".join(
        [f"{key}={value}" for key, value in query_params.items()]
    )
    # logger.info(f"Query Params: {query_params_str}")
    return query_params_str


def make_nova_performance_request(query_params: QueryParams) -> str:
    return BASE_URL + "?" + build_query_param_string(query_params)


class LibraryEvaluator:
    base_url: str

    def __init__(self) -> None:
        self.base_url = BASE_URL

    def evaluate_library(self, query_params: QueryParams) -> None:
        request: str = make_nova_performance_request(query_params)
        payload: dict[str, str] = {}
        headers: dict[str, str] = {}
        response = requests.request("GET", request, headers=headers, data=payload)
        # logger.info(f"Request URL: {request}")
        # logger.info(pprint.pprint(response.json()))
        return self.parse_library_eval_result_value(response.json())

    def parse_library_eval_result_value(self, response: dict) -> str | list:
        results: list[str] = []
        if not response:
            return response

        if type(response) == dict:
            return self.parse_result(response)

        if type(response) == list:
            for item in response:
                results.append(self.parse_library_eval_result_value(item))

        return results

    def parse_result(self, response: dict[str, any]) -> str:
        result: dict[str, any] = response.get("result")
        if not result:
            return "EMPTY"
        if result.get("valueInteger"):
            return result.get("name") + ": " + result.get("valueInteger")
        elif result.get("valueString"):
            return result.get("name") + ": " + result.get("valueString")
        elif result.get("valueBoolean"):
            return result.get("name") + ": " + result.get("valueBoolean")
        elif result.get("resource"):
            resource: dict[str, any] = result.get("resource")
            return result.get("name") + ": " + resource.get("resourceType")
        else:
            return "Result type not known"


if __name__ == "__main__":
    assert (
        BASE_URL == "http://localhost:8051/library/evaluation"
    ), "BASE_URL is incorrect"
    query_params: QueryParams = QueryParams(
        periodStart="2024-01-01",
        periodEnd="2025-01-01",
        clearCache="true",
        patientIds="test-123",
        libraryId="ChlamydiaScreeninginWomenFHIR",
        expressions="Active Contraceptive Medications",
    )
    evaluator = LibraryEvaluator()
    print(evaluator.evaluate_library(query_params))
