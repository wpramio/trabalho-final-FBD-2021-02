FROM ruby:3.0

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local path '/usr/src/bundle'
RUN bundle install --jobs 4

COPY . .

CMD ["./app.rb"]
