# Molecule Tests

This directory contains molecule tests for the `rust_gameserver` role.

## Overview

The molecule tests verify the core functionality of the rust_gameserver role:
- Directory creation under `/etc/rust/`
- Configuration file templating (`rust.env`, `seed.env`, `wipe.sh`)
- Cron job creation for server wipes

## Test Structure

- `molecule.yml` - Main molecule configuration using Docker driver
- `converge.yml` - Playbook that applies the role
- `verify.yml` - Verification tests to ensure the role worked correctly
- `requirements.yml` - Empty requirements file for testing (avoids Galaxy dependency issues)
- `ansible.cfg` - Ansible configuration for molecule tests

## Running Tests

To run the molecule tests locally:

```bash
molecule test
```

To run only specific steps:

```bash
molecule converge  # Apply the role
molecule verify    # Run verification tests
```

## CI Integration

The tests are automatically run in GitHub Actions as part of the `check.yml` workflow.

## Notes

- The Docker container deployment is skipped during molecule tests using the `molecule_test` variable
- Tests focus on the core Ansible tasks rather than Docker functionality
- In CI, the community.docker collection is available, but local testing uses minimal requirements