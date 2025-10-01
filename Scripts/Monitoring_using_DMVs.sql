-- Running requests (exclude benign system noise)
SELECT r.session_id, r.status, r.command, r.blocking_session_id,
       DB_NAME(r.database_id) AS db_name,
       r.cpu_time, r.total_elapsed_time, r.wait_type, r.wait_time, r.wait_resource,
       SUBSTRING(t.text,(r.statement_start_offset/2)+1,
         (CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(t.text)
               ELSE r.statement_end_offset END - r.statement_start_offset)/2+1) AS stmt,
       t.text AS batch_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;


-- Who's waiting on whom (quick blocking tree)
SELECT w.session_id AS waiter_sid, w.wait_type, w.resource_description,
       w.blocking_session_id AS blocker_sid,
       r.status, r.command, DB_NAME(r.database_id) AS db_name, r.cpu_time, r.total_elapsed_time
FROM sys.dm_os_waiting_tasks AS w
LEFT JOIN sys.dm_exec_requests AS r ON w.session_id = r.session_id
ORDER BY w.blocking_session_id, w.session_id;


-- Top CPU
SELECT TOP (20)
    total_cpu_time = qs.total_worker_time,
    avg_cpu_time   = qs.total_worker_time / NULLIF(qs.execution_count,0),
    qs.execution_count,
    DB_NAME(st.dbid) AS db_name,
    OBJECT_NAME(st.objectid, st.dbid) AS object_name,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        (CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
              ELSE qs.statement_end_offset END - qs.statement_start_offset)/2+1) AS stmt_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_worker_time DESC;

-- Top logical reads
SELECT TOP (20)
    qs.total_logical_reads, qs.execution_count,
    (qs.total_logical_reads/NULLIF(qs.execution_count,0)) AS avg_reads,
    DB_NAME(st.dbid) AS db_name,
    SUBSTRING(st.text,(qs.statement_start_offset/2)+1,
        (CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
              ELSE qs.statement_end_offset END - qs.statement_start_offset)/2+1) AS stmt_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_logical_reads DESC;

-- Top physical writes
SELECT TOP (20)
    qs.total_physical_reads, qs.total_physical_reads/NULLIF(qs.execution_count,0) AS avg_phys_reads,
    qs.total_logical_writes, qs.total_logical_writes/NULLIF(qs.execution_count,0) AS avg_writes,
    DB_NAME(st.dbid) AS db_name,
    SUBSTRING(st.text,(qs.statement_start_offset/2)+1,
        (CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
              ELSE qs.statement_end_offset END - qs.statement_start_offset)/2+1) AS stmt_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_logical_writes DESC;



-- Server-level waits (since last restart or last clear)
SELECT wait_type, waiting_tasks_count, wait_time_ms, signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE 'SLEEP_%' AND wait_type NOT IN ('BROKER_TASK_STOP','BROKER_TO_FLUSH','SQLTRACE_BUFFER_FLUSH','XE_TIMER_EVENT','XE_DISPATCHER_WAIT')
ORDER BY wait_time_ms DESC;


-- Per-database waits (SQL 2016 SP2+/2019+)
SELECT s.session_id,
       DB_NAME(r.database_id) AS db_name,
       sws.wait_type,
       sws.wait_time_ms
FROM sys.dm_exec_session_wait_stats AS sws
JOIN sys.dm_exec_sessions s ON s.session_id = sws.session_id
LEFT JOIN sys.dm_exec_requests r ON r.session_id = s.session_id
ORDER BY sws.wait_time_ms DESC;


-- Run in tempdb to see current usage
USE tempdb;
SELECT SUM(user_object_reserved_page_count)*8 AS KB_user,
       SUM(internal_object_reserved_page_count)*8 AS KB_internal,
       SUM(version_store_reserved_page_count)*8 AS KB_version_store,
       SUM(unallocated_extent_page_count)*8 AS KB_free
FROM sys.dm_db_file_space_usage;

-- Active memory grants (can signal spills/pressure)
SELECT *
FROM sys.dm_exec_query_memory_grants
ORDER BY requested_memory_kb DESC;


--Transaction log health (2019+ has dm_db_log_stats)
-- Per database log summary (2019+)
SELECT DB_NAME(database_id) AS db_name, * 
FROM sys.dm_db_log_stats(DB_ID());  -- Run per DB with USE <db>; then call

--File I/O hot spots
SELECT DB_NAME(vfs.database_id) AS db_name, mf.name AS file_name, mf.type_desc,
       vfs.num_of_reads, vfs.io_stall_read_ms,
       vfs.num_of_writes, vfs.io_stall_write_ms,
       (vfs.io_stall_read_ms/NULLIF(vfs.num_of_reads,0)) AS avg_read_ms,
       (vfs.io_stall_write_ms/NULLIF(vfs.num_of_writes,0)) AS avg_write_ms
FROM sys.dm_io_virtual_file_stats(NULL,NULL) AS vfs
JOIN sys.master_files AS mf
  ON mf.database_id = vfs.database_id AND mf.file_id = vfs.file_id
ORDER BY (vfs.io_stall_read_ms + vfs.io_stall_write_ms) DESC;


--Index health: usage, fragmentation, and missing indexes
-- Index usage since last restart
SELECT DB_NAME(ius.database_id) AS db_name, OBJECT_NAME(ius.object_id, ius.database_id) AS table_name,
       i.name AS index_name, i.type_desc,
       ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates
FROM sys.dm_db_index_usage_stats AS ius
JOIN sys.indexes AS i
  ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE ius.database_id = DB_ID()  -- run per DB
ORDER BY (ius.user_seeks + ius.user_scans + ius.user_lookups) DESC;

-- Fragmentation (use LIMITED for speed; sample large tables)
SELECT db_name() AS db_name, OBJECT_NAME(ips.object_id) AS table_name, i.name AS index_name,
       ips.index_type_desc, ips.avg_fragmentation_in_percent, ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count >= 1000
ORDER BY ips.avg_fragmentation_in_percent DESC;


-- Missing indexes (use with caution; validate!)
SELECT DB_NAME(mid.database_id) AS db_name, migs.user_seeks, migs.user_scans,
       'CREATE INDEX IX_' + REPLACE(REPLACE(REPLACE(mid.statement,'[',''),']',''),'.','_') + 
       '_' + CAST(migs.group_handle AS varchar(10)) + ' ON ' + mid.statement + 
       ' (' + ISNULL(mid.equality_columns,'') + 
       CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END +
       ISNULL(mid.inequality_columns,'') + ')' +
       ISNULL(' INCLUDE (' + mid.included_columns + ')','') AS create_index_suggestion
FROM sys.dm_db_missing_index_group_stats AS migs
JOIN sys.dm_db_missing_index_groups AS mig
  ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details AS mid
  ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY migs.user_seeks DESC;

--Temp/long-running transactions & blocking locks
-- Long-running transactions with session & last SQL text
;WITH tx AS (
  SELECT at.transaction_id, at.name, at.transaction_type, at.transaction_state,
         at.transaction_begin_time
  FROM sys.dm_tran_active_transactions AS at
)
SELECT
    st.session_id,
    es.login_name, es.host_name, es.program_name,
    DB_NAME(dt.database_id)                           AS db_name,
    tx.transaction_id, tx.name                        AS transaction_name,
    tx.transaction_type, tx.transaction_state,
    tx.transaction_begin_time,
    DATEDIFF(MINUTE, tx.transaction_begin_time, SYSDATETIME()) AS minutes_open,
    r.status AS request_status, r.command,
    wt.wait_type, wt.wait_duration_ms,
    txt.text AS last_sql_text
FROM tx
JOIN sys.dm_tran_session_transactions AS st
  ON st.transaction_id = tx.transaction_id
LEFT JOIN sys.dm_tran_database_transactions AS dt
  ON dt.transaction_id = tx.transaction_id
LEFT JOIN sys.dm_exec_sessions AS es
  ON es.session_id = st.session_id
LEFT JOIN sys.dm_exec_requests AS r
  ON r.session_id = st.session_id
LEFT JOIN sys.dm_os_waiting_tasks AS wt
  ON wt.session_id = st.session_id
LEFT JOIN sys.dm_exec_connections AS ec
  ON ec.session_id = st.session_id
CROSS APPLY sys.dm_exec_sql_text(COALESCE(r.sql_handle, ec.most_recent_sql_handle)) AS txt
ORDER BY tx.transaction_begin_time;


-- Sessions waiting on U locks and their blockers
SELECT r.session_id, r.status, r.command, r.wait_type, r.wait_time,
       DB_NAME(r.database_id) AS db_name, r.blocking_session_id,
       t.text AS batch_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.wait_type = 'LCK_M_U';

-- Lock detail for those waiters
SELECT tl.request_session_id, tl.resource_type, tl.resource_description,
       tl.request_mode, tl.request_status
FROM sys.dm_tran_locks AS tl
JOIN sys.dm_exec_requests AS r ON r.session_id = tl.request_session_id
WHERE r.wait_type = 'LCK_M_U'
ORDER BY tl.request_session_id;

--Backup & restore recency (ops hygiene)
-- Last backups per database
SELECT
  bs.database_name,
  backup_type =
    CASE bs.type
      WHEN 'D' THEN 'Full'
      WHEN 'I' THEN 'Differential'
      WHEN 'L' THEN 'Log'
      WHEN 'F' THEN 'File/Filegroup'
      WHEN 'G' THEN 'Diff File'
      WHEN 'P' THEN 'Partial'
      WHEN 'Q' THEN 'Diff Partial'
      ELSE bs.type
    END,
  copy_only = bs.is_copy_only,
  last_finish = MAX(bs.backup_finish_date)
FROM msdb.dbo.backupset AS bs
GROUP BY bs.database_name, bs.type, bs.is_copy_only
ORDER BY bs.database_name, last_finish DESC;


-- Last restores (useful on non-prod)
SELECT destination_database_name, MAX(restore_date) AS last_restore
FROM msdb.dbo.restorehistory
GROUP BY destination_database_name
ORDER BY destination_database_name;


--Always On AG quick view (if using AGs)
SELECT ag.name AS ag_name, ar.replica_server_name, adc.database_name,
       rs.role_desc, drs.synchronization_state_desc, drs.is_suspended, drs.database_state_desc,
       drs.log_send_queue_size, drs.redo_queue_size
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar ON ag.group_id = ar.group_id
JOIN sys.dm_hadr_availability_replica_states rs ON ar.replica_id = rs.replica_id
JOIN sys.dm_hadr_database_replica_states drs ON rs.replica_id = drs.replica_id
JOIN sys.availability_databases_cluster adc ON drs.group_id = adc.group_id AND drs.group_database_id = adc.group_database_id
ORDER BY ag.name, adc.database_name;
