function dirInfo
    # Check if git is available
    if git rev-parse 2>/dev/null

        # Git project absolute path
        set -l gitProjectPath (git rev-parse --show-toplevel)

        # Show NodeJS version when NodeJS project
        if test (find "$gitProjectPath" -maxdepth 1 -type d -name 'node_modules')
            echo -s (set_color blue) "node" ' ' (node -v) ' '
        end

        # Git project it's parent path
        set -l parentPath (git rev-parse --show-toplevel | sed -r 's/[^\/]+$//g')
        # Get the relative path to the project it's parent path
        set -l relPath (realpath './' --relative-base="$parentPath")
        
        echo -s (set_color brblue) "[$relPath]"

        # Git status indicator
        if test (git status --short --null)
            # Dirty
            echo -s (set_color red) " ░░ "
        else
            # Clean
            echo -s (set_color green) " ▓▓ "
        end

        # Git branch name
        echo -s (set_color normal) "[git:" (git rev-parse --abbrev-ref HEAD) "]"
    else
        # Show the file path
        echo -s (set_color blue) (prompt_pwd)
    end

    # Reset any color changes made
    echo (set_color normal)
end

# Defined in /usr/share/fish/functions/fish_prompt.fish @ line 5
function fish_prompt --description 'Write out the prompt'
	  set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '# '
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$ '
    end

    echo;
    echo -s (set_color bryellow) "$USER@$hostname" ' ' (dirInfo)
    echo -s (set_color bryellow) "$suffix" (set_color normal)
end
