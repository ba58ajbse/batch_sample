FROM ruby:2.7.3

## nodejsとyarnはwebpackをインストールする際に必要
# yarnパッケージ管理ツールをインストール
RUN apt-get update -qq && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

WORKDIR /rails_batch_sample
COPY Gemfile /rails_batch_sample//Gemfile
COPY Gemfile.lock /rails_batch_sample//Gemfile.lock
RUN bundle install
COPY . /rails_batch_sample

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
