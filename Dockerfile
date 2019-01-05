# OCRmyPDF
#
FROM      ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential autoconf automake libtool \
  libleptonica-dev \
  zlib1g-dev \
  libexempi3 \
  ocrmypdf \
  pngquant \
  python3-pip \
  python3-setuptools \
  tesseract-ocr \
  tesseract-ocr-eng \
  tesseract-ocr-dan \
  unpaper \
  inotify-tools \
  wget


ENV LANG=C.UTF-8

# Compile and install jbig2
# Needs libleptonica-dev, zlib1g-dev
RUN \
  mkdir jbig2 \
  && wget -q https://github.com/agl/jbig2enc/archive/0.29.tar.gz -O - | \
      tar xz -C jbig2 --strip-components=1 \
  && cd jbig2 \
  && ./autogen.sh && ./configure && make && make install \
  && cd .. \
  && rm -rf jbig2

# This installs the latest binary wheel instead of the code in the current
# folder. Installing from source will fail, apparently because cffi needs
# build-essentials (gcc) to do a source installation
# (i.e. "pip install ."). It's unclear to me why this is the case.
RUN pip3 install --upgrade ocrmypdf

# Remove the junk, including the source version of application since it was
# already installed
RUN rm -rf /tmp/* /var/tmp/* /root/* \
  && apt-get remove -y autoconf automake libtool build-essential \
  && apt-get autoremove -y \
  && apt-get autoclean -y

RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker

USER docker
WORKDIR /home/docker

COPY runocr.sh /
ENTRYPOINT ["/runocr.sh"]
