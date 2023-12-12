# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.14)
# FROM dart:stable AS build

FROM google/dart as build

# FROM ubuntu:23.04 as builder

# RUN apt update  && apt install --no-install-recommends -y \
#     apt-transport-https \
#     ca-certificates \
#     git \
#     gnupg \
#     openssh-client \
#     wget 

# RUN  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
# RUN ECHO 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |  tee /etc/apt/sources.list.d/dart_stable.list


# RUN apt update  && apt install --no-install-recommends -y \
#     dart


ENV ONEPUB_TOKEN=MTg2MDpjZDVkNjA3Mi1jZWFjLTQzMzYtYjdkZC0zODZhMjQ3NGI1ZmU=
RUN dart pub global activate onepub
RUN onepub import

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.lock ./
COPY pubspec.yaml ./

RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .

RUN rm ./pubspec_overrides.yaml


# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
# RUN dart pub run build_runner build --delete-conflicting-outputs
RUN dart compile exe bin/ihserver.dart -o bin/ihserver

# copy in the release config which will overwrite the
# dev config the above command copied in.
COPY release/ ./config/

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
ADD busybox.tar.xz /
COPY --from=build /runtime/ /
COPY --from=build /app/ /app/

WORKDIR /app
# Start server.
EXPOSE 1080 10443
ENTRYPOINT ["/app/bin/ihserver"]
# ENTRYPOINT ["/bin/sh"]
