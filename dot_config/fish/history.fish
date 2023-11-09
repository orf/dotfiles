fish_add_path "/Applications/ShellHistory.app/Contents/Helpers"

if [ ! -n "$__shhist_session" ]
    if [ -n "$TERM_SESSION_ID" ]
        set __shhist_session $TERM_SESSION_ID
    else
        set __shhist_session (random)-$fish_pid
    end
end

function _shist_postexec -e fish_postexec

    set __shhist_status $status

    if fish_is_root_user
        set __shhist_user $SUDO_USER
    else
        set __shhist_user $LOGNAME
    end

    echo (date +%s) $argv | sudo --preserve-env --user $__shhist_user /Applications/ShellHistory.app/Contents/Helpers/shhist insert --session $__shhist_session --username $LOGNAME --hostname (prompt_hostname) --exit-code $__shhist_status --shell fish
end
