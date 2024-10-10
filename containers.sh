export FZF_DEFAULT_COMMAND="find -name '*.yml' | sort --reverse"
SCRIPT_PATH=$(dirname "$0")

up() {
    cd $SCRIPT_PATH
    config_file=$(fzf --preview='cat {}')

    if [ -z "${config_file}" ]; then exit; fi

    config_file_with_path=${SCRIPT_PATH}/${config_file}

    if [ -L "${config_file_with_path}" ]
    then
        absolute_target=$( _symlink $config_file_with_path )

        location=$(dirname $absolute_target)
        cd $location

        config_file_with_path=$absolute_target
    fi

    docker compose -f $config_file_with_path up -d

    _service_run $config_file_with_path
}


down() {
    cd $SCRIPT_PATH
    config_file=$(fzf --preview='cat {}')

    if [ -z "${config_file}" ]; then exit; fi

    config_file_with_path=${SCRIPT_PATH}/${config_file}

    if [ -L "${config_file_with_path}" ]
    then
        absolute_target=$( _symlink $config_file_with_path )

        location=$(dirname $absolute_target)
        cd $location

        config_file_with_path=$absolute_target
    fi

    docker compose -f $config_file_with_path down
}


_symlink() {
    config_file_with_path=$1

    absolute_target=$(readlink $config_file_with_path)
    echo $absolute_target
}


_service_run() {
    config_file_with_path=$1

    service_run=$(cat $config_file_with_path | grep "# service_run:" | sed 's/\# service_run://g')

    if [ -z "${service_run}" ]; then exit; fi

    google-chrome $service_run
}


$1