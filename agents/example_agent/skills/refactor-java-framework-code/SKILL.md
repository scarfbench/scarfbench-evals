---
name: refactor-java-framework-code
description: Refactor Java application code for a new framework. Use when updating imports, annotations, APIs, dependency injection, or framework-specific patterns.
---

When refactoring application code for a new framework:

## Code Updates
- Update package imports from source framework to target framework
- Refactor annotations to match target framework conventions
- Modify class inheritance, interface implementations, and framework-specific base classes
- Adapt API calls to align with target framework methods and patterns
- Update dependency injection mechanisms if frameworks differ
- Refactor error handling, transaction management, and middleware components

## Validation
- After each significant code change, verify no syntax errors are introduced
- Maintain existing business logic and functionality throughout
- When framework equivalents are ambiguous, choose the most commonly adopted pattern in the target framework
