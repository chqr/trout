FROM ruby:2.7.0-alpine

ARG VERSION

LABEL version=$VERSION

# Copy and install gem
COPY ./pkg/trout-$VERSION.gem /tmp
RUN gem install /tmp/trout-$VERSION.gem && \
    rm -f /tmp/trout-*.gem

ENTRYPOINT ["trout"]
