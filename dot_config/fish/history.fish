fish_add_path "/Applications/ShellHistory.app/Contents/Helpers"

if [ ! -n "$__shhist_session" ]
    if [ -n "$TERM_SESSION_ID" ]
        set __shhist_session $TERM_SESSION_ID
    else
        set __shhist_session (random)-$fish_pid
    end
end

functions --copy fish_prompt fish_prompt_original
function fish_prompt
    set __shhist_status $status

    if fish_is_root_user
        set __shhist_user $SUDO_USER
    else
        set __shhist_user $LOGNAME
    end

    \history --show-time="%s " -1 | sudo --preserve-env --user $__shhist_user /Applications/ShellHistory.app/Contents/Helpers/shhist insert --session $__shhist_session --username $LOGNAME --hostname (hostname) --exit-code $__shhist_status --shell fish

    fish_prompt_original;
end
