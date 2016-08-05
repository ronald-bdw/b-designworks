# B-DESIGNWORKS

[![Build Status](https://semaphoreci.com/api/v1/projects/1ee1a880-7c50-47f2-9c3d-a2ae9560874d/913687/shields_badge.svg)](https://semaphoreci.com/fs/b-designworks)

## API

Status of the API could be checked at https://b-designworks.herokuapp.com/docs

### Scripts

* `bin/setup` - setup required gems and migrate db if needed
* `bin/quality` - runs rubocop, brakeman, rails_best_practices and bundle-audit for the app
* `bin/ci` - should be used in the CI or locally
* `bin/server` - to run server locally

## Quick start

Clone application

```bash
git clone git@github.com:fs/b-designworks.git
```

Run setup script

```bash
bin/setup
```

Make sure all test are green

```bash
bin/ci
```

Run app

```bash
bin/server
```
