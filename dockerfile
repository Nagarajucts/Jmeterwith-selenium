# Use Windows Server Core as base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set environment variables
ENV JMETER_VERSION=5.6.3
ENV SELENIUM_VERSION=4.24.0
ENV CHROME_DRIVER_VERSION=130.0.6723.69

# Download and install Google Chrome
RUN powershell -Command \
    wget https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B49A95E3A-8DF6-9C04-73DE-646DF8D739EB%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dfalse%26ap%3Dx64-stable%26brand%3DGCEV%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeSetup.exe -OutFile ChromeSetup.exe; \
    Start-Process ChromeSetup.exe -ArgumentList '/silent', '/install' -NoNewWindow -Wait; \
    Remove-Item -Force ChromeSetup.exe

# Download and extract JMeter
RUN powershell -Command \
    wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.zip -OutFile jmeter.zip; \
    Expand-Archive -Path jmeter.zip -DestinationPath C:\; \
    Remove-Item -Force jmeter.zip

# Set JMeter home directory
ENV JMETER_HOME="C:\\apache-jmeter-${JMETER_VERSION}"
ENV PATH="${JMETER_HOME}\\bin;${PATH}"

# Download and place ChromeDriver in C:\chromedriver
RUN powershell -Command \
    wget https://storage.googleapis.com/chrome-for-testing-public/${CHROME_DRIVER_VERSION}/win64/chromedriver-win64.zip -OutFile chromedriver.zip; \
    Expand-Archive -Path chromedriver.zip -DestinationPath C:\\chromedriver; \
    Remove-Item -Force chromedriver.zip

# Download and place Selenium JAR in JMeter lib folder
RUN powershell -Command \
    wget https://github.com/SeleniumHQ/selenium/releases/download/selenium-${SELENIUM_VERSION}/selenium-java-${SELENIUM_VERSION}.zip -OutFile selenium.zip; \
    Expand-Archive -Path selenium.zip -DestinationPath C:\\selenium; \
    Move-Item -Path C:\\selenium\\*.jar -Destination "${JMETER_HOME}\\lib"; \
    Remove-Item -Force selenium.zip

# Set the working directory to JMeter
WORKDIR ${JMETER_HOME}

# Entry point to run JMeter by default
ENTRYPOINT ["jmeter.bat"]

# Optionally expose any ports if required
EXPOSE 1099
