# syntax=docker/dockerfile:1
# Contract. The runtime stage keeps: non-root user, port 8080, /healthz and /readyz served,
# SIGTERM handled, no build tools in the final image. Fill the build stage for the language.

FROM alpine:3.22 AS build
WORKDIR /src
COPY . .
# build here; produce /src/out/app

FROM alpine:3.22
RUN adduser -D -u 10001 app
USER 10001
WORKDIR /app
COPY --from=build /src/out/app /app/app
EXPOSE 8080
ENTRYPOINT ["/app/app"]
