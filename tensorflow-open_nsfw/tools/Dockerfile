FROM registry.redhat.io/ubi8/python-36

RUN pip install --upgrade pip setuptools && \
    pip install minio

ENV MINIO_SERVICE_HOST minio:9000
ENV MINIO_USER minio
ENV MINIO_PWD minio123

COPY saved_model /tmp/saved_model
ADD s3uploader.py /tmp

WORKDIR /tmp

CMD [ "python", "s3uploader.py" ]
