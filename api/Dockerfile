FROM registry.redhat.io/ubi8/python-36

RUN pip install --upgrade pip setuptools && \
    pip install flask flask_cors numpy requests

ADD config.py /usr/local/bin/
ADD app.py /usr/local/bin/

CMD [ "python", "/usr/local/bin/app.py" ]
