-- Check for memory configuration changes
SELECT
    TE.name AS EventName,
    T.DatabaseName,
    T.TextData,
    T.StartTime,
    T.LoginName,
    T.HostName
FROM sys.traces AS ST
CROSS APPLY fn_trace_gettable(ST.path, DEFAULT) AS T
JOIN sys.trace_events AS TE
    ON T.EventClass = TE.trace_event_id
WHERE TE.name LIKE '%Object:Altered%' 
   OR T.TextData LIKE '%max server memory%'
ORDER BY T.StartTime DESC;
 
