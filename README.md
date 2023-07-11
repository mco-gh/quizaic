# <img src="website/static/logo.png" height="40"> Quizrd - AI-powered Infinite Trivia

Quizrd is a trivia quiz app with a twist - it uses Artificial Intelligence to generate the quizzes based on user input.

## Credit

Quizrd is built on top of [Emblem Giving](https://github.com/GoogleCloudPlatform/emblem), which is a sample application intended to demonstrate a complex, end-to-end serverless architecture. It showcases serverless continuous delivery as a donation sample app hosted on Google Cloud.

<!--
## Architecture

### Data/User Model
<img src="website/static/datauser.png" height="300">

### Creator/Hosting Flow
<img src="website/static/creator.png" height="300">

### Player Flow
<img src="website/static/player.png" height="300">
-->

## Project Status

* **Release Stage:** Alpha
* **Self-service / Independent Setup:** Follow the instructions to set up Quizrd in the [Getting Started](#getting-started) section below. 

## Contributing

* Become a [CONTRIBUTOR](./CONTRIBUTING.md)!
* Check out our shovel-ready [Good First Issues](https://github.com/GoogleCloudPlatform/emblem/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22good+first+issue%22) or go a bit deeper in [Help Wanted](https://github.com/GoogleCloudPlatform/emblem/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22help+wanted%22)

## Getting Started

Quizrd is made of a combination of resources created and managed by Terraform and resources created via the Google Cloud CLI or Google Cloud Console. You may deploy Quizrd by running `setup.sh` (see [streamlined setup instructions](#streamlined-setup)). 

### Prerequisites

To deploy Quizrd, you will need:
<!-- * 3 Google Cloud projects (ops, stage, prod) with billing enabled on each) -->
  * A Google Cloud project with billing enabled
  * A fork of this repo

The machine that you will run the setup from will need the following installed:
<!-- * [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) -->
  * [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
  * [Python3](https://www.python.org/downloads)

We recommend running through setup steps using Google Cloud Shell, which has the required softare pre-installed. The following will open Cloud Shell Editor and clone this repo:

 [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fmco-gh%2Fquizrd&cloudshell_tutorial=docs%2Ftutorials%2Fsetup-walkthrough.md)

### Setup Instructions

1. All of the following should be done from the repo's root directory.

1. Set your account and project in the gcloud CLI using these commands:
    ```bash
    gcloud config set account <your-account@gmail.com>
    gcloud config set project <your-project-id>
    ```

1. Enable the required services by running these commands:

    ```bash
    gcloud services enable run.googleapis.com
    gcloud services enable cloudbuild.googleapis.com
    gcloud services enable firestore.googleapis.com
    gcloud firestore databases create --location nam5 # this may need to change!
    ```

1. Edit `scripts/env.sh` to reflect your preferred region and production project and "dot" that file into your environment by running this command:
    ```bash
    . scripts/env.sh` # Don't miss the leading dot!
    ```

1. Run the following commands to populate the Firestore database: 
    ```bash
    cd content-api/data
    python3 seed_database.py seed <your-email-address.gmail.com>
    ```

1. Run the following command to generate the content API using [OpenAPI](https://www.openapis.org):
    ```bash
    scripts/regen_api.sh
    ```

1. Run the following commands to build the content API and deploy it to Cloud Run: 
    ```bash
    cd content-api
    ./deploy.sh
    ```

1. Run the following commands to build the website and deploy it to Cloud Run: 
    ```bash
    cd ../website
    ./deploy.sh
    ```
  
1. Connect to the URL given by the output from the previous deployment script and verify the website looks something like this:
<img src="website/static/website.png" height="300">

---

Quizrd is not an official Google project.
