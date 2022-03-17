:::::: captures network trace via built-in "netsh" tool

netsh trace start capture=yes tracefile=C:\MyTrace.etl maxsize=100MB
:: Trace configuration:
:: -------------------------------------------------------------------
:: Status:             Running
:: Trace File:         C:\MyTrace.etl
:: Append:             Off
:: Circular:           On
:: Max Size:           100 MB
:: Report:             Off
 
:: ...
:: time... passes by... you're reproducing the issue...
:: ...
 
netsh trace stop
:: Merging traces ... done
:: Generating data collection ... done
:: The trace file and additional troubleshooting information have been compiled as "C:\MyTrace.cab".
:: File location = C:\MyTrace.etl
:: Tracing session was successfully stopped.
