# Repository Settings Guide

This document provides instructions for configuring GitHub repository settings to ensure quality control, collaboration, and security.

## Branch Protection Rules

Branch protection rules help maintain code quality by enforcing reviews and checks before merging.

### Setting Up Branch Protection for `main`

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click **Settings** (top right)
   - Select **Branches** from the left sidebar

2. **Add Branch Protection Rule**
   - Click **Add rule** or **Add branch protection rule**
   - In **Branch name pattern**, enter: `main`

3. **Configure Protection Settings**

   #### Require Pull Request Reviews
   - ✅ Check **Require a pull request before merging**
   - Set **Required approving reviews**: `1` (minimum)
   - ✅ Check **Dismiss stale pull request approvals when new commits are pushed**
   - ✅ Check **Require review from Code Owners** (if CODEOWNERS file exists)

   #### Require Status Checks
   - ✅ Check **Require status checks to pass before merging**
   - ✅ Check **Require branches to be up to date before merging**
   - Add required status checks:
     - `Build and Test` (from GitHub Actions workflow)
     - `SwiftLint` (from GitHub Actions workflow)

   #### Additional Settings
   - ✅ Check **Require conversation resolution before merging**
   - ✅ Check **Require signed commits** (recommended for security)
   - ✅ Check **Include administrators** (enforce rules for all users)
   - ✅ Check **Allow force pushes** → **Specify who can force push** → Nobody
   - ✅ Check **Allow deletions** → Uncheck this

4. **Save Changes**
   - Click **Create** or **Save changes**

### Recommended Branch Protection for `develop`

If using a `develop` branch:
- Apply similar rules but may be less strict
- Consider requiring fewer reviewers (e.g., 1 reviewer)
- Optional: Don't require branches to be up to date

## Dependabot Configuration

Dependabot is already configured via `.github/dependabot.yml` and will:
- Monitor Swift Package Manager dependencies
- Monitor GitHub Actions versions
- Create automated pull requests for updates
- Run checks weekly on Mondays at 9:00 AM

### Enabling Dependabot Security Updates

1. Go to **Settings** → **Code security and analysis**
2. Enable **Dependabot security updates**
3. Enable **Dependabot version updates** (uses the `dependabot.yml` config)

### Managing Dependabot PRs

- Review Dependabot PRs regularly
- Check for breaking changes before merging
- Use `@dependabot rebase` to rebase the PR
- Use `@dependabot recreate` to recreate the PR
- Use `@dependabot merge` to merge once CI passes

## GitHub Discussions

Enable Discussions for community engagement and support.

### Enabling Discussions

1. Go to **Settings** → **General**
2. Scroll down to **Features** section
3. Check **Discussions**
4. Click **Set up discussions**

### Recommended Discussion Categories

After enabling, configure these categories:

1. **📢 Announcements**
   - Format: Announcement
   - Description: "Official updates and news about Cashin'"
   - Maintainers only can create posts

2. **💡 Ideas & Feature Requests**
   - Format: Open-ended discussion
   - Description: "Share ideas for new features and improvements"

3. **🙋 Q&A**
   - Format: Question/Answer
   - Description: "Ask questions about using Cashin'"
   - Enable "Mark as answer" feature

4. **🐛 Bug Reports**
   - Format: Open-ended discussion
   - Description: "Report bugs and issues (or use Issues tab for tracking)"

5. **💬 General Discussion**
   - Format: Open-ended discussion
   - Description: "General discussion about the app and iOS development"

6. **🎨 Design & UI**
   - Format: Open-ended discussion
   - Description: "Discuss design decisions and UI improvements"

### Discussion Best Practices

- Pin important announcements
- Convert valuable discussions into documentation
- Move bug discussions to Issues when confirmed
- Encourage community interaction and voting
- Regular moderation and response

## Issue Templates

Create issue templates for consistent bug reports and feature requests.

### Creating Issue Templates

1. Go to **Settings** → **General**
2. Scroll to **Features** → Click **Set up templates** next to Issues
3. Add these templates:

#### Bug Report Template
```yaml
name: Bug Report
description: File a bug report
labels: ["bug"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for reporting a bug! Please fill out the sections below.
  - type: input
    attributes:
      label: iOS Version
      placeholder: "e.g., iOS 17.1"
    validations:
      required: true
  - type: input
    attributes:
      label: Device Model
      placeholder: "e.g., iPhone 15 Pro"
    validations:
      required: true
  - type: textarea
    attributes:
      label: Description
      description: Clear description of the bug
    validations:
      required: true
  - type: textarea
    attributes:
      label: Steps to Reproduce
      description: Step-by-step instructions
      placeholder: |
        1. Go to...
        2. Tap on...
        3. See error...
    validations:
      required: true
  - type: textarea
    attributes:
      label: Expected Behavior
      description: What should happen?
    validations:
      required: true
  - type: textarea
    attributes:
      label: Actual Behavior
      description: What actually happens?
    validations:
      required: true
```

#### Feature Request Template
```yaml
name: Feature Request
description: Suggest a new feature
labels: ["enhancement"]
body:
  - type: textarea
    attributes:
      label: Feature Description
      description: Describe the feature you'd like to see
    validations:
      required: true
  - type: textarea
    attributes:
      label: Use Case
      description: How would this feature be used?
    validations:
      required: true
  - type: textarea
    attributes:
      label: Proposed Solution
      description: Your ideas on how to implement this
```

## Code Owners

Create a CODEOWNERS file to automatically assign reviewers.

Create `.github/CODEOWNERS`:
```
# Default owners for everything in the repo
*       @J9ck

# Specific ownership patterns (adjust as needed)
*.swift @J9ck
*.md    @J9ck
```

## Repository Insights

### Enable Useful Insights

1. Go to **Insights** tab
2. Configure:
   - **Pulse**: Weekly overview
   - **Contributors**: Track contributions
   - **Traffic**: Monitor views and clones
   - **Dependency graph**: Track dependencies

## Security Settings

### Security Best Practices

1. **Enable Dependency Graph**
   - Settings → Code security and analysis → Dependency graph: Enable

2. **Enable Dependabot Alerts**
   - Settings → Code security and analysis → Dependabot alerts: Enable

3. **Enable Code Scanning**
   - Settings → Code security and analysis → Code scanning: Set up
   - Use CodeQL or SwiftLint integration

4. **Enable Secret Scanning**
   - Settings → Code security and analysis → Secret scanning: Enable
   - Automatically available for public repositories

## Collaboration Settings

### Repository Access

1. **Collaborators**
   - Settings → Collaborators
   - Add team members with appropriate permissions:
     - **Read**: Can view and clone
     - **Triage**: Can manage issues and PRs
     - **Write**: Can push to repo
     - **Maintain**: Can manage some settings
     - **Admin**: Full access

2. **Team Permissions** (for Organizations)
   - Create teams for different roles
   - Assign team-level permissions

## Additional Configurations

### Labels

Create useful labels for issue/PR management:
- `bug` - Bug reports
- `enhancement` - Feature requests
- `documentation` - Documentation updates
- `good first issue` - Good for newcomers
- `help wanted` - Need community help
- `priority: high` - High priority items
- `priority: low` - Low priority items
- `dependencies` - Dependency updates
- `swift` - Swift-related changes
- `github-actions` - CI/CD changes

### Milestones

Create milestones for release planning:
- `v1.0` - Initial App Store release
- `v1.1` - Feature updates
- `v2.0` - Major version

### Projects

Enable GitHub Projects for task management:
1. Click **Projects** tab
2. Create a project board
3. Add columns: Backlog, To Do, In Progress, Review, Done
4. Link issues and PRs to the project

## Summary Checklist

After following this guide, you should have:

- ✅ Branch protection rules on `main` branch
- ✅ Dependabot enabled and configured
- ✅ GitHub Discussions enabled with categories
- ✅ Issue templates created
- ✅ CODEOWNERS file created
- ✅ Security features enabled
- ✅ Useful labels created
- ✅ Milestones defined
- ✅ Collaborators added (if applicable)

These configurations will help maintain code quality, encourage collaboration, and improve security for the Cashin' repository.
