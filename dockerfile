# Use a base Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2019
 
# Define environment variables
ENV JMETER_VERSION 5.6.3
ENV CHROME_DRIVER_VERSION 130.0.6723.69
ENV SELENIUM_VERSION 4.24.0
 
# Metadata indicating an image maintainer
LABEL maintainer="tr@nagarajumbrdi@gmail.com"
 
# Install Chocolatey
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
 
# Install Google Chrome
RUN choco install googlechrome -y
 
# Download and install JMeter
RUN powershell -Command \
    Invoke-WebRequest -Uri https://downloads.apache.org//jmeter/binaries/apache-jmeter-$env:JMETER_VERSION.zip -OutFile jmeter.zip; \
    Expand-Archive jmeter.zip -DestinationPath C:\; \
    Remove-Item jmeter.zip
 
# Download and place ChromeDriver
RUN powershell -Command \
    Invoke-WebRequest -Uri https://storage.googleapis.com/chrome-for-testing-public/$env:CHROME_DRIVER_VERSION/win64/chromedriver-win64.zip -OutFile chromedriver.zip; \
    Expand-Archive chromedriver.zip -DestinationPath C:\chromedriver; \
    Remove-Item chromedriver.zip
 
# Download and place Selenium
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/SeleniumHQ/selenium/releases/download/selenium-$env:SELENIUM_VERSION/selenium-java-$env:SELENIUM_VERSION.zip -OutFile selenium.zip; \
    Expand-Archive selenium.zip -DestinationPath C:\apache-jmeter-$env:JMETER_VERSION\lib; \
    Remove-Item selenium.zip
 
# Set working directory
WORKDIR C:/apache-jmeter-$env:JMETER_VERSION
 
# Expose necessary ports (Optional: Expose if you need to connect to JMeter remotely)
EXPOSE 1099 50000
 
# Command to keep the container running
CMD ["cmd"]
