- Run tests and make sure they all pass
- Increment the version in pubspec.yaml (top level and msix_version)
- Add the new release to metainfo (for linux)
- Check the Changelog
- Push all changes and check that CI is green
- Create the release on Github
- Update the Flathub repo (new version and sha256, check by running `flatpak-builder --user --install --force-clean build-dir io.github.mideb.digitales_register.yaml`)
- Publish to Windows Store (run `dart run msix:create --store`)
- Publish Android, iOS and macOS versions