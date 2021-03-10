# Advanced PHP Buildpack

This buildpack is a fork from
[CHH/heroku-buildpack-php](https://github.com/CHH/heroku-buildpack-php) which
has been improved for the PaaS https://scalingo.com to have a better PHP
support.

## Characteristics

* __Nginx__ 1.3 to 1.10 - __PHP__ 5.3 (without extension), 5.4, 5.5, 5.6, 7.0 and 7.1 - __PHP FPM__
* Lightweight stack compared to Apache-ModPHP
* Composer support
* Various frameworks support out of the box (no configuration)
* Dynamic installing of [supported extensions](support/ext) listed as `ext-` requirements in `composer.json`.

## How to use it

This buildpack is used automatically by Scalingo. So you just need to create a
PHP application and to deploy it.

```
scalingo create my-php-app
```

Install CLI tool → https://cli.scalingo.com

### Node.js for assets building

If you have `package.json` file in your repository, Node.js will be installed
automatically and dependencies will be installed according to the `package.json`
file. The dependencies are installed, including those declared in
`devDependencies`. This is the default behaviour as most of the time,
dependencies to bundle the assets are declared as development dependencies.

You can disable this feature by defining the environment variable `PHP_BUILDPACK_NO_NODE=true`.

You might want to disable it when you want a fined grained management of the Node.js part by using
the official [Node.js buildpack](https://github.com/Scalingo/nodejs-buildpack) in combination with this
buildpack thanks to the [Multi buildpack](https://doc.scalingo.com/platform/deployment/buildpacks/multi).

More information on this [documentation page](https://doc.scalingo.com/languages/php/php-nodejs).

## Available versions

[Available PHP Versions](https://storage.gra.cloud.ovh.net/v1/AUTH_be65d32d71a6435589a419eac98613f2/scalingo-php-buildpack/manifest.php)

[Available NGINX Versions](https://storage.gra.cloud.ovh.net/v1/AUTH_be65d32d71a6435589a419eac98613f2/scalingo-php-buildpack/manifest.nginx)

## Detection

This buildpack detects apps when the app has a `composer.json` in the app's root.

If an `index.php` is detected in the app's root, then it switches to "classic mode",
which means that every ".php" file is served with PHP, and the document root is set
to the app root.

When a `composer.json` is detected, then the buildpack does `composer
install --no-dev`.

This buildpack also detects when the app has a Node.js `package.json` in the
app's root. And will install Node.js dependencies like less for example.

## Web concurrency

The number of `php-fpm` workers is defined dynamically according to the size of the
container you are using.

If you want to override this value, you can define the environment variable `WEB_CONCURRENCY`

## Frameworks

### Wordpress

Wordpress sites are automatically detected and all the URL rewriting configuration is automatically set.

### CakePHP

Is used when the app requires the `pear-pear.cakephp.org/CakePHP` Pear package or when the
`extra.paas.framework` key is set to `cakephp2` in the `composer.json`. This project assumes the layout given in the [FriendsOfCake/app-template](https://github.com/FriendsOfCake/app-template) composer project.

Options:

* `index-document`: With CakePHP apps, this should be the file where `$Dispatcher->dispatch(new CakeRequest(), new CakeResponse());`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Classic PHP

Used when no framework is detected, serves all the `.php` files from the document root.

This is also used when an `index.php` file was found in the root of your project and no `composer.json`.

### Magento

Is used when the `extra.paas.framework` key is set to `magento` in the `composer.json`.

### Silex

Is used when the app requires the `silex/silex` package or when the
`framework` setting is set to `silex` in the `composer.json`.

Options:

* `index-document`: With Silex apps, this should be the file where `$app->run()`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Slim

Is used when the app requires the `slim/slim` package or when the
`extra.paas.framework` key is set to `slim` in the `composer.json`.

Options:

* `index-document`: With Slim apps, this should be the file where `$app->run()`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Lumen

Is used when the app requires the `laravel/lumen-framework` package or when the
`extra.paas.framework` key is set to `lumen` in the `composer.json`.

### Symfony

Is detected when the app requires the `symfony/symfony` package or when the
`framework` setting is set to `symfony` in the `composer.json`.

This framework preset doesn't need any configuration to work.

Please note that if you use config vars in Composer hooks, or in `compile`
scripts, then a new code push may be necessary if you decide to change a config variable.

#### Custom configuration

* `ASSETS_ROOT`: If you're using webpack or any other tool to handle your assets, you
  can specify an additional directory, relative to `web/` to read your assets. For instance
  if you build your assets in `web/dist/, please define:

```
ASSETS_ROOT=/dist
```

> The application document root is already the `web` directory, you don't need to specify it

### Laravel

Detected when `laravel/framework` is required in your `composer.json`

### Change 4

Detected when `rbschange/core` is required in your `composer.json`.

### Yii

Detected when `yiisoft/yii` is required in your `composer.json`.

### Yii2

Detected when `yiisoft/yii2` or `yiisoft-yii2-dev` is required in your `composer.json`

## Extensions

When the buildpack encounters `ext-` requirements in your `composer.json`, it will look
up the extension name in the [supported extensions](support/ext) and install them.

The version constraint is ignored currently.

For example, to install the Sundown extension:

```
{
    "require": {
        "ext-sundown": "*"
    }
}
```

Note that the extension requirements defined by dependencies are not taken into account there.
It must be required by the project itself.

## Logging

This buildpack defines default log files by framework.
It also defines log files nginx and php.

## Blackfire

The buildpack support automatically [Blackfire](https://blackfire.io) for monitoring if the
following environment variables are set:

* `BLACKFIRE_SERVER_ID`
* `BLACKFIRE_SERVER_TOKEN`

## Configuration

Configuration is done via a file named `composer.json` in the app's
root.

A simple configuration could look like this:

    {
        "require": {
            "php": ">=5.4.0",
            "silex/silex": "~1.0@dev"
        },
        "extra": {
            "paas": {
                "document-root": "web",
                "index-document": "index.php"
            }
        }
    }

This configures an app with the document root set to the project's `web`
directory, and sets that all requests should go through `web/index.php`
which contains the application's front controller.

### Configuration Directives

This buildpack supports configuration through directives placed in the `paas`
key in the `extra` object.

#### framework

_Default: Null_

Use a framework preset for configuration. Some configuration keys cannot
be overriden!

Available presets:

* `cakephp2`
* `magento`
* `silex` (needs `document-root` and `index-document` set)
* `slim`
* `symfony`

Example:

    "framework": "silex"

#### document-root

Document root relative to the app root. Defaults to the app root.

    "document-root": "web"

#### index-document

_Default: "index.php"_

Index Document relative to the document root.

    "index-document": "app.php"

#### engines

Set PHP and NGINX versions.

To launch the app with PHP 5.3.23 and NGINX 1.3.14:

    "engines": {
        "php": "5.3.23",
        "nginx": "1.3.14"
    }

Set the version to "default" to use the current default version. The current
default versions are NGINX `1.4.4` and PHP `5.5.10`.

The version identifiers can also include wildcards, e.g. `5.4.*`. At the
time of writing, PHP `5.4.26` would be used in this case. This also
works for NGINX.

When a file named `.php-version` exists in the project root, then the
PHP version is read from this file instead.

See also:

* [Available PHP Versions](https://lb1047.pcs.ovh.net/v1/AUTH_c91a9132e4f149809d23b20b6de57161/appsdeck-buildpack-php/manifest.php)
* [Available NGINX Versions](https://lb1047.pcs.ovh.net/v1/AUTH_c91a9132e4f149809d23b20b6de57161/appsdeck-buildpack-php/manifest.nginx)

#### php-config

_Default: []_

Add directives to the `php.ini`.

    "php-config": [
        "display_errors=off",
        "short_open_tag=on"
    ]

#### php-includes

_Default: []_

Include additional .ini files that should be parsed after the default php.ini. File paths
are treated relative to the app root.

Example:

    "php-includes": ["etc/php.ini"]

#### nginx-includes

_Default: []_

Include additional config files into the NGINX configuration. Config
files are included into the `server` scope and are loaded after the
framework provided config. File paths are treated relative to the app
root.

Example:

    "nginx-includes": ["etc/nginx.conf"]

#### compile

_Default: []_

Run console commands on slug compilation.

    "compile": [
        "php app/console assetic:dump --env=prod --no-debug"
    ]

_Note: pecl is not runnable this way._

#### new-relic

_Default: false_

Enable instrumentation support via [New Relic](https://newrelic.com).
You need to define the environment variable `NEW_RELIC_LICENSE_KEY` for your
application on your dashboard.


    "new-relic": true

#### log-files

_Default: []_

The buildpack defines default log files by framework and some log files for php-fpm and nginx.
Any file put in `log-files` will be be appended to the list.
A tail on each unique log file will be run at application startup

    "log-files": [
        "app/logs/rabbit-mq.log",
        "vendor/nginx/stuff.log"
    ],


## Node.js

If your app contains a `package.json`, Node.js and its dependencies will be
installed

The Node.js buildpack is based on the [heroku diet Node.js buildpack](https://github.com/heroku/heroku-buildpack-nodejs/tree/diet).
This diet branch of the buildpack is intended to replace the official Node.js buildpack once it has been tested by some users.

It :
- Uses the latest stable version of node and npm by default.
- Allows any recent version of node to be used, including pre-release versions, as soon as they become available on [nodejs.org/dist](http://nodejs.org/dist/).
- Uses the version of npm that comes bundled with node instead of downloading and compiling them separately. npm has been bundled with node since [v0.6.3 (Nov 2011)](http://blog.nodejs.org/2011/11/25/node-v0-6-3/). This effectively means that node versions `<0.6.3` are no longer supported, and that the `engines.npm` field in package.json is now ignored.
- Makes use of an s3 caching proxy of nodejs.org for faster downloads of the node binaries.
- Makes fewer HTTP requests when resolving node versions.
- Uses an updated version of [node-semver](https://github.com/isaacs/node-semver) for dependency resolution.
- No longer depends on SCONS.
- Caches the `node_modules` directory across builds.
- Runs `npm prune` after restoring cached modules, to ensure that any modules formerly used by your app aren't needlessly installed and/or compiled.

A minimal `package.json` file with less will look like this :
```json
{
    "author": "Your Name",
    "name": "App",
    "dependencies": {
        "less": ">= 1.4.*"
    }
}
```

Node and its modules will be available at compilation meaning you could process
Node.js script at that time.

## Contributing

Please see the [CONTRIBUTING](/CONTRIBUTING.md) file for all the details.
