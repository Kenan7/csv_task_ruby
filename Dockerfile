# Base image
FROM ruby:3.2.1

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential \
                       nodejs \
                       yarn \
                       postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy app files
COPY Gemfile* ./
RUN bundle install
COPY . .

# Start app
CMD ["rails", "server", "-b", "0.0.0.0"]
