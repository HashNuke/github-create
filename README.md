github-create
==============

Adds an executable `ghcreate` which will help you by creating github repos from your command line

Install
--------

        gem install github-create


Usage
------

        ghcreate -c REPO_NAME

Options
--------

`-c, --c NAME`              specifying the name of the repo to create

`-p, --private`             create private repo

`--clear`                   clear github username, stored in $HOME/.github-create

`-r, --remote NAME`         set the origin name. If not specified origin or github is used

`-h, --help`                displays help message
