# Heroku Ruby Docker Image

This image is for use with Heroku Docker CLI.

## Usage

Your project must contain the following files:

* `Gemfile` and `Gemfile.lock`
* Ruby 2.3.3p222


And run it with Docker:

```sh-session
$ docker run -it -p 3000:3000 josiah14/heroku-ruby418
```

.

You'll be able to access your application at `http://localhost:3000` on the host machine when you run the server.
