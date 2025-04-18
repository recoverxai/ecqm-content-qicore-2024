import re
from dataclasses import dataclass
from typing import List, Union

import models as debug_models

# Reusing the DataType, LogicalOperator, and ExpressionNode classes from above


def parse_expression(expr: str) -> debug_models.ExpressionNode:
    expr = expr.strip()

    # Base case: Literal comparison
    match = re.match(r'^"([^"]+)"\s*(=|in)\s*(.*)$', expr)
    if match:
        def_name = match.group(1)
        operator = match.group(2)
        value_part = match.group(3).strip()

        # Determine data type and expected value
        if operator == "=":
            # String or numeric equality
            if value_part.startswith("'") and value_part.endswith("'"):
                expected_value = value_part.strip("'")
                data_type = debug_models.DataType.STRING
            else:
                expected_value = int(value_part)
                data_type = debug_models.DataType.INT
            return debug_models.LogicalExpressionNode(
                operator=debug_models.LogicalOperator.EQUALS,
                operands=[
                    debug_models.DefinitionNode(name=def_name, data_type=data_type),
                    debug_models.LiteralNode(value=expected_value, data_type=data_type),
                ],
            )
        elif operator == "in":
            # Interval
            interval_match = re.match(r"^Interval\[(\d+),\s*(\d+)\]$", value_part)
            if interval_match:
                start = int(interval_match.group(1))
                end = int(interval_match.group(2))
                return debug_models.LogicalExpressionNode(
                    operator=debug_models.LogicalOperator.IN,
                    operands=[
                        debug_models.DefinitionNode(
                            name=def_name, data_type=debug_models.DataType.INT
                        ),
                        debug_models.LiteralNode(
                            value=(start, end), data_type=debug_models.DataType.INTERVAL
                        ),
                    ],
                )

    # Handle 'exists' expressions
    match = re.match(r'^exists\s*\(\s*"([^"]+)"\s*\)$', expr)
    if match:
        def_name = match.group(1)
        return debug_models.LogicalExpressionNode(
            operator=debug_models.LogicalOperator.EXISTS,
            operands=[
                debug_models.DefinitionNode(
                    name=def_name, data_type=debug_models.DataType.BOOL
                )
            ],
        )

    # Handle 'and'/'or' operations
    # Split the expression by ' and ' or ' or ' outside parentheses
    tokens = split_logical(expr)
    if tokens:
        operator_str = tokens["operator"]
        operator = (
            debug_models.LogicalOperator.AND
            if operator_str == "and"
            else debug_models.LogicalOperator.OR
        )
        operands = [parse_expression(token) for token in tokens["operands"]]
        return debug_models.LogicalExpressionNode(operator=operator, operands=operands)

    # If none of the above, return as a DefinitionNode
    return debug_models.DefinitionNode(name=expr.strip('"'))


def split_logical(expr: str) -> Union[None, dict]:
    # This function splits the expression by 'and' or 'or' considering parentheses
    depth = 0
    tokens = []
    current = ""
    operator = None
    i = 0
    while i < len(expr):
        c = expr[i]
        if c == "(":
            depth += 1
            current += c
        elif c == ")":
            depth -= 1
            current += c
        elif depth == 0 and expr[i : i + 4] == " and ":
            tokens.append(current.strip())
            current = ""
            operator = "and"
            i += 4
            continue
        elif depth == 0 and expr[i : i + 3] == " or ":
            tokens.append(current.strip())
            current = ""
            operator = "or"
            i += 3
            continue
        else:
            current += c
        i += 1
    if current:
        tokens.append(current.strip())
    if operator:
        return {"operator": operator, "operands": tokens}
    else:
        return None


# Example usage
expr = """
"Age In Measurement Period" in Interval[16, 24]
    and "Patient Gender" = 'female'
    and exists ( "Qualifying Encounters" )
    and ( exists ( "Assessments Identifying Sexual Activity" )
        or exists ( "Diagnoses Identifying Sexual Activity" )
        or exists ( "Active Contraceptive Medications" )
        or exists ( "Ordered Contraceptive Medications" )
        or exists ( "Laboratory Tests Identifying Sexual Activity" )
        or exists ( "Diagnostic Studies Identifying Sexual Activity" )
        or exists ( "Procedures Identifying Sexual Activity" )
    )
"""

parsed_expr = parse_expression(expr)
print(parsed_expr)
