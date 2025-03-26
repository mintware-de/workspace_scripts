# workspace_scripts

This is a quick and dirty solution for running commands in all projects in
a [dart workspace](https://dart.dev/tools/pub/workspaces) project.


> **Caution**: It runs stable but the code is a mess since I wrote it in 30 minutes to get a quick solution for my
> specific
> problem.  
> If the dart developers do not provide a native built-in solution for the problem I'll consider to clean it up.

## Installation

Setup your workspace project as described here in [Pub workspaces](https://dart.dev/tools/pub/workspaces).

Now add the `workspace_scripts` package using this command:

```bash
dart pub global activate workspace_scripts
```

In your workspace `pubspec.yaml` add the `workspace_scripts` key and add the commands:

```yaml
# Workspace pubspec.yaml
name: _
publish_to: none

workspace:
  - packages/a
  - packages/b
  - packages/c

# ...

workspace_scripts:
  build_watch: # name of the script
    command: dart                               # command to execute 
    arguments: [ 'run', 'build_runner', 'watch' ] # arguments to pass to the command
```

Now you're able to run `workspace_scripts run build_watch` (`build_watch` is the name of your script).

In the example above this will start 3 processes (`package/a`, `package/b`, `package/c`) with the command
`dart run build_runner watch`.