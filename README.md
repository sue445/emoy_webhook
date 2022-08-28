# emoy_webhook
emoy webhook (**Emo**ji notif**y** webhook) notify when new emoji is add

[![CircleCI](https://circleci.com/gh/sue445/emoy_webhook/tree/main.svg?style=svg)](https://circleci.com/gh/sue445/emoy_webhook/tree/main)
[![docker-ghcr](https://github.com/sue445/emoy_webhook/actions/workflows/docker-ghcr.yml/badge.svg)](https://github.com/sue445/emoy_webhook/actions/workflows/docker-ghcr.yml)
[![docker-gcp](https://github.com/sue445/emoy_webhook/actions/workflows/docker-gcp.yml/badge.svg)](https://github.com/sue445/emoy_webhook/actions/workflows/docker-gcp.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/36a02d23c7caefc9a603/maintainability)](https://codeclimate.com/github/sue445/emoy_webhook/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/sue445/emoy_webhook/badge.svg?branch=main)](https://coveralls.io/github/sue445/emoy_webhook?branch=main)

## Example
![example](img/example.png)

## Requirements
* Slack app
  * see [CREATE_SLACK_APP.md](CREATE_SLACK_APP.md)
* Incoming webhook
  * https://slack.com/apps/A0F7XDUAZ
* redis (optional)

## Getting started
### Docker
This application is provided as a Docker image, so you can run it wherever you like.

#### Images
* [GitHub Container Registry](https://github.com/sue445/emoy_webhook/pkgs/container/emoy_webhook) **(Recommended)**
  * `ghcr.io/sue445/emoy_webhook:latest`: Use latest version
  * `ghcr.io/sue445/emoy_webhook:X.Y.Z`: Use specified version
* [Google Artifact Registry](https://console.cloud.google.com/artifacts/docker/emoy-webhook/asia/emoy-webhook/app): If you want to run this app on [Cloud Run](https://cloud.google.com/run), use this image
  * `asia-docker.pkg.dev/emoy-webhook/emoy-webhook/app:latest`: Use latest version
  * `asia-docker.pkg.dev/emoy-webhook/emoy-webhook/app:X.Y.Z`: Use specified version
  * `asia-docker.pkg.dev/emoy-webhook/emoy-webhook/app:main`: The contents of the main branch are pushed to this tag

#### Available environment variables
* `SLACK_WEBHOOK_URL` **(Required)** : Incoming Webhook URL
* `PUMA_THREADS_MIN` : Puma minimum threads count. default is `0`
* `PUMA_THREADS_MAX` : Puma minimum threads count. default is `1` (to prevent duplicate posts to Slack)
* `PUMA_WORKERS` : Puma workers count. default is `0` (to prevent duplicate posts to Slack)
* `PUMA_PORT` : Puma port. default is `8080`
* `REDIS_URL` : Redis URL (e.g. `redis://path-to-redis:6379`). This variable is optional, but I recommend setting this to prevent duplicate posts to Slack
* `DEBUG_LOGGING` : If `true` is set, debug logs are output

### Heroku
This application was offered as a Heroku application, but [since Heroku is ending its free plan](https://blog.heroku.com/next-chapter), I have made it possible to run it outside of Heroku.

So this app can run outside of Heroku.

If you want to run this app on Heroku, browse [heroku branch](https://github.com/sue445/emoy_webhook/tree/heroku) and click "Deploy to Heroku" button.
