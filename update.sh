#!/usr/bin/env bash

# jQuery version
JQUERY_VERSION='1.10.2'

# jQuery Migrate version
JQUERY_MIGRATE_VERSION='1.2.1'

# Twitter Bootstrap version
TWBS_VERSION='3.0.2'

# Font-awesome version
FA_VERSION='4.0.3'

# Selectize.js version
SELECTIZE_VERSION='0.8.5'

# Bootstrap datepicker version
BSDP_VERSION='master'

## Functions and helpers
# Color codes, NC is reset
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;37;41m'

# Display a log message with time
logmsg() {
    echo -e "[`date '+%F %T'`] ${1}"
}

# Display a success message
ok() {
    echo -e "${GREEN}${1}${NC}"
}

# Display a warning
warn() {
    echo -e "${YELLOW}${1}${NC}"
}

# Display an error
error() {
    echo -e "${RED}${1}${NC}"
}

# Move file
dmv() {
    mv "${1}" "${2}"
    if [ $? == 0 ]; then
        ok "Moved ${NC}${1}${GREEN} to ${NC}${2}${GREEN}..."
    else
        warn "!!! Could not move ${NC}${1}${YELLOW} to ${NC}${2}${YELLOW}..."
    fi
}

# Remove file or directory
drm() {
    rm -rf "${1}"
    if [ $? == 0 ]; then
        ok "Deleted ${NC}${1}${GREEN}..."
    else
        warn "!!! Could not delete ${NC}${1}${YELLOW}..."
    fi
}

# Download file
ddl() {
    if [ ! -f "${2}" ] || [ ${3} ]; then
        wget -q -O "${2}" "${1}"
        if [ $? == 0 ]; then
            ok "Downloaded ${NC}${1}${GREEN} to ${NC}${2}${GREEN}..."
        else
            warn "!!! Could not download ${NC}${1}${YELLOW}..."
        fi
    fi
}

# Extract tar.gz file
dtarx() {
    tar xfz "${1}"
    if [ $? == 0 ]; then
        ok "Extracted ${NC}${1}${GREEN}..."
    else
        warn "!!! Could not extract ${NC}${1}${YELLOW}..."
    fi
}

# Create a directory recursively
dmkdir() {
    mkdir -p "${1}"
    if [ $? == 0 ]; then
        ok "Created ${NC}${1}${GREEN}..."
    else
        warn "!!! Could not create folder ${NC}${1}${YELLOW}..."
    fi
}

dsed() {
    tmp=`mktemp "sedXXXXXX"`
    if [ $? == 0 ]; then
        sed -e "${2}" "${1}" > "${tmp}"
        if [ $? == 0 ]; then
            mv "${tmp}" "${1}"
            if [ $? == 0 ]; then
                ok "Updated ${NC}${1}${GREEN}..."
            else
                warn "!!! Could not move file ${NC}${1}${YELLOW} back..."
                rm $tmp
            fi
        else
            warn "!!! Could not fullfill replacement ${NC}${2}${YELLOW} in ${NC}${1}${YELLOW}..."
            rm $tmp
        fi
    else
        warn "!!! Could not create temporary file..."
    fi
}
logmsg "Starting..."

## Twitter bootstrap
TWBS_URL="https://github.com/twbs/bootstrap/archive/v${TWBS_VERSION}.tar.gz"
TWBS_OUT="twbs-${TWBS_VERSION}.tgz"
TWBS_DIR="bootstrap-${TWBS_VERSION}/"

ddl "${TWBS_URL}" "${TWBS_OUT}"
dtarx "${TWBS_OUT}"

dmkdir "Resources/js"
dmv "${TWBS_DIR}dist/js/bootstrap.js" "Resources/js/"
for f in ${TWBS_DIR}js/*.js; do
    dmv "${f}" "Resources/js/"
done

dmkdir "Resources/public/fonts"
for f in ${TWBS_DIR}dist/fonts/*; do
    dmv "${f}" "Resources/public/fonts/"
done

dmkdir "Resources/less/bootstrap"
for f in ${TWBS_DIR}less/*.less; do
    dmv "${f}" "Resources/less/bootstrap/"
done

### Font awesome
FA_URL="https://github.com/FortAwesome/Font-Awesome/archive/v${FA_VERSION}.tar.gz"
FA_OUT="fa-${FA_VERSION}.tgz"
FA_DIR="Font-Awesome-${FA_VERSION}/"

ddl "${FA_URL}" "${FA_OUT}"
dtarx "${FA_OUT}"

dmkdir "Resources/public/fonts"
for f in ${FA_DIR}fonts/*; do
    dmv "${f}" "Resources/public/fonts/"
done

dmkdir "Resources/less/font-awesome"
for f in ${FA_DIR}less/*.less; do
    dmv "${f}" "Resources/less/font-awesome/"
done

### jQuery and jQuery migrate
JQUERY_URL="http://code.jquery.com/jquery-${JQUERY_VERSION}.js"
JQUERY_MIGRATE_URL="http://code.jquery.com/jquery-migrate-${JQUERY_MIGRATE_VERSION}.js"

dmkdir "Resources/js"
ddl "${JQUERY_URL}" "Resources/js/jquery.js" true
ddl "${JQUERY_MIGRATE_URL}" "Resources/js/jquery-migrate.js" true

#### Selectize.js
SELECTIZE_URL="https://github.com/brianreavis/selectize.js/archive/v${SELECTIZE_VERSION}.tar.gz"
SELECTIZE_OUT="selectize.js-${SELECTIZE_VERSION}.tgz"
SELECTIZE_DIR="selectize.js-${SELECTIZE_VERSION}/"

ddl "${SELECTIZE_URL}" "${SELECTIZE_OUT}"
dtarx "${SELECTIZE_OUT}"

dmkdir "Resources/js"
dmv "${SELECTIZE_DIR}dist/js/standalone/selectize.js" "Resources/js/"

dmkdir "Resources/less/selectize.js"
for f in ${SELECTIZE_DIR}dist/less/*.less; do
    dmv "${f}" "Resources/less/selectize.js/"
done

dmkdir "Resources/less/selectize.js/plugins"
for f in ${SELECTIZE_DIR}dist/less/plugins/*.less; do
    dmv "${f}" "Resources/less/selectize.js/plugins/"
done

## Bootstrap datepicker plugin
BSDP_URL="https://github.com/eternicode/bootstrap-datepicker/archive/${BSDP_VERSION}.tar.gz"
BSDP_OUT="bootstrap-datepicker-${BSDP_VERSION}.tgz"
BSDP_DIR="bootstrap-datepicker-${BSDP_VERSION}/"

ddl "${BSDP_URL}" "${BSDP_OUT}"
dtarx "${BSDP_OUT}"

dmkdir "Resources/less/bootstrap-datepicker"
dmv "${BSDP_DIR}less/datepicker.less" "Resources/less/bootstrap-datepicker/"

dmkdir "Resources/js"
dmv "${BSDP_DIR}js/bootstrap-datepicker.js" "Resources/js/"

dmkdir "Resources/public/js/locale/bootstrap-datepicker"
for f in ${BSDP_DIR}js/locales/bootstrap-datepicker.*.js; do
    dmv "${f}" "Resources/public/js/locale/bootstrap-datepicker/"
done

## Cleanup
drm "${TWBS_DIR}"
drm "${FA_DIR}"
drm "${SELECTIZE_DIR}"
drm "${BSDP_DIR}"

drm "${TWBS_OUT}"
drm "${FA_OUT}"
drm "${SELECTIZE_OUT}"
drm "${BSDP_OUT}"

logmsg "Done"
