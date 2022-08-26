FROM ubuntu:latest

RUN apt-get -qq update && apt-get install -q -qq -y --no-install-recommends \
	  bash \
	  openssl \
	  wget \
	  ca-certificates \
	  git \
  && apt-get clean && apt-get autoclean

RUN groupadd --gid 10000 developer && useradd --uid 10000 --gid 10000 developer --create-home && mkdir -p /home/developer/.m2 && mkdir -p /opt && mkdir /src

RUN wget -q https://cdn.azul.com/zulu/bin/zulu17.36.17-ca-jdk17.0.4.1-linux_x64.tar.gz && tar -xvzf zulu17.36.17-ca-jdk17.0.4.1-linux_x64.tar.gz > /dev/null && rm zulu17.36.17-ca-jdk17.0.4.1-linux_x64.tar.gz && mv zulu17.36.17-ca-jdk17.0.4.1-linux_x64 /opt/zulu11

RUN wget -q https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && tar -xvzf apache-maven-3.8.6-bin.tar.gz > /dev/null && rm apache-maven-3.8.6-bin.tar.gz && mv apache-maven-3.8.6 /opt/maven

RUN wget -q https://nodejs.org/download/release/v11.15.0/node-v11.15.0-linux-x64.tar.gz && tar -xvzf node-v11.15.0-linux-x64.tar.gz > /dev/null && rm node-v11.15.0-linux-x64.tar.gz && mv node-v11.15.0-linux-x64 /opt/nodejs

ENV JAVA_HOME=/opt/zulu11
ENV MAVEN_HOME=/opt/maven
ENV NODE_HOME=/opt/nodejs
ENV PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin

# configure Maven with custom settings for defined M2 repository path
COPY maven-settings.xml /opt/maven/conf/settings.xml
RUN mkdir -p /m2/repository && chmod -R a+rw /m2 && chmod -R g+s /m2

RUN npm install -g bower && npm install -g gulp
RUN echo "\nJAVA:" && java --version && echo "\nMAVEN:" && mvn --version && echo "\nNODE:" && npm --version && echo

RUN chmod -R a+rwx /home/developer/
USER developer:developer
ENV HOME=/home/developer

WORKDIR /src
CMD ["bash"]
