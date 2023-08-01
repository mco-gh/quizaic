pyquizrd is a Python package that creates trivia quizzes using static datasets and generative AI.

This package is preliminary and still under construction.

This package is maintained using [poetry](https://python-poetry.org/).

To add a new package dependency:

- Run `poetry add <pkg>`. This adds the package to your `poetry.lock` file and installs it into your virtual environment.
- Run this command to have the new package reflected in `requirements.txt`:
    ```
    poetry export -f requirements.txt --output requirements.txt
    ```
- At this point you can access the new package in one of two ways:

  1. Install the contents of requirements.txt into your current default env with this command: 
      ```
      pip install -r requirements.txt
      ```
  2. Run any desired command (e.g. `pytest`) in a poetry virtual env with this command:
      ```
      poetry run pytest
      ```
