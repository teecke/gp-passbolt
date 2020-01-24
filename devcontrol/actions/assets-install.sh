#!/bin/bash

set -eu

# @description Install item assets
#
# @example
#   assets-install
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the assets installation
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function assets-install() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Install assets"
    helpMessage=$(cat <<EOF
Install nginx product assets:

* Create the "data/passbolt/config/gpg" and "data/var/www/passbolt/webroot/img/public" directories  with all permissions (777)
* Create the network "platform_services"
EOF
)

    # Task choosing
    case $1 in
        brief)
            showBriefMessage "${FUNCNAME[0]}" "$briefMessage"
            ;;
        help)
            showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
            ;;
        exec)
            # Create network
            if [ "$(docker network ls -f name='platform_services' -q)" == "" ]; then
                echo -n "- Creating docker network 'platform_services' ..."
                docker network create platform_services
                echo "[OK]"
            else
                echo "The 'platform_services' docker network already exists, skipping"
            fi
            # Create directories
            for directory in data \
                             data/passbolt data/passbolt/config data/passbolt/config data/passbolt/config/gpg \
                             data/var data/var/www data/var/www/passbolt data/var/www/passbolt/webroot data/var/www/passbolt/webroot/img data/var/www/passbolt/webroot/img/public
            do
                if [ ! -d ${directory} ]; then
                    echo -n "- Creating '${directory}' directory..."
                    mkdir ${directory}
                    echo "[OK]"
                    echo -n "- Setting '${directory}' permissions..."
                    chmod 777 ${directory}
                    echo "[OK]"
                else
                    echo "The '${directory}' directory already exists, skipping"
                fi
            done
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
assets-install "$@"
