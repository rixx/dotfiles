function gi --description "Generate gitignore from gitignore.io"
    curl -fL "https://www.gitignore.io/api/"(string join "," $argv)
end
