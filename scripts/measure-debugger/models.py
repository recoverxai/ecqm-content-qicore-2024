from dataclasses import dataclass
from enum import Enum
from typing import List, Union


class DataType(Enum):
    INT = "Int"
    STRING = "String"
    BOOL = "Bool"
    INTERVAL = "Interval"
    OTHER = "Other"


class LogicalOperator(Enum):
    AND = "and"
    OR = "or"
    EXISTS = "exists"
    NOT_EXISTS = "not exists"
    EQUALS = "="
    IN = "in"
    OTHER = "other"


class ExpressionNode:
    pass


@dataclass
class LiteralNode(ExpressionNode):
    value: Union[int, str, bool, tuple]
    data_type: DataType


@dataclass
class DefinitionNode(ExpressionNode):
    name: str
    data_type: DataType = DataType.OTHER
    expected_value: Union[int, str, bool, tuple, None] = None


@dataclass
class LogicalExpressionNode(ExpressionNode):
    operator: LogicalOperator
    operands: List[ExpressionNode]
