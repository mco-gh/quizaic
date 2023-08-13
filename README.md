# <img src="website/static/logo.png" height="40"> Quizrd - AI-powered Infinite Trivia

Quizrd is a trivia quiz app with a twist - it uses Artificial Intelligence to generate the quizzes based on user input.


## Architecture

### Data/User Model
<img src="website/static/datauser.png" height="300">

### Creator/Hosting Flow
<img src="website/static/creator.png" height="300">

### Player Flow
<img src="website/static/player.png" height="300">

## Project Status

* **Release Stage:** Alpha
* **Setup:** Follow the instructions to set up Quizrd in the [Getting Started](#getting-started) section below.

## Contributing

* Become a [CONTRIBUTOR](./CONTRIBUTING.md)!

## Getting Started

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

1. Set your account, project, and region in the gcloud CLI using these commands:

    ```bash
    gcloud config set account <your-account@gmail.com>
    gcloud config set project <your-project-id>
    gcloud config set compute/region <your-region>
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

1. Run `./scripts/setup.sh` to deploy backend services.

1. Run `./scripts/configure_auth.sh` to setup OAuth credentials and secrets
   needed for users to log into the application.

## Verify Setup

Connect to the website URL given by the output from the previous deployment script and
verify the website looks something like this:

<img src="website/static/website.png" height="300">

Also, try to log in as a user to make sure OAuth is setup correctly and create &
run quizzes to make sure everything works.

## Deployment

You can incrementally deploy services (instead of redeploying everything).

### Content API

```bash
./scripts/deploy.sh content-api
```

### Website

```bash
./scripts/deploy.sh website
```

## Local Testing

You can make changes in services and test them locally without deploying.

### Content API

```bash
./scripts/test.sh content-api
```

### Website

First, you need to store your OAuth web client's id and secret (which
can be obtained from the `APIs & Services` -> `Credentials` page on the Cloud
console) as environment variables in `$HOME/keys.sh`, like this:

```bash
export CLIENT_ID=<your-client-id>
export CLIENT_SECRET=<your-client-secret>
```

You also need to add `http://localhost:8080/callback` under `APIs & Services` ->
`Credentials` -> `Authorized redirect URIs`.

Website depends on content-api. Make sure content-api is running locally first:

```bash
./scripts/test.sh content-api
```

You should be able to test the website locally now:

```bash
./scripts/test.sh website
```

---

Quizrd is not an official Google project.
