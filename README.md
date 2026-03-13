# Bicep Snapshot

[![Validate Bicep Snapshot](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml) [![Deploy Resources](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml)

Testing the new Bicep snapshot feature.  Seeing if I can automate it in GitHub Actions.

Test scenarios:

- Test 1: Create a PR with no snapshot.  PR workflow should fail and post comments on PR.
- Test 2: Create a PR with snaphot but no changes to the bicep deployment.  PR workflow should pass with message "No resource changes detected in the snapshot.". Deploy workflow should not run as no changes to the bicep files.
- Test 3: Create a PR with snapshot and changes to the bicep deployment. PR workflow should pass with message "Resource changes detected in the snapshot: Please review the results in the Validate snapshot step and ensure the changes are expected.". Deploy workflow should run, perform the deployment, update the snapshot and commit the new snapshot file to the repo.