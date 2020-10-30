FROM elixir:1.10-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

ENV SECRET_KEY_BASE=6v+LKpr/9fjcvPUUTEH5syAyMptcOds9P1dCnAYaWlv7dZn48Nchk5004OFw0/NJ

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
RUN mix deps.get
RUN mix deps.compile

# build project
RUN mix compile

# test project
# ENV MIX_ENV=test
# RUN mix test
ENV MIX_ENV=prod

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --update bash openssl curl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/apis ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD bin/apis start

