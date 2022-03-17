ping 192.168.13.13
:: Pinging 192.168.13.13 with 32 bytes of data:
:: Reply from 192.168.13.13: bytes=32 time=26ms TTL=63
::
:: Ping statistics for 192.168.13.13:
::     Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
:: Approximate round trip times in milli-seconds:
::     Minimum = 26ms, Maximum = 26ms, Average = 26ms

tracert 192.168.13.13
:: Tracing route to 192.168.13.13
:: over a maximum of 30 hops:
::
::   1    27 ms    26 ms    26 ms  192.168.14.1
::   2    26 ms    26 ms    28 ms  192.168.13.13
::
:: Trace complete.
