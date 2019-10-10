FROM openjdk:8

## The set up below is from the spring guide that recommends breaking up the spring boot app this way
## Calling the main calss directly improves start up time.
## To take advantage of the clean separation between dependencies and application resources in a
## Spring Boot fat jar file, we will use a slightly different implementation of the Dockerfile.
## https://spring.io/guides/gs/spring-boot-docker/
ARG DEPENDENCY=build/dependency
## When copying over we need to change ownership, otherwise defaults to root

COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib/
COPY ${DEPENDENCY}/META-INF /app/META-INF/
COPY ${DEPENDENCY}/BOOT-INF/classes /app/

WORKDIR /app
COPY package.json /app
RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y npm
RUN npm install
COPY . /app

ENTRYPOINT ["java", \
            "-server", \
            "-cp","/app:/app/lib/*", \
            "-XX:+UnlockExperimentalVMOptions", \
            "-XX:+UseCGroupMemoryLimitForHeap", \
            "-XX:MaxRAMFraction=1", \
            "com.projectdrgn.sandbox.SandboxApplicationKt", \
            "--spring.config.location=file:/app/bootstrap.yml,classpath:/application.yml"]
