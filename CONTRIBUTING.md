# Contributing

## Branching

The `master` branch should always contain production ready code. All
features which are staged to go into the next release are found in the
`development` branch.

Releases are done by merging `development` to `master` and creating a
tag on `master` which follows [Semantic Versioning][].

[Semantic Versioning]: https://semver.scalingo.io

Features should always live in their own branch. Feature branches start
with `feature/`, e.g. a name for your feature branch might be `feature/my-awesome-feature`.
Feature branches should branch off `master`, and get merged to
`development` once they are reviewed.

* * *

Please submit pull requests to the `development` branch. The
`development` branch is used to make new releases of this buildpack,
which are available to _all_ users.

## Hacking

### Setup

You need the following tools to hack on this project:

* A bucket from an Openstack Swift instance (e.g. https://www.ovh.com/us/cloud/storage/object-storage.xml)
* `swift` command
* `docker` to get Scalingo development stack

Setup the Swift bucket and get your `swift` command working. You can test if the
command is working using `swift stat -v`. You swift bucket must be public. Then
configure the file `conf/buildpack.conf`:

```
export SWIFT_BUCKET=scalingo-php-buildpack
export SWIFT_URL=https://storage.gra.cloud.ovh.net/v1/AUTH_be65d32d71a6435589a419eac98613f2/${SWIFT_BUCKET}
```

To test your version of the buildpack, you will need jq in the swift bucket:

```
./support/package_jq
```

Then create a Scalingo app and set BUILDPACK_URL

```
mkdir myexampleapp
cd myexampleapp
git init
scalingo create <appname>
scalingo env-set BUILDPACK_URL=https://github.com/youruser/php-buildpack.git#feature/my-awesome-feature
```

### Packaging third-party bins/libs

Packaging should be done through the Scalingo docker image `scalingo/buildpacks-builder:latest`

```
docker run -v $(pwd):/buildpack -it scalingo/buildpacks-builder:latest bash
```

All packaging scripts are in the `support` directory and are named
`package_<type>`, where `<type>` is either `nginx` or `php`. All
packaging scripts take the desired package version as first argument.

When the packaging is complete, the manifest which lists all available
package version is updated for the package type. Manifests are plain
text files which list each available version on a separate line.

They're uploaded to the Swift bucket as `manifest.<type>` files,
e.g. the manifest for PHP is `manifest.php`.

Before packaging anything, you need to make sure that you've a Zlib
tarball in your swift bucket. Both NGINX and PHP depend on it. _You need
the exact version which is set in the packaging scripts._

To get one, use `support/get_zlib <version>`, for example:

    ./support/get_zlib 1.2.8

PHP also depends on mcrypt. Get the exact same version which is set in the
packaging scripts using:

	./support/get_mcrypt 2.5.8

#### Updating NGINX

NGINX is packaged by the script `support/package_nginx`.

For example, to build NGINX `1.5.2`:

    ./support/package_nginx 1.5.2

#### Updating PHP

PHP is packaged by the script `support/package_php`.

For example, to build PHP `5.6.1`:

    ./support/package_php 5.6.1

