# Use the official Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set environment variables for JMeter and Chrome
ENV JMETER_VERSION=5.6.3
ENV CHROME_DRIVER_VERSION=130.0.6723.69
ENV CHROME_INSTALLER=chrome_installer.exe
ENV JMETER_HOME=C:\apache-jmeter-${JMETER_VERSION}

# Add JMeter and Chrome to the PATH
ENV PATH=%PATH%;%JMETER_HOME%\bin;C:\Program Files\Google\Chrome\Application

# Install required tools for downloading and extracting files
RUN powershell -Command \
    # Download the Chrome installer
    Invoke-WebRequest -Uri 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -OutFile $env:CHROME_INSTALLER; \
    # Install Chrome silently
    Start-Process -FilePath $env:CHROME_INSTALLER -ArgumentList '/silent', '/install' -NoNewWindow -Wait; \
    # Clean up the installer
    Remove-Item $env:CHROME_INSTALLER; \
    # Download JMeter
    Invoke-WebRequest -Uri "https://downloads.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.zip" -OutFile "jmeter.zip"; \
    # Expand JMeter archive
    Expand-Archive -Path "jmeter.zip" -DestinationPath "C:\"; \
    # Remove the JMeter zip file
    Remove-Item "jmeter
