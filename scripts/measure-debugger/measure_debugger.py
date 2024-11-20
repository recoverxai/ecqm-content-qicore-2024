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

import constants
import library_decomposer

logger = loguru.logger


def main():
    ...
    # Decompose the CQL
    CQL_FILE_PATH = constants.CQL_DIR_BASEPATH + "ChlamydiaScreeninginWomenFHIR.cql"
    with open(CQL_FILE_PATH, "r") as file:
        cql_content = file.read()

    library_definitions = library_decomposer.parse_cql_definition(cql_content)

    for name, expr in library_definitions.items():
        logger.info(f"Definition: {name}\nExpression:\n{expr}\n")

    dependency_map = library_decomposer.extract_dependencies(library_definitions)
    for def_name, deps in dependency_map.items():
        logger.info(f"Definition: {def_name}\nDependencies: {deps}\n")

    dependency_graph = library_decomposer.build_dependency_graph(dependency_map)


if __name__ == "__main__":
    main()
