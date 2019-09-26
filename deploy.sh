docker build -t alcobot-ruby -f Dockerfile .
docker tag alcobot-ruby eu.gcr.io/alcobot/alcobot-ruby:latest
docker push eu.gcr.io/alcobot/alcobot-ruby:latest

