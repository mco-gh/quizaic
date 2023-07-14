# <img src="website/static/logo.png" height="40"> Quizrd - AI-powered Infinite Trivia

Quizrd is a trivia quiz app with a twist - it uses Artificial Intelligence to generate the quizzes based on user input.

## Foundation

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

## Getting Started

Quizrd is made of a combination of resources created via the Google Cloud CLI or Google Cloud Console. You may deploy Quizrd by running `setup.sh` (see [Setup](#setup)). 

### Prerequisites

To deploy Quizrd, you will need:
<!-- * 3 Google Cloud projects (ops, stage, prod) with billing enabled on each) -->
* A Google Cloud project with billing enabled
* A clone of this repo

The machine that you will run the setup from will need the following installed:
<!-- * [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) -->
* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
* [Python3](https://www.python.org/downloads)

### Gcloud Configuration and Github Repo

1. Set your account and project in the gcloud CLI using these commands:

    ```bash
    gcloud config set account <your-account@gmail.com>
    gcloud config set project <your-project-id>
    ```

1. Clone the source code from github and change to the new directory with these commands:

    ```bash
    git clone https://github.com/mco-gh/quizrd
    cd quizrd
    ```

### Setup

1. Run the following commands to install the [OpenAPI](https://www.openapis.org) command line tool:

    ```bash
    sudo npm install @openapitools/openapi-generator-cli -g
    ```

1. Run `./setup.sh` to deploy backend services.

1. Run `./scripts/configure_auth.sh` to setup Oauth credentials and secrets
   needed for users to log into the application.

## Verify Setup

Connect to the URL given by the output from the previous deployment script and
verify the website looks something like this:

<img src="website/static/website.png" height="300">

Also, try to log in as a user to make sure OAuth is setup correctly and create &
run quizzes to make sure everything works.

## Incremental Deployment

You can incrementally deploy services (instead of redeploying everyting).

### Content API

```bash
cd content-api
./deploy.sh
```

### Website

```bash
cd website
./deploy.sh
```

## Local Testing

You can make changes in services and test them locally without deploying.

### Content API

```bash
cd content-api
python3 main.py
./test.sh path
```

### Website

For local testing you need to store your oauth web client's id and secret (which
can be obtained from the `APIs & Services` -> `Credentials` page on the Cloud
console) as environment variables in `$HOME/keys.sh`, like this:

```bash
export CLIENT_ID=<your-client-id>
export CLIENT_SECRET=<your-client-secret>
```

You also need to add `http://localhost:8080/callback` under `APIs & Services` ->
`Credentials` -> `Authorized redirect URIs`.

You should be able to test the web server locally now:

```bash
cd website
./test.sh
```

---

Quizrd is not an official Google project.
