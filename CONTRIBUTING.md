# Contributing to eMDeck

Thank you for your interest in contributing to **eMDeck**! We welcome contributions to improve and extend the project. Please follow these guidelines to make the process smooth for everyone.

---

## How Can I Contribute?

### 1. Reporting Issues

If you encounter bugs, performance issues, or have feature requests:

1. Check the [issue tracker](https://github.com/Skipper-116/eMDeck/issues) to see if it’s already reported.
2. Create a new issue with:
   - A descriptive title.
   - A detailed explanation of the problem or feature request.
   - Steps to reproduce (if applicable).
   - Relevant logs, screenshots, or error messages.

### 2. Submitting Changes

1. Fork the repository and clone your fork.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes.
4. Run tests to ensure your changes don’t break existing functionality.
5. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```
6. Open a pull request on the main repository.

### 3. Adding Documentation

We value well-documented code. If you find missing or unclear documentation:

- Update the `README.md` or relevant sections.
- Submit your changes as described above.

---

## Code Guidelines

1. **Code Style**:

   - Follow PEP 8 for Python code.
   - Use meaningful variable and function names.
   - Write comments for complex logic.

2. **Dockerfiles**:

   - Ensure Dockerfiles remain minimal and efficient.
   - Test changes with `docker-compose` before submitting.

3. **Tests**:
   - Add tests for new features or bug fixes.
   - Ensure all tests pass before submitting your PR.

---

## Development Setup

### Prerequisites

- Python 3.2 or higher
- Docker and Docker Compose
- Git

### Setting Up the Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/emdeck.git
   cd emdeck
   ```
2. Install dependencies if required.
3. Build and start the services:
   ```bash
   docker-compose up -d
   ```

---

## Code of Conduct

Please read and follow our [Code of Conduct](./CODE_OF_CONDUCT.md).

---

Thank you for contributing to eMDeck! 🚀
