# Fail your bash script/command if there is any invisible error

- e: Exit immediately if any command in the script returns a non-zero (failure) status. This helps in stopping the script execution upon encountering an error, which can prevent further commands from running in an unstable state.

- u: Treat unset variables as an error and exit immediately. This is useful for catching typos or mistakes with variable names, ensuring that each variable is explicitly defined before use.

- x: Print each command before executing it. This is known as "trace mode", and it’s helpful for debugging, as you can see the commands the script is running in real time.

- o: A general option that can be combined with various flags

> Add this as default in your github action

```bash

defaults:
  run:
    shell: bash -euxo pipefail {0}

```

> or  you can add this to your individual task

```bash
set -euxo pipefail
```
