@ECHO OFF
REM Script fixes permissions for a private key (PEM) file used to connect to EC2 instance
icacls.exe %1 /grant:r *S-1-3-0:(F) /inheritance:r
