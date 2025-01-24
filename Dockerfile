FROM docker-registry.dp.nlmk.com/gradle:7.5-jdk18-jammy

ARG ANDROID_COMPILE_SDK=34 \
    ANDROID_BUILD_TOOLS=34.0.0 \
    ANDROID_SDK_TOOLS=11076708

ENV LANG=en_US.UTF-8 \
  ANDROID_HOME=/opt/android-sdk

SHELL ["/bin/bash", "-ex", "-o", "pipefail", "-c"]

RUN apt-get update; \
  apt-get install -y rbenv ruby-bundler ruby-full; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/*

WORKDIR ${ANDROID_HOME}
RUN curl https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip -o /tmp/cmdline-tools.zip \
    && unzip -d cmdline-tools /tmp/cmdline-tools.zip \
    && mv cmdline-tools/cmdline-tools cmdline-tools/tools \
    && rm /tmp/cmdline-tools.zip

ENV PATH=$PATH:${ANDROID_HOME}/cmdline-tools/tools/bin/

RUN sdkmanager --version && yes | sdkmanager --licenses > /dev/null || true \
    && sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" \
    && sdkmanager "platform-tools" \
    && sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"
