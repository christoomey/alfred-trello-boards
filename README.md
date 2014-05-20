Trelfred
========

An experimental [Alfred][] Workflow for quickly visiting [Trello][] boards.

[Alfred]: http://www.alfredapp.com/
[Trello]: https://trello.com/

Ruby Version
------------

By default Alfred workflows will run against system Ruby, which doesn't work so
well. This workflow expects there to be a bash script in your home directory that
will set up your Ruby version manager. This can be rvm, rbenv, chruby, direct
$PATH manipulation, or something else.

For RVM:

``` bash
# ~/.ruby-version-shim
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
```

For rbenv, do this at the command line:

```bash
rbenv init - --no-rehash > ~/.ruby-version-shim
```

If you're using something different, pull requests are very welcome.

Credentials
-----------

Trelfred expects credentials be exposed in a `~/.env` file. The file should have
the following structure / keys:

``` env
TRELLO_USERNAME=ctoomey
TRELLO_DEVELOPER_KEY=14363e6563fea5ace63d6f
TRELLO_TOKEN=0fd4c5bbab47cc9c2b81dcbedaf28061a1ac0934f14c7475af8857b76de96b99
```

### TRELLO DEVELOPER KEY

You can generate this key by visiting [here](https://trello.com/1/appKey/generate)

### TRELLO TOKEN

You can generate this key by visiting the following URL (**note** you will have
to replace the developer token in this URL):

https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=Trelfred&expiration=never&response_type=token

You can find more detail in the Trello API Documentation - [Generating a Token
from a User][] section.

[Generating a Token from a User]: https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user

Installation
------------

OK, now you're set up. Symlink the whole folder into `~/Library/Application
Support/Alfred 2/Alfred.alfredpreferences/workflows/` to tell Alfred about it.

Usage
-----

This workflow consists of two pieces:

- A `cache-trello` keyword in Alfred to cache the boards (via `boards.rb`)
- A `trello` keyword in Alfred to open a specific board

Run `cache-trello` to cache the boards before using the `trello` keyword.
