Trelfred
========

An experimental [Alfred][] Workflow for quickly visiting [Trello][] boards.

[Alfred]: http://www.alfredapp.com/
[Trello]: https://trello.com/

Ruby Version
------------

By default Alfred workflows will run against system Ruby. This is sub optimal.
This workflow expects there to be bash script in your home directory that will
do whatever form of ruby version management you are partial to. This can be
rvm, rbenv, chruby, direct $PATH manipulation, or other. In my case, I user
RVM, so I have added the RVM init code to the file:

``` bash
# ~/.ruby-version-shim
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
```

Create this file and alter this as needed to make use of your preferred ruby version system.

Gems
----

The repo contains a gemfile with the dependencies. Run `bundle install` to
install the needed gems. Make sure to do this with the default ruby specified
by the `~/.ruby-version-shim` file.

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

https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=Trelfred&expiration=30days&response_type=token

You can find more detail in the Trello API Documentation - [Generating a Token
from a User][] section.

[Generating a Token from a User]: https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user

Usage
-----

This workflow prosodies two pieces:

- A caching script `cache-trello`
- A script filter to prompt / open boards

The boards must be cached before the filter / opening can happen.
