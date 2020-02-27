# Docker Login Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) to log in to specific registries using Podman.

## Securing your credentials

To avoid leaking your credentials to Buildkite or anyone with access to your build logs, you need to avoid including them in `pipeline.yml`. This means they need to be set specifically with environment variables in an [agent hook](https://buildkite.com/docs/agent/hooks).

The examples below show how to provide passwords for single and multiple registries.

## Example: Log in to Quay.io (or a single server)

```bash
# Environment or pre-command hook
export PODMAN_LOGIN_PASSWORD=mysecurepassword
```

(Note that an encrypted token for the `kennasecurity+developers` robot account will be accessible by default on all our Buildkite agents.)

```yml
steps:
  - command: .buildkite/test.sh
    plugins:
      - kennasecurity/podman-login:
          username: kennasecurity+developers
```

## Example: Log in to multiple registries

```bash
# environment or pre-command hook
export PODMAN_LOGIN_MY_PRIVATE_REGISTRY=mysecurepassword1
export PODMAN_LOGIN_ANOTHER_REGISTRY=mysecurepassword2
```

```yml
steps:
  - command: .buildkite/test.sh
    plugins:
      - kennasecurity/podman-login:
          server: my.cool.registry
          username: my-username
          password-env: PODMAN_LOGIN_MY_PRIVATE_REGISTRY
      - kennasecurity/podman-login:
          server: another.cool.registry
          username: my-other-usename
          password-env: PODMAN_LOGIN_ANOTHER_REGISTRY
```

## Options

### `username`

The username to send to the registry.

### `server` (optional)

The server to log in to, if blank or ommitted logs into Quay.

### `password-env`

The environment variable that the password is stored in

Defaults to `PODMAN_LOGIN_PASSWORD`.
