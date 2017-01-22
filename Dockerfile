FROM heroku/cedar:14
MAINTAINER Josiah Berkebile <praenato14@gmail.com>

RUN mkdir -p /app/user
WORKDIR /app/user

RUN apt update -y

# Install developer tools
RUN apt install -y git vim nano sqlite3

# Zsh for those who want it.
RUN apt install -y zsh
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ENV GEM_PATH /app/heroku/ruby/bundle/ruby/2.3.3
ENV GEM_HOME /app/heroku/ruby/bundle/ruby/2.3.3
RUN mkdir -p /app/heroku/ruby/bundle/ruby/2.3.3

# Install Ruby
RUN mkdir -p /app/heroku/ruby/ruby-2.3.3
RUN curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/cedar-14/ruby-2.3.3.tgz | tar xz -C /app/heroku/ruby/ruby-2.3.3
ENV PATH /app/heroku/ruby/ruby-2.3.3/bin:$PATH

# Install Node
RUN curl -s --retry 3 -L http://s3pository.heroku.com/node/v6.9.4/node-v6.9.4-linux-x64.tar.gz | tar xz -C /app/heroku/ruby/
RUN mv /app/heroku/ruby/node-v6.9.4-linux-x64 /app/heroku/ruby/node-6.9.4
ENV PATH /app/heroku/ruby/node-6.9.4/bin:$PATH

# Install Bundler
RUN gem install bundler -v 1.13.7 --no-ri --no-rdoc
ENV PATH /app/user/bin:/app/heroku/ruby/bundle/ruby/2.3.3/bin:$PATH
ENV BUNDLE_APP_CONFIG /app/heroku/ruby/.bundle/config

# We probably don't need the below
# # Run bundler to cache dependencies
# ONBUILD COPY ["Gemfile", "Gemfile.lock", "/app/user/"]
# ONBUILD RUN bundle install --path /app/heroku/ruby/bundle --jobs 4
# ONBUILD ADD . /app/user

# We can probably set the env vars ourselves, and not worry about precompiling - do that manually
# # How to conditionally `rake assets:precompile`?
# ONBUILD ENV RAILS_ENV production
# ONBUILD ENV SECRET_KEY_BASE $(openssl rand -base64 32)
# ONBUILD RUN bundle exec rake assets:precompile

# Set the env vars
ENV RAILS_ENV development
ENV SECRET_KEY_BASE $(openssl rand -base64 32)

# # export env vars during run time
# RUN mkdir -p /app/.profile.d/
# RUN echo "cd /app/user/" > /app/.profile.d/home.sh
# ONBUILD RUN echo "export PATH=\"$PATH\" GEM_PATH=\"$GEM_PATH\" GEM_HOME=\"$GEM_HOME\" RAILS_ENV=\"\${RAILS_ENV:-$RAILS_ENV}\" SECRET_KEY_BASE=\"\${SECRET_KEY_BASE:-$SECRET_KEY_BASE}\" BUNDLE_APP_CONFIG=\"$BUNDLE_APP_CONFIG\"" > /app/.profile.d/ruby.sh

# COPY ./init.sh /usr/bin/init.sh
# RUN chmod +x /usr/bin/init.sh

# ENTRYPOINT ["/usr/bin/init.sh"]
EXPOSE 3000
ENTRYPOINT ["/bin/zsh"]
