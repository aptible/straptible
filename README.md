# ![](lib/straptible/rails/templates/public.api/icon-60px.png) Straptible

[![Gem Version](https://badge.fury.io/rb/straptible.png)](https://rubygems.org/gems/straptible)
[![Build Status](https://secure.travis-ci.org/aptible/straptible.png?branch=master)](http://travis-ci.org/aptible/straptible)
[![Dependency Status](https://gemnasium.com/aptible/straptible.png)](https://gemnasium.com/aptible/straptible)

A tool for bootstrapping new applications, document repositories, etc. according to Aptible's hyperopinionated best practices.


## Usage

    gem install straptible

Then, to create a new project, first choose your flavor:

| Flavor Name | Description |
| ---------:| ------- |
| `webapp` (*coming soon*) | Rails web app |
| `api` | Rails API — similar to `webapp`, but tailored and stripped down for a JSON API |
| `gem` | Ruby gem |
| `docs` (*coming soon*) | Document repository |

Then, run:

    straptible <flavor> <path> [options...]


## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2014 [Aptible](https://www.aptible.com), [Frank Macreery](https://github.com/fancyremarker), and contributors.

[<img src="https://s.gravatar.com/avatar/f7790b867ae619ae0496460aa28c5861?s=60" style="border-radius: 50%;" alt="@fancyremarker" />](https://github.com/fancyremarker)
