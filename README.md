# Bicep Snapshot

[![Validate Bicep Snapshot](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml) [![Deploy Resources](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml)

## Introduction

With release v0.41.2 the Bicep team relased a new command `bicep snapshot` which generates a JSON file conatining a normalised view of the resources declared in a Bicep deployment. You can read about the command in the [Bicep release notes](https://github.com/Azure/bicep/releases/tag/v0.41.2).<br><br>
The aim of this command is to give bicep users an easier way to validate any changes that have been made to a bicep deployment without needing to crawl through potentially large changes to nested modules.<br><br>
The workflow would go a little something like this:

1. Create a Bicep template and parameter file to deploy some resources to Azure.
2. Create a snapshot file using the `bicep snapshot` command.
3. Make some changes to the Bicep template or parameter file.
4. Run the `bicep snapshot` command again in validate mode to compare the changes with the previously saved snapshot.

The output when run in a terminal is very similar to the output from a `what-if` but very trimmed down to just the resources or properties that have changed. Making it much easier to quickly validate the changes have had the desired effect before deployment.

Running the command manually in a terminal is shown below:

To create a snapshot:
```PowerShell
bicep snapshot main.bicepparam --mode overwrite --subscription-id 00000000-0000-0000-0000-000000000000 --location uksouth
```
You don't strictly need to include the `--subscription-id` and `--location` parameters as the command will put placeholders in the snapshot. However, if you want a more accurate result it's worth including them.

To validate against an existing snapshot:
```PowerShell
bicep snapshot main.bicepparam --mode validate --subscription-id 00000000-0000-0000-0000-000000000000 --location uksouth
```
The screenshow below shows the output for changing a storage account SKU. If you've ever run a `what-if` on a Bicep template this will look very familiar but as you can see it's much easier to quickly validate the changes with the snapshot output as it's much more concise and focused on just the changes.

[!Bicep Snapshot Output](../bicepsnapshot/images/snapshot_validate.jpg)

## Using snapshots with version control

talk about GIT uses for reviews etc


Test scenarios:

- Test 1: Create a PR with no snapshot. PR workflow should fail and post comments on PR. 😃
- Test 2: Create a PR with snaphot but no changes to the bicep deployment. PR workflow should pass with message "No resource changes detected in the snapshot.". Deploy workflow should not run as no changes to the bicep files. 😃
- Test 3: Create a PR with snapshot and changes to the bicep deployment. PR workflow should pass with message "Resource changes detected in the snapshot: Please review the results in the Validate snapshot step and ensure the changes are expected.". Deploy workflow should run, perform the deployment, update the snapshot and commit the new snapshot file to the repo.
- Test 4: Update resources