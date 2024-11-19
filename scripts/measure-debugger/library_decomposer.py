import re

import loguru

logger = loguru.logger


def parse_cql_definition(cql_text: str) -> dict[str, str]:
    """
    Parse the CQL text and extracts all define statements.
    Returns a dict with definition names as keys and the expressions as values
    """
    # Regex to match define statements
    define_pattern = re.compile(
        r'define\s+"([^"]+)"\s*:\s*(.*?)(?=\ndefine\s+"|$)', re.DOTALL | re.IGNORECASE
    )
    library_definitions: dict[str, str] = {}
    for match in define_pattern.finditer(cql_text):
        library_name = match.group(1).strip()
        library_expression = match.group(2).strip()
        library_definitions[library_name] = library_expression
    return library_definitions


def extract_dependencies(library_definitions: dict[str, str]) -> dict[str, set[str]]:
    """
    For each definition, find other definitions it depends on.
    Returns a dictionary with definition names as keys and sets of dependencies as values.
    """
    dependency_map: dict[str, set[str]] = {}
    for def_name, expr in library_definitions.items():
        # Find all quoted strings in the expression
        deps = set(re.findall(r'"([^"]+)"', expr))
        # Filter dependencies to only include other definitions
        deps = set(dep for dep in deps if dep in library_definitions)
        dependency_map[def_name] = deps
    return dependency_map


if __name__ == "__main__":
    CQL_FILE_PATH = "/Users/Abhi/Documents/rx-dev/ecqm-content-qicore-2024/input/cql/ChlamydiaScreeninginWomenFHIR.cql"
    with open(CQL_FILE_PATH, "r") as file:
        cql_content = file.read()

    library_definitions = parse_cql_definition(cql_content)
    for name, expr in library_definitions.items():
        logger.info(f"Definition: {name}\nExpression:\n{expr}\n")
    dependency_map = extract_dependencies(library_definitions)
    for def_name, deps in dependency_map.items():
        logger.info(f"Definition: {def_name}\nDependencies: {deps}\n")
