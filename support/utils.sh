#!/usr/bin/env bash

php::pkg::swift_upload() {
	local bucket="${1}"
	local file="${2}"

	local key="${STACK}/${file}"

	swift --verbose upload "${bucket}" --object-name "${key}" "${file}"
	swift --verbose post -r '.r:*' "${bucket}" "${key}"
}

php::pkg::swift_download() {
	local bucket="${1}"
	local file="${2}"

	local key="${STACK}/${file}"

	swift --verbose download "${bucket}" "${key}"
}

php::pkg::build_manifest() {
	local bucket="${1}"
	local manifest_type="${2}"

	swift list "${bucket}" \
		| sed "s/^$STACK\/package\///" \
		| grep "\.tgz$" \
		| grep "^php" \
		| grep -v -e ".md5" \
		| sed -e "s/php-\([0-9.]*\)\\.tgz/\\1/" \
		| awk 'BEGIN {FS="."} {printf("%03d.%03d.%03d %s\n",$1,$2,$3,$0)}' \
		| sort -r \
		| cut -d" " -f2 \
		> "manifest.php"

	if [ -n "${DEBUG}" ]; then
		cat "manifest.php"
	fi

	php::pkg::swift_upload "${bucket}" "manifest.php" > /dev/null
}

php::pkg::checksum() {
	local bucket="${1}"
	# package_name shoud be something like "package/php-x.y.z"
	local package_name="${2}"

	# Download package from bucket:
	php::pkg::swift_download "${bucket}" "${package_name}.tgz" > /dev/null

	# Compute md5 checksum,
	# Store it in "package/php-x.y.z.md5":
	md5sum "${STACK}/${package_name}.tgz" \
		| awk '{print $1}' \
		> "${package_name}.md5"

	php::pkg::swift_upload "${bucket}" "${package_name}.md5" > /dev/null
}


readonly -f php::pkg::swift_upload
readonly -f php::pkg::swift_download
readonly -f php::pkg::build_manifest
readonly -f php::pkg::checksum
