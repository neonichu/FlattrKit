#!/bin/sh

mkdir -p help &&
appledoc \
  --project-name FlattrKit \
  --project-company "Boris Buegling" \
  --company-id org.vu0 \
  --output ./help \
  --keep-intermediate-files \
  --no-create-docset \
  . 2>&1|grep -v NXOAuth2
