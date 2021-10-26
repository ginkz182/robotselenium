FROM python:3.10.0-alpine3.14

ENV SCREEN_WIDTH 1920
ENV SCREEN_HEIGHT 1080
ENV SCREEN_DEPTH 24
ENV DEPS="\
    chromium \
    chromium-chromedriver \
    udev \
    xvfb \
"

COPY requirements.txt /tmp/requirements.txt
COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

RUN apk update && apk add python3-dev \
                        gcc \
                        libffi-dev
RUN apk add --no-cache musl-dev
RUN apk add --no-cache ${DEPS}
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /tmp/requirements.txt
    # Chrome requires docker to have cap_add: SYS_ADMIN if sandbox is on.
    # Disabling sandbox and gpu as default.
RUN sed -i "s/self._arguments\ =\ \[\]/self._arguments\ =\ \['--no-sandbox',\ '--disable-gpu'\]/" $(python -c "import site; print(site.getsitepackages()[0])")/selenium/webdriver/chrome/options.py
    # List packages and python modules installed
RUN apk info -vv | sort
RUN pip freeze
    # Cleanup
RUN rm -rf /var/cache/apk/* /tmp/requirements.txt

ENV CHROME_BIN=/usr/bin/chromedriver
RUN chmod 777 /usr/bin/chromedriver

ENTRYPOINT [ "/opt/bin/entry_point.sh" ]
