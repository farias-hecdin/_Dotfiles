local a=require('gitsigns.debug.log')local b={job_cnt=0}local c=vim.system or require('gitsigns.system.compat')function b.system(d,e,f)local g='run_job'if a.debug_mode then a.dprint(table.concat(d,' '))end;b.job_cnt=b.job_cnt+1;return c(d,e,f)end;return b