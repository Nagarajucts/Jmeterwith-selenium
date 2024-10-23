# Use a Windows base image with .NET framework for general-purpose use
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables for JMeter version
ENV JMETER_VERSION=5.6.3
ENV SELENIUM_VERSION=4.24.0
ENV CHROME_VERSION=130.0.6723.69


# Create a directory for installation files
RUN powershell -Command \
    New-Item -ItemType Directory -Path C:\Installers

# Step 1: Install Google Chrome
RUN powershell -Command \
    Invoke-WebRequest -Uri https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi -OutFile C:\Installers\chrome_installer.msi; \
    Start-Process msiexec.exe -ArgumentList '/i C:\Installers\chrome_installer.msi /quiet /norestart' -Wait


# Step 2: Download and install JMeter
RUN powershell -Command \
    Invoke-WebRequest -Uri https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${env:JMETER_VERSION}.zip -OutFile C:\Installers\jmeter.zip; \
    Expand-Archive -Path C:\Installers\jmeter.zip -DestinationPath C:\JMeter; \
    Remove-Item C:\Installers\jmeter.zip

# Set JMeter home directory
ENV JMETER_HOME C:\JMeter\apache-jmeter-${JMETER_VERSION}
ENV PATH $JMETER_HOME\bin:$PATH


# Step 3: Download ChromeDriver and place it in a folder
RUN powershell -Command \
    Invoke-WebRequest -Uri https://storage.googleapis.com/chrome-for-testing-public/${env:CHROME_VERSION}/win64/chromedriver-win64.zip -OutFile C:\Installers\chromedriver.zip; \
    Expand-Archive -Path C:\Installers\chromedriver.zip -DestinationPath C:\ChromeDriver; \
    Remove-Item C:\Installers\chromedriver.zip


# Step 4: Download Selenium JAR and place it in the JMeter lib folder
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/SeleniumHQ/selenium/releases/download/selenium-${env:SELENIUM_VERSION}/selenium-java-${env:SELENIUM_VERSION}.zip -OutFile C:\Installers\selenium.zip; \
    Expand-Archive -Path C:\Installers\selenium.zip -DestinationPath $env:JMETER_HOME\lib; \
    Remove-Item C:\Installers\selenium.zip


# Expose ports if needed for JMeter
EXPOSE 1099

# Set the default command to open JMeter
CMD ["C:\\JMeter\\apache-jmeter-${env:JMETER_VERSION}\\bin\\jmeter.bat"]
