@ECHO OFF
REM Script restores permissions for a private key (PEM) file used to connect to EC2 instance
icacls.exe %1 /reset /T /Q /C
