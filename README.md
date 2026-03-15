# Bicep Snapshot

[![Validate Bicep Snapshot](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/snapshot.yml) [![Deploy Resources](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml/badge.svg)](https://github.com/paul-mccormack/bicepsnapshot/actions/workflows/deploy.yml)

> [!NOTE]
> This repo will have a detailed companion post explaining the workflow within the next few days! Watch this space: [howdoyou.cloud](https://howdoyou.cloud/)

## Introduction

With release v0.41.2 a new command was made generally available: `bicep snapshot`, which generates a JSON file containing a normalized view of the resources declared in a Bicep deployment. You can read about the command in the [Bicep release notes](https://github.com/Azure/bicep/releases/tag/v0.41.2).<br><br>
The aim of this command is to give Bicep users an easier way to validate any changes that have been made to a Bicep deployment without needing to crawl through potentially large templates using nested modules.<br><br>
The workflow for this feature would go something like this:

1. Create a Bicep template and parameter file to deploy some resources to Azure.
2. Create a snapshot file using the `bicep snapshot` command in overwrite mode.
3. Make some changes to the Bicep template or parameter file.
4. Run the `bicep snapshot` command again in validate mode to compare the changes with the previously saved snapshot.

The output when run in a terminal is very similar to the output from a `what-if` but trimmed down to just the resources or properties that have changed. Making it much easier to quickly validate the changes have had only the desired effect before deployment.

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

## Using snapshots with version control

The snapshot file is a JSON file which can be included in version control and used to track changes to your Bicep deployments. With the snapshot file checked in and tracked you can quickly check the history of one single file in the repository to track changes that have been made to the resources over time.

## Automating the process with GitHub Actions

Bicep snapshot seems like a great feature but I wanted to see if I could integrate it into a CI/CD pipeline, providing a method of automated validation using pull requests to detect if changes have occurred and inform a reviewer before deployment.<br><br>

The result ended up being two GitHub Actions workflows:

**Snapshot Workflow** - This workflow is triggered on a pull request to the main branch and performs the following steps:
1. Checks for the existance of a snapshot file in the incoming pull request. If it doesn't find one the run is aborted and a comment is created on the pull request asking the contributor to include one.
2. If a snapshot file is present the workflow runs `bicep snapshot` in validate mode checking if the deployment state matches the snapshot file. If changes are found a comment is created stating the reviewer should check the run logs for more details. If no changes are detected a comment is created telling the reviewer that snapshot validation passed. Providing a quick and easy way to increase confidence that merging the pull request won't cause any unexpected changes to the Bicep deployment.

**Deploy Workflow** - This workflow is triggered on a push to the main branch and performs the following steps:
1. The Bicep deployment is executed.
2. The snapshot file is updated by running `bicep snapshot` in overwrite mode and committed back to the repository. Ensuring the snapshot file is automatically kept up to date.

## Conclusion

The `bicep snapshot` command is a great addition to the Bicep CLI. You can find more information about how the workflows in this repo operate by visiting the linked post on my blog. See above for the link. I feel there is still a bit of work to do on this, for example applying branch protection policies to the main branch would stop the automatic update of the snapshot file. I'll look at that and update this repo once I've worked that out. In the meantime, if you have any questions or suggestions for improvements please feel free to open an issue or submit a pull request.

💪