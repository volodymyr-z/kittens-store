FROM ruby:2.4.9-alpine as build
RUN apk update && apk add --no-cache postgresql-dev build-base

COPY Gemfile Gemfile.lock ./
WORKDIR /app
RUN bundle install -j4

FROM ruby:2.4.9-alpine

RUN apk add --update --no-cache postgresql-client
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . /app
WORKDIR /app

ENTRYPOINT ["bundle", "exec"]
CMD ["rackup"]
