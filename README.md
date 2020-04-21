# Roles for postgraphile

To use this, you need to have sqitch installed properly.  To run tests,
you need to have pg_prove installed properly.

# Install

To install, you have two choices.

First, go the usual sqitch route

```
sqitch deploy db:pg://dbuser@dbhost.name:dbport/mydb
```

Alternately, you can set some environment variables and use npm.

```
npm install
```

Accepting the default values, or

```
export SQITCH_DB_USER=someuser
export SQITCH_DB_HOST=dbhostaddress
export SQITCH_DB_PORT=5432
export SQITCH_DB=mysqitchdb
npm install
```

# Tests

The tests use pg_prove, but at the moment they do absolulu nothing.

# Use as a dependency

To use as a dependency in a sqitch project, you have to use npm for
your sqitch project.  Use this package's scripts block as a guide, or
improve it and send me  pull request.  Then:

```
export SQITCH_DB_USER=someuser
export SQITCH_DB_HOST=dbhostaddress
export SQITCH_DB_PORT=5432
export SQITCH_DB=mysqitchdb
npm install -S jmarca/postgraphile_demo_roles
```

That should do the trick.
