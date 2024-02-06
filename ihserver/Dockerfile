# A potential docker container that you can use to run the IAHServer
# This is not well tested.
# This could be used in either development or production by changing
# EXPOSE command at the bottom this file as well as the config.yaml
# port settings.

FROM google/dart as build

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
# Expose ports for development
EXPOSE 80 443
ENTRYPOINT ["/app/bin/ihserver"]
# ENTRYPOINT ["/bin/sh"]
