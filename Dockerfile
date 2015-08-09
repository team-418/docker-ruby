FROM heroku/cedar:14
MAINTAINER Terence Lee <terence@heroku.com>

RUN mkdir -p /app/user
ENV HOME /app/user
WORKDIR /app/user

ENV GEM_PATH /app/heroku/ruby/bundle/ruby/2.2.0
ENV GEM_HOME /app/heroku/ruby/bundle/ruby/2.2.0
RUN mkdir -p /app/heroku/ruby/bundle/ruby/2.2.0

# Install Ruby
RUN mkdir -p /app/heroku/ruby/ruby-2.2.2
RUN curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/cedar-14/ruby-2.2.2.tgz | tar xz -C /app/heroku/ruby/ruby-2.2.2
ENV PATH /app/heroku/ruby/ruby-2.2.2/bin:$PATH

# Install Node
RUN curl -s --retry 3 -L http://s3pository.heroku.com/node/v0.12.7/node-v0.12.7-linux-x64.tar.gz | tar xz -C /app/heroku/ruby/
RUN mv /app/heroku/ruby/node-v0.12.7-linux-x64 /app/heroku/ruby/node-0.12.7
ENV PATH /app/heroku/ruby/node-0.12.7/bin:$PATH

# Install Bundler
RUN gem install bundler -v 1.9.7 --no-ri --no-rdoc
ENV PATH /app/user/bin:/app/heroku/ruby/bundle/ruby/2.2.0/bin:$PATH

# Run bundler to cache dependencies
ONBUILD COPY ["Gemfile", "Gemfile.lock", "/app/user/"]
ONBUILD RUN bundle install --path /app/heroku/ruby/bundle --deployment --without development:test --jobs 4
# user's .bundle/config will override this
ONBUILD RUN cp -rf .bundle /app/heroku/ruby/
ONBUILD ADD . /app/user
ONBUILD RUN rm -rf /app/user/.bundle && cp -rf /app/heroku/ruby/.bundle /app/user/

# How to conditionally `rake assets:precompile`?
ONBUILD RUN bundle exec rake assets:precompile
ONBUILD ENV RAILS_ENV production
ONBUILD ENV SECRET_KEY_BASE openssl rand -base64 32

# export env vars during run time
RUN mkdir -p /app/.profile.d/
RUN echo "cd /app/user/" > /app/.profile.d/home.sh
ONBUILD RUN echo "export PATH=\"$PATH\" GEM_PATH=\"$GEM_PATH\" GEM_HOME=\"$GEM_HOME\" RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=\"$SECRET_KEY_BASE\" HOME=\"$HOME\"" > /app/.profile.d/ruby.sh

COPY ./init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

ENTRYPOINT ["/usr/bin/init.sh"]
