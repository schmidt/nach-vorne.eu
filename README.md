nach-vorne.eu
=============

These are the source files for my portfolio page at
[nach-vorne.eu](https://www.nach-vorne.eu/). They are based on jekyll and hosted
on [5apps.com](https://5apps.com).

Deploy
------

One time

```
git config alias.build '!git reset HEAD && git rm -r _site && jekyll build && git add _site; git ci -m "Update build"'
git config alias.deploy "subtree push --prefix _site 5apps master"

gem install bundler
bundle install
```

Every time

```
git build
git deploy
```
