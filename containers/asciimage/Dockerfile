FROM golang:1.20.2-alpine3.17 AS builder
ARG AIC_VERSION=1.13.0
RUN go install github.com/TheZoraiz/ascii-image-converter@v${AIC_VERSION}

# Generate a clean end user image
FROM alpine:3.17
COPY --from=builder /go/bin/ascii-image-converter /go/bin/ascii-image-converter
ENTRYPOINT [ "/go/bin/ascii-image-converter" ]