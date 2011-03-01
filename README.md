github-create
==============

Adds an executable `ghcreate` which will help you by creating github repos from your command line.

*Won't work with windows*

Install
--------

        gem install github-create


Usage
------

        ghcreate -c REPO_NAME

Options
--------

`-c NAME, --create NAME`              specify the name of the repo to create

`-p, --private`             creates private repo when this option is used

`--clear`                   clear github username, stored in $HOME/.github-create

`-r NAME, --remote NAME`         set the origin name. If not specified origin or github is used

`-h, --help`                displays help message
