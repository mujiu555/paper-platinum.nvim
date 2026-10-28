# Decorators, type hints, f-strings and docstrings
from dataclasses import dataclass
@dataclass
class Page:
    title: str
    lines: int = 80
    def summary(self) -> str:
        """Describe this page."""
        return f"{self.title}: {self.lines}"
