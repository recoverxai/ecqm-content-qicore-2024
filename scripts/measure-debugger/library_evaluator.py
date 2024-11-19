from typing import NamedTuple, TypedDict

import loguru
import pydantic as pydantic
import requests

# Constants
SCHEME: str = "http"
NOVA_PERFORMNCE_HOST: str = "localhost"
NOVA_PERFORMNCE_PORT: str = "8051"
NOVA_PERFORMNCE_PATH: str = "library/evaluation"
BASE_URL: str = (
    f"{SCHEME}://{NOVA_PERFORMNCE_HOST}:{NOVA_PERFORMNCE_PORT}/{NOVA_PERFORMNCE_PATH}"
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
    logger.info(f"Query Params: {query_params_str}")
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
        logger.info(f"Request URL: {request}")
        logger.info(response.text)


if __name__ == "__main__":
    assert (
        BASE_URL == "http://localhost:8051/library/evaluation"
    ), "BASE_URL is incorrect"
    query_params: QueryParams = QueryParams(
        periodStart="2024-01-01",
        periodEnd="2025-01-01",
        clearCache="true",
        patientIds="14f50c031d6764952ab559e54182bf1314b4233fc1fea3e2fa087ebf8a96cdb7",
        libraryId="ChlamydiaScreeninginWomenFHIR",
        expressions="Initial Population",
    )
    evaluator = LibraryEvaluator()
    evaluator.evaluate_library(query_params)
