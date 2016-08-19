# B-DESIGNWORKS

[![Build Status](https://semaphoreci.com/api/v1/projects/1ee1a880-7c50-47f2-9c3d-a2ae9560874d/913687/shields_badge.svg)](https://semaphoreci.com/fs/b-designworks)
[![Code Climate](https://codeclimate.com/repos/57b6d54bc0f30d2d63005390/badges/4a73824810fdc7231b28/gpa.svg)](https://codeclimate.com/repos/57b6d54bc0f30d2d63005390/feed)
[![Test Coverage](https://codeclimate.com/repos/57b6d54bc0f30d2d63005390/badges/4a73824810fdc7231b28/coverage.svg)](https://codeclimate.com/repos/57b6d54bc0f30d2d63005390/coverage)
[![Issue Count](https://codeclimate.com/repos/57b6d54bc0f30d2d63005390/badges/4a73824810fdc7231b28/issue_count.svg)](https://codeclimate.com/repos/57b6d54bc0f30d2d63005390/feed)

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
