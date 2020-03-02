#Set a keybinding which backs up or restore a command-line.
#1. If the command-line is not empty, that is backed up and the command-line is made empty.
#2. If the command-line is empty, the last backed up command-line is restored.
#Command-lines are pushed into or popped from a command-line stack.

mapped_key='"\C-b"' #By default, the functionality is mapped to Ctrl+b. Change this line as you like.

____is_debug_mode=0 #Set 1 to turn on debug output.

declare -a ____command_line_stack
____command_line_stack_index=0

____is_argc_zero() {
    [[ $# == 0 ]]
}

____colored_print() {
    echo -e "\e[092m$@\e[0m"
    echo
}

____command_line_stack_main() {

    if [[ ${READLINE_LINE} =~ ^\ *$ ]]; then #pop

        if [[ ${____command_line_stack_index} == 0 ]]; then
            
            ____colored_print "Command-line stack is empty."

        else

            (( --____command_line_stack_index ))

            if [[ ${____is_debug_mode} == 1 ]]; then
                ____colored_print "Popped [ ${____command_line_stack[${____command_line_stack_index}]} ]."
            fi

            READLINE_LINE=${____command_line_stack[${____command_line_stack_index}]}
            READLINE_POINT=${#READLINE_LINE} #moves cursor to the end of the line

        fi

    else #push

        ____command_line_stack[____command_line_stack_index]=${READLINE_LINE}

        ____colored_print "Pushed [ ${____command_line_stack[${____command_line_stack_index}]} ]."

        #makes the command-line empty
        READLINE_LINE=

        (( ++____command_line_stack_index ))

    fi

    if [[ ${____is_debug_mode} == 1 ]]; then
        echo -e "\tCurrent Stack:"
        for i in $(seq 0 $(( ____command_line_stack_index - 1 ))); do
            echo -e "\tstack[$i] = ${____command_line_stack[$i]}"
        done
        echo
    fi

}

bind -x ${mapped_key}': "____command_line_stack_main"'

