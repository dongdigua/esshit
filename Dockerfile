FROM elixir:1.13.4-alpine
WORKDIR /pot
COPY . .
RUN mix compile
CMD ["mix", "run", "--no-halt"]
