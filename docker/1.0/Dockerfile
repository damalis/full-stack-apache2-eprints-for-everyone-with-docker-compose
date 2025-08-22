# Use a Debian-based image as the base
FROM debian:latest

LABEL maintainer="erdal80@hotmail.com"
LABEL version="0.0.1"

# Set environment variables (optional, but good practice)
ENV DEBIAN_FRONTEND=noninteractive

ARG ARCHIVE_ID

# Update apt packages and install necessary software
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cron git perl libncurses6 libselinux1 libapache2-mod-perl2 libxml-libxml-perl \
        libunicode-string-perl libterm-readkey-perl libmime-lite-perl libmime-types-perl libdigest-sha-perl \
        libdbd-mysql-perl libxml-parser-perl libxml2-dev libxml-twig-perl libarchive-any-perl libjson-perl \
        liblwp-protocol-https-perl libtext-unidecode-perl libcgi-session-perl lynx wget ghostscript poppler-utils antiword elinks \
        texlive-base texlive-binaries psutils imagemagick adduser tar gzip unzip libsearch-xapian-perl \
        libtex-encode-perl libio-string-perl python3-html2text make libexpat1-dev libxslt1-dev mariadb-client libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m eprints
RUN usermod -a -G eprints www-data
RUN usermod -a -G www-data eprints

WORKDIR /opt/eprints3

RUN chown eprints:eprints /opt/eprints3
RUN chmod 2775 /opt/eprints3

USER eprints

RUN git config --global --add safe.directory /opt/eprints3
RUN git config --global http.sslVerify false
RUN git clone https://github.com/eprints/eprints3.4.git /opt/eprints3
RUN git checkout tags/v3.4.6
RUN mv /opt/eprints3/perl_lib/EPrints/SystemSettings.pm.tmpl /opt/eprints3/perl_lib/EPrints/SystemSettings.pm

RUN chown -R eprints /opt/eprints3

# switch root
USER root

# EXPOSE the port(s) your application will listen on.
# This tells Docker (and anyone inspecting the image) that EPrints listens on port 80 (HTTP).
# You can specify TCP (default) or UDP.
# Expose a port (e.g., 80)
EXPOSE 80

# Add the cron job
RUN echo "23 * * * * eprints /opt/eprints3/bin/generate_views I$ARCHIVE_ID >/dev/null" > /etc/cron.d/eprints

# 00:15 every morning
RUN echo "15 0 * * * eprints /opt/eprints3/bin/send_alerts dookuprints daily" > /etc/cron.daily/eprints

# 00:30 every sunday morning
RUN echo "30 0 * * 0 eprints /opt/eprints3/bin/send_alerts dookuprints weekly" > /etc/cron.weekly/eprints

# 00:45 every first of the month
RUN echo "45 0 1 * * eprints /opt/eprints3/bin/send_alerts dookuprints monthly" > /etc/cron.monthly/eprints

CMD ["cron", "&&", "tail", "-f", "/var/log/cron.log"]
