import re

import loguru
import matplotlib.pyplot as plt
import networkx as nx

import constants as constants

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


def build_dependency_graph(dependency_map: dict[str, set[str]]) -> nx.DiGraph:
    """
    Build a directed graph from the dependency map
    """
    G = nx.DiGraph()
    for def_name, deps in dependency_map.items():
        for dep in deps:
            G.add_edge(dep, def_name)
    return G


def get_evaluation_order(dependency_graph: nx.DiGraph) -> list[str]:
    """
    Returns a list of definitions in the order they should be evaluated.
    Raises an error if a cycle is detected.
    """
    try:
        order = list(nx.topological_sort(dependency_graph))
        return order
    except nx.NetworkXUnfeasible:
        raise Exception("Cycle detected in dependencies. Cannot perform topological sort.")



if __name__ == "__main__":
    CQL_FILE_PATH = constants.CQL_DIR_BASEPATH + "ChlamydiaScreeninginWomenFHIR.cql"
    with open(CQL_FILE_PATH, "r") as file:
        cql_content = file.read()

    library_definitions = parse_cql_definition(cql_content)
    for name, expr in library_definitions.items():
        logger.info(f"Definition: {name}\nExpression:\n{expr}\n")

    dependency_map = extract_dependencies(library_definitions)
    for def_name, deps in dependency_map.items():
        logger.info(f"Definition: {def_name}\nDependencies: {deps}\n")

    dependency_graph = build_dependency_graph(dependency_map)
    try:
        plt.figure(figsize=(12, 8))
        pos = nx.spring_layout(dependency_graph, k=0.5)
        nx.draw(
            dependency_graph,
            pos,
            with_labels=True,
            node_size=3000,
            node_color="lightblue",
            font_size=10,
            arrowsize=20,
        )
        plt.title("CQL Definitions Dependency Graph")
        plt.show()
    except ImportError:
        logger.info("Matplotlib not installed. Skipping graph visualization.")
    # Determine evaluation order
    try:
        evaluation_order = get_evaluation_order(dependency_graph)
        logger.info("Evaluation Order:")
        for idx, def_name in enumerate(evaluation_order, 1):
            logger.info(f"{idx}. {def_name}")
    except Exception as e:
        print(str(e))
        
