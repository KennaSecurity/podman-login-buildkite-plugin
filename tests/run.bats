#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# export PODMAN_STUB_DEBUG=/dev/tty

@test "Log in to single registry" {
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_USERNAME="jedmonds"
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_SERVER="my.cool.registry"
  export PODMAN_LOGIN_PASSWORD="jpgraz"

  stub podman \
    "login --username jedmonds --password-stdin my.cool.registry : echo logging in to my cool registry"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "logging in to my cool registry"

  unstub podman
}

@test "Default to quay.io when no registry is specified" {
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_USERNAME="jedmonds"
  export PODMAN_LOGIN_PASSWORD="jpgraz"

  stub podman \
    "login --username jedmonds --password-stdin quay.io : echo logging in to quay.io"

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "logging in to quay.io"

  unstub podman
}

@test "Log in to multiple registries" {
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_0_USERNAME="jedmonds"
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_0_SERVER="my.cool.registry"
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_0_PASSWORD_ENV="PODMAN_LOGIN_PASSWORD1"
  export PODMAN_LOGIN_PASSWORD1="jpgraz"
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_1_USERNAME="jedmonds"
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_1_SERVER="my.cooler.registry"
  export BUILDKITE_PLUGIN_PODMAN_LOGIN_1_PASSWORD_ENV="PODMAN_LOGIN_PASSWORD2"
  export PODMAN_LOGIN_PASSWORD2="lilgoat"

  stub podman \
    "login --username jedmonds --password-stdin my.cool.registry : echo logging in to my cool registry" \
    "login --username jedmonds --password-stdin my.cooler.registry : echo logging in to my cooler registry" \

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "logging in to my cool registry"
  assert_output --partial "logging in to my cooler registry"

  unstub podman
}
