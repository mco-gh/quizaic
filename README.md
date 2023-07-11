# <img src="website/static/logo.png" height="40"> Quizrd - AI-powered Infinite Trivia

Quizrd is a trivia quiz app with a twist - it uses Artificial Intelligence to generate the quizzes based on user input.

## Credit

Quizrd is built on top of [Emblem Giving](https://github.com/GoogleCloudPlatform/emblem), which is a sample application intended to demonstrate a complex, end-to-end serverless architecture. It showcases serverless continuous delivery as a donation sample app hosted on Google Cloud.

## Architecture

### Data/User Model
<img src="website/static/datauser.png" height="300">

<!-- ### Creator/Hosting Flow
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
  * A Google Cloud projects with billing enabled
  * A fork of this repo

The machine that you will run the setup from will need the following installed:
<!-- * [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) -->
  * [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
  * [Python3](https://www.python.org/downloads)

We recommend running through setup steps using Google Cloud Shell, which has the required softare pre-installed. The following will open Cloud Shell Editor and clone this repo:

 [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fmco-gh%2Fquizrd&cloudshell_tutorial=docs%2Ftutorials%2Fsetup-walkthrough.md)

### Streamlined setup



---

This is not an official Google project.
