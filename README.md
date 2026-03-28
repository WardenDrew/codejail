# Code Jail
This is a dockerized OpenAI Codex container I whipped together to allow for sandboxing Codex in a deterministic way, enforcing boundaries and lack of access outside of intended scope.

`codejail.sh` serves as the main entrypoint and I recommend linking it to your local path i.e: `~/.local/bin/codejail` for ease of use.

`codejail` when run on its own builds and runs an ephemeral docker container with a baseline set of tools, inincluding OpenAI's Codex CLI. The container runs rootless as the `codejail` user inside the container, which is set to the same UID and GID as your host user.

Your current working directory is mounted into the container writeable at `/home/codejail/cell` and your host's `~/.codex` is mounted at `/home/codejail/.codex` writeable as well.

You can additionally mount read-only reference data with the argument `--ref=PATH:NAME` to mount PATH at `/home/codejail/ref/NAME` read-only, i.e. `--ref=../example/knowledge:docs` will resolve `../example/knowledge` to its absolute path and mount that path read-only at `/home/codejail/ref/docs` inside the container.

In its current form, no networking is exposed by default. When logging into Codex you must use the device-code flow to do so. In the future I will explore allowing conditional networking access that can be enabled/disabled mid container execution.

Some other niceties, this container sets up starship with a nerd-font for a nicer looking bash experience while in the container outside of codex as I plan for this to be a launch point for other jailed tools, not just codex.
