# Heroku Ruby Docker Image

This image is to create a development environment for Ruby on Rails consistent with the Heroku Cedar environment.

## Usage

This container is built on Ruby 2.3.3p222 with NodeJS 6.9.4.  Rails is not built in.


Run it with Docker:

```sh-session
$ docker run -it -p 3000:3000 -v <path to root ruby on rails project>:/app/user josiah14/heroku-ruby418
```

You'll be able to access your application at `http://localhost:3000` on the host machine when you run the server, but you need to specify the host and port.  `rails s -b 0.0.0.0 -p 3000`.
