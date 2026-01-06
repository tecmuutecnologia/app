fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios upload_testflight_external

```sh
[bundle exec] fastlane ios upload_testflight_external
```

Upload to TestFlight (external) using App Store Connect API Key

### ios upload_testflight_internal

```sh
[bundle exec] fastlane ios upload_testflight_internal
```

Upload to TestFlight (internal) using App Store Connect API Key

### ios distribute_existing_build_internal

```sh
[bundle exec] fastlane ios distribute_existing_build_internal
```

Distribute existing build (86) to Internal TestFlight testers

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
