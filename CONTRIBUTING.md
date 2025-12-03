# Contributing to Cashin'

First off, thank you for considering contributing to Cashin'! It's people like you that make Cashin' such a great tool.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct:
- Be respectful and inclusive
- Be collaborative
- Be patient and constructive with feedback
- Focus on what is best for the community

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** to demonstrate the steps
- **Describe the behavior you observed** and what behavior you expected to see
- **Include screenshots or animated GIFs** if applicable
- **Specify your iOS version and device model**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a step-by-step description** of the suggested enhancement
- **Provide specific examples** to demonstrate the use case
- **Describe the current behavior** and explain the behavior you'd like to see
- **Explain why this enhancement would be useful**

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Follow the existing code style** - the project uses Swift conventions
3. **Write clear commit messages** - use present tense ("Add feature" not "Added feature")
4. **Test your changes** - ensure your code works on both simulators and devices
5. **Update documentation** - if you change functionality, update README.md
6. **Create a Pull Request** with a clear title and description

#### Pull Request Process

1. Ensure your code follows the project's coding standards
2. Update the README.md with details of changes if applicable
3. Your PR should include:
   - A clear description of what the PR does
   - Screenshots or videos for UI changes
   - Test results if applicable
4. The PR will be merged once you have the approval of a maintainer

## Development Setup

### Prerequisites
- macOS with Xcode 15.0 or later
- iOS 17.0+ Simulator or device
- Git

### Setting Up Your Development Environment

1. **Clone your fork of the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Cashin.git
   cd Cashin
   ```

2. **Create a new iOS App project in Xcode:**
   - File → New → Project → iOS App
   - Use the following settings:
     - Product Name: Cashin
     - Interface: SwiftUI
     - Life Cycle: SwiftUI App
     - Language: Swift
     - Deployment Target: iOS 17.0

3. **Replace the default files** with the files from the cloned repository

4. **Configure signing** in Xcode with your Apple Developer account

5. **Build and run** the project on simulator or device

## Coding Standards

### Swift Style Guide

- Follow Apple's [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add `// MARK: -` comments to organize code sections
- Use SwiftUI best practices and conventions
- Keep functions focused and small

### Code Organization

```swift
// MARK: - Properties
// Properties section

// MARK: - Initialization
// Init methods

// MARK: - Body
// SwiftUI body

// MARK: - Helper Methods
// Private helper methods
```

### Comments

- Use comments to explain **why** not **what**
- Document complex algorithms or business logic
- Keep comments up-to-date with code changes

## Testing Guidelines

- Write unit tests for business logic and data models
- Write UI tests for critical user flows
- Ensure tests are deterministic and isolated
- Name tests descriptively: `test_methodName_condition_expectedResult`

## Commit Message Guidelines

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

### Examples:

```
Add quick-add buttons for common transaction amounts

Implement daily balance display with dynamic theming

Fix notification scheduling bug for midnight transactions
Closes #123
```

## Branch Naming Convention

- `feature/description` - for new features
- `fix/description` - for bug fixes
- `docs/description` - for documentation changes
- `refactor/description` - for code refactoring
- `test/description` - for adding or updating tests

## Questions?

Feel free to open an issue with your question or reach out to the maintainers.

## Attribution

These contribution guidelines are adapted from open source contribution best practices.
