#!/usr/bin/env bash

# Change this to your S3 Bucket if you have custom binaries
export STACK="${STACK:-scalingo-22}"
export SWIFT_BUCKET=scalingo-php-buildpack
export PHP_BASE_URL="${PHP_BASE_URL:-https://storage.gra.cloud.ovh.net/v1/AUTH_be65d32d71a6435589a419eac98613f2/${SWIFT_BUCKET}/${STACK}}"
export NGINX_BASE_URL="${NGINX_BASE_URL:-https://nginx-buildpack.s3.amazonaws.com/${STACK}}"

SEMVER_SERVER="https://semver.scalingo.com"

declare -A PHP_MODULE_API_VERSIONS
PHP_MODULE_API_VERSIONS["5.4"]="20100525"
PHP_MODULE_API_VERSIONS["5.5"]="20121212"
PHP_MODULE_API_VERSIONS["5.6"]="20131226"
PHP_MODULE_API_VERSIONS["7.0"]="20151012"
PHP_MODULE_API_VERSIONS["7.1"]="20160303"
PHP_MODULE_API_VERSIONS["7.2"]="20170718"
PHP_MODULE_API_VERSIONS["7.3"]="20180731"
PHP_MODULE_API_VERSIONS["7.4"]="20190902"
PHP_MODULE_API_VERSIONS["8.0"]="20200930"
PHP_MODULE_API_VERSIONS["8.1"]="20210902"
PHP_MODULE_API_VERSIONS["8.2"]="20220829"
PHP_MODULE_API_VERSIONS["8.3"]="20230831"
PHP_MODULE_API_VERSIONS["8.4"]="20240924"

# The following lib versions are used for lib we statically store on Swift.
# They are downloaded, compiled and stored with /support/get_* scripts.

libmemcached_version="1.0.18"
# Mandatory for multibytes strings starting with PHP 7.4
libonig_version="${libonig_version:-6.9.10}"
librabbitmq_version="0.15.0"

memcached_version="3.4.0"
gmp_version="6.3.0"
tidy_version="5.8.0"
sodium_version="1.0.20"
webp_version="${webp_version:-1.6.0}" # Can be found here: https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html
# From https://zlib.net/
zlib_version="${zlib_version:-1.3.1}"

# PHP extensions versions
igbinary_version="3.2.16"
mongodb_version="1.21.0"
amqp_version="2.1.2"
phpredis_version="6.2.0"
apcu_version="5.1.27"
newrelic_version="11.5.0.18"


# Legacy support
# These variables are used when building PHP 7.4 on scalingo-22 and scalingo-24.
# Although EOL for a long time, we still want to support this version of PHP on
# more recent stacks for customers that can't switch to a more recent version
# of PHP.

# For PHP < 8.1
pre81_mongodb_version="1.20.1"

# For PHP < 8.1 + scalingo-22 and 24:
pre81_openssl_version="1.1.1w"
