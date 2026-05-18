# Contributing to GIWA

Thank you for your interest in contributing to GIWA! This document provides guidelines and instructions for contributing to the GIWA ecosystem.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Contribution Guidelines](#contribution-guidelines)
- [Community](#community)

---

## Code of Conduct

By participating in this project, you agree to maintain a respectful, inclusive, and harassment-free environment for everyone.

### Our Standards

- ✅ Be respectful and inclusive
- ✅ Welcome newcomers and help them learn
- ✅ Focus on what's best for the community
- ✅ Show empathy towards others
- ❌ No harassment, discrimination, or offensive behavior

---

## How Can I Contribute?

There are many ways to contribute to GIWA:

### 1. 📝 Documentation

- Improve existing documentation
- Write tutorials and guides
- Create examples and demos
- Fix typos and clarify instructions
- Translate documentation

### 2. 🐛 Bug Reports

- Report issues you encounter
- Provide detailed reproduction steps
- Include system information and logs

### 3. 💡 Feature Requests

- Suggest new features
- Propose improvements
- Share use cases and requirements

### 4. 🔧 Code Contributions

- Fix bugs
- Implement features
- Improve performance
- Add tests
- Refactor code

### 5. 🧪 Testing

- Test on different platforms
- Validate setup instructions
- Perform security audits
- Benchmark performance

### 6. 🤝 Community Support

- Answer questions in issues
- Help newcomers get started
- Share your experiences
- Create content (blog posts, videos)

---

## Getting Started

### Prerequisites

- **Git** installed
- **Docker & Docker Compose** (for node repo)
- **Node.js v18+** (for dojang repo)
- **Foundry** (for Solidity development)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/REPO-NAME.git
   cd REPO-NAME
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/giwa-io/REPO-NAME.git
   ```

4. Create a branch:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

---

## Development Workflow

### For Node Repository

```bash
# Install dependencies
docker compose build

# Run node
CLIENT=reth NETWORK_ENV=.env.sepolia docker compose up -d

# View logs
docker compose logs -f

# Stop node
docker compose down
```

### For Dojang Repository

```bash
# Install dependencies
pnpm install

# Build
pnpm build

# Run tests
pnpm test

# Check coverage
pnpm test:coverage

# Lint
pnpm lint
pnpm lint:fix

# Deploy (testnet)
source .env
forge script script/deploy/Deploy.s.sol --rpc-url $RPC_URL --broadcast
```

---

## Contribution Guidelines

### Documentation Contributions

**What We Welcome:**
- Tutorials and how-to guides
- FAQ entries
- Troubleshooting tips
- Platform-specific instructions
- Integration examples
- Video tutorials and screencasts

**Style Guide:**
- Use clear, concise language
- Include code examples where relevant
- Add screenshots/diagrams when helpful
- Test all instructions before submitting
- Use consistent formatting (Markdown)

**File Structure:**
```
docs/
├── guides/          # How-to guides
├── tutorials/       # Step-by-step tutorials
├── reference/       # API/technical reference
└── troubleshooting/ # Common issues & solutions

examples/
├── basic/           # Simple examples
├── advanced/        # Complex integrations
└── production/      # Production-ready configs
```

### Code Contributions

**Before You Start:**
1. Check existing issues for similar work
2. Comment on the issue to claim it
3. Discuss major changes in an issue first

**Code Style:**
- Follow existing code style
- Use meaningful variable names
- Add comments for complex logic
- Write self-documenting code

**For Solidity:**
- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Add NatSpec comments
- Write comprehensive tests
- Check gas optimization

**For TypeScript/JavaScript:**
- Use ES6+ features
- Follow Prettier formatting
- Add JSDoc comments
- Handle errors properly

**For Bash Scripts:**
- Use `set -e` for error handling
- Add comments for complex logic
- Test on multiple platforms
- Make scripts idempotent

### Testing

**Requirements:**
- All code changes must include tests
- Tests must pass before merging
- Maintain or improve code coverage
- Test on multiple environments when possible

**Test Types:**
- Unit tests for individual functions
- Integration tests for contracts/services
- End-to-end tests for full flows
- Manual testing on testnet

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Build/tooling changes

**Examples:**
```
feat(node): add health check endpoint

Add /health endpoint for monitoring node status.
Includes sync status, peer count, and block height.

Closes #123
```

```
docs: add troubleshooting guide for certificate errors

Addresses issue #1 with detailed solutions for x509 errors.
Includes platform-specific fixes and debugging steps.
```

```
fix(dojang): resolve attestation indexing race condition

Fixed race condition in AttestationIndexer that caused
missed attestations during high-volume periods.

Fixes #456
```

### Pull Requests

**PR Title:** Use conventional commit format

**PR Description Template:**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation
- [ ] Refactoring
- [ ] Other (specify)

## Testing
How was this tested?

## Checklist
- [ ] Code follows project style
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] No new warnings

## Related Issues
Closes #123
Related to #456
```

**Review Process:**
1. Automated checks must pass (CI/CD)
2. At least one maintainer review required
3. Address all review comments
4. Keep PR scope focused
5. Rebase on main if needed

---

## Specific Contribution Ideas

### High-Priority Needs

**Documentation:**
- [ ] Platform-specific setup guides (Ubuntu, Debian, CentOS, macOS)
- [ ] Video tutorials for node setup
- [ ] Dojang integration examples (all 4 schemas)
- [ ] Grafana dashboard templates
- [ ] Cost analysis and optimization guide

**Tooling:**
- [ ] Node health monitoring scripts
- [ ] Automated backup utilities
- [ ] Performance benchmarking tools
- [ ] Migration scripts for upgrades

**Testing:**
- [ ] Cross-platform testing reports
- [ ] Load testing results
- [ ] Security audit findings

**Examples:**
- [ ] Full dApp using Dojang attestations
- [ ] Custom resolver implementations
- [ ] Integration with popular frameworks (Next.js, React, Vue)

---

## Community

### Communication Channels

- **GitHub Issues:** Bug reports, feature requests
- **GitHub Discussions:** General questions, ideas
- **X/Twitter:** [@giwachain](https://x.com/giwachain)
- **Email:** support@giwa.io
- **Discord:** Coming Soon

### Getting Help

**Stuck?** Don't hesitate to ask!
- Comment on related issue
- Open a discussion on GitHub
- Reach out on social media
- Email support team

### Recognition

Contributors are recognized in several ways:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- GitHub contributor badge
- Community spotlight posts

---

## Legal

By contributing, you agree that:
- Your contributions will be licensed under the same license as the project (MIT)
- You have the right to submit the contribution
- You understand contributions are public

---

## Questions?

If you have questions about contributing:
- Check existing documentation
- Search closed issues
- Ask in GitHub Discussions
- Email: support@giwa.io

**Thank you for contributing to GIWA!** 🎉

---

**Maintained by:** GIWA Community  
**Last Updated:** May 2026
