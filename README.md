# Bicep Snapshot

[![Validate Bicep Snapshot](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml) [![Deploy Resources](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml)

> [!NOTE]
> This repo has a detailed companion post explaining the workflow on [howdoyou.cloud](https://howdoyou.cloud/posts/finding-orphaned-azure-resources/)

## Introduction

With release v0.41.2 the Bicep team relased a new command `bicep snapshot` which generates a JSON file conatining a normalised view of the resources declared in a Bicep deployment. You can read about the command in the [Bicep release notes](https://github.com/Azure/bicep/releases/tag/v0.41.2).<br><br>
The aim of this command is to give bicep users an easier way to validate any changes that have been made to a bicep deployment without needing to crawl through potentially large changes to nested modules.<br><br>
The workflow would go a little something like this:

1. Create a Bicep template and parameter file to deploy some resources to Azure.
2. Create a snapshot file using the `bicep snapshot` command.
3. Make some changes to the Bicep template or parameter file.
4. Run the `bicep snapshot` command again in validate mode to compare the changes with the previously saved snapshot.

The output when run in a terminal is very similar to the output from a `what-if` but trimmed down to just the resources or properties that have changed. Making it much easier to quickly validate the changes have had the desired effect before deployment.

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

## Using snapshots with version control

The snapshot file is a JSON file which can be included in version control and used to track changes to your Bicep deployments. This will be particularly useful for complicated deployments using many nested modules. With the snapshot file you can quickly check the history of one single file in the repository.

## Automating the process with GitHub Actions

I wanted to see if I could integrate Bicep Snapshots into a CI/CD pipeline, providing a method of automated validation using pull requests to detect if changes and inform a reviewer about resource changes before deployment.<br><br>

The result ended up being two GitHub Actions workflows:

**Snapshot Workflow** - This workflow is triggered on a pull request to the main branch and performs the following steps:
1. Checks for the existance of a snapshot file in the incoming pull request. If it doesn't find one the run is aborted and a comment is created on the pull request asking the contributor to include one.
2. If a snapshot file is present the workflow runs `bicep snapshot` in validate mode checking if the deployment state matches the snapshot file. If changes are found a comment is created stating the reviewer should check the run logs for more details. If no changes are detected a comment is created telling the reviewer that snapshot validation passed. Providing a quick and easy way to increase confidence that merging the pull request won't cause any unexpected changes to the Bicep deployment.

**Deploy Workflow** - This workflow is triggered on a push to the main branch and performs the following steps:
1. The Bicep deployment is exectuted.
2. The snapshot file is updated by running `bicep snapshot` in overwrite mode and commited back to the repository. Ensuring the snapshot file is automatically kept up to date.

## Conclusion

The `bicep snapshot` command is a great addition to the Bicep CLI. You can find more information about how the workflows in this repo operate by visiting the linked post on my blog. See above for the link. If you have any questions or suggestions for improvements please feel free to open an issue or submit a pull request.

💪