local a={}a.errno={}function a.version()end;function a.version_string()end;local b={}function a.loop_close()end;function a.run(c)end;function a.loop_configure(d,...)end;function a.loop_mode()end;function a.loop_alive()end;function a.stop()end;function a.backend_fd()end;function a.backend_timeout()end;function a.now()end;function a.update_time()end;function a.walk(e)end;local f={}function a.cancel(g)end;f.cancel=a.cancel;function a.req_get_type(g)end;f.get_type=a.req_get_type;local h={}function a.is_active(i)end;h.is_active=a.is_active;function a.is_closing(i)end;h.is_closing=a.is_closing;function a.close(i,e)end;h.close=a.close;function a.ref(i)end;h.ref=a.ref;function a.unref(i)end;h.unref=a.unref;function a.has_ref(i)end;h.has_ref=a.has_ref;function a.send_buffer_size(i)end;function a.send_buffer_size(i,j)end;h.send_buffer_size=a.send_buffer_size;function a.recv_buffer_size(i)end;function a.recv_buffer_size(i,j)end;h.recv_buffer_size=a.recv_buffer_size;function a.fileno(i)end;h.fileno=a.fileno;function a.handle_get_type(i)end;h.get_type=a.handle_get_type;local k={}function a.new_timer()end;function a.timer_start(l,m,n,e)end;k.start=a.timer_start;function a.timer_stop(l)end;k.stop=a.timer_stop;function a.timer_again(l)end;k.again=a.timer_again;function a.timer_set_repeat(l,n)end;k.set_repeat=a.timer_set_repeat;function a.timer_get_repeat(l)end;k.get_repeat=a.timer_get_repeat;function a.timer_get_due_in(l)end;k.get_due_in=a.timer_get_due_in;local o={}function a.new_prepare()end;function a.prepare_start(p,e)end;o.start=a.prepare_start;function a.prepare_stop(p)end;o.stop=a.prepare_stop;local q={}function a.new_check()end;function a.check_start(r,e)end;q.start=a.check_start;function a.check_stop(r)end;q.stop=a.check_stop;local s={}function a.new_idle()end;function a.idle_start(t,e)end;s.start=a.idle_start;function a.idle_stop(t)end;s.stop=a.idle_stop;local u={}function a.new_async(e)end;function a.async_send(v,...)end;u.send=a.async_send;local w={}function a.new_poll(x)end;function a.new_socket_poll(x)end;function a.poll_start(y,z,e)end;w.start=a.poll_start;function a.poll_stop(y)end;w.stop=a.poll_stop;local A={}function a.new_signal()end;function a.signal_start(B,C,e)end;A.start=a.signal_start;function a.signal_start_oneshot(B,C,e)end;A.start_oneshot=a.signal_start_oneshot;function a.signal_stop(B)end;A.stop=a.signal_stop;local D={}function a.disable_stdio_inheritance()end;function a.spawn(E,F,G)end;function a.process_kill(H,C)end;D.kill=a.process_kill;function a.kill(I,C)end;function a.process_get_pid(H)end;D.get_pid=a.process_get_pid;local J={}function a.shutdown(K,e)end;J.shutdown=a.shutdown;function a.listen(K,L,e)end;J.listen=a.listen;function a.accept(K,M)end;J.accept=a.accept;function a.read_start(K,e)end;J.read_start=a.read_start;function a.read_stop(K)end;J.read_stop=a.read_stop;function a.write(K,N,e)end;J.write=a.write;function a.write2(K,N,O,e)end;J.write2=a.write2;function a.try_write(K,N)end;J.try_write=a.try_write;function a.try_write2(K,N,O)end;J.try_write2=a.try_write2;function a.is_readable(K)end;J.is_readable=a.is_readable;function a.is_writable(K)end;J.is_writable=a.is_writable;function a.stream_set_blocking(K,P)end;J.set_blocking=a.stream_set_blocking;function a.stream_get_write_queue_size()end;J.get_write_queue_size=a.stream_get_write_queue_size;local Q={}function a.new_tcp(R)end;function a.new_tcp()end;function a.tcp_open(S,T)end;Q.open=a.tcp_open;function a.tcp_nodelay(S,U)end;Q.nodelay=a.tcp_nodelay;function a.tcp_keepalive(S,U,V)end;Q.keepalive=a.tcp_keepalive;function a.tcp_simultaneous_accepts(S,U)end;Q.simultaneous_accepts=a.tcp_simultaneous_accepts;function a.tcp_bind(S,W,X,R)end;Q.bind=a.tcp_bind;function a.tcp_getpeername(S)end;Q.getpeername=a.tcp_getpeername;function a.tcp_getsockname(S)end;Q.getsockname=a.tcp_getsockname;function a.tcp_connect(S,W,X,e)end;Q.connect=a.tcp_connect;function a.tcp_write_queue_size(S)end;Q.write_queue_size=a.tcp_write_queue_size;function a.tcp_close_reset(S,e)end;Q.close_reset=a.tcp_close_reset;function a.socketpair(Y,Z,_,a0)end;local a1={}function a.new_pipe(a2)end;function a.pipe_open(a3,x)end;a1.open=a.pipe_open;function a.pipe_bind(a3,a4)end;a1.bind=a.pipe_bind;function a.pipe_connect(a3,a4,e)end;a1.connect=a.pipe_connect;function a.pipe_getsockname(a3)end;a1.getsockname=a.pipe_getsockname;function a.pipe_getpeername(a3)end;a1.getpeername=a.pipe_getpeername;function a.pipe_pending_instances(a3,a5)end;a1.pending_instances=a.pipe_pending_instances;function a.pipe_pending_count(a3)end;a1.pending_count=a.pipe_pending_count;function a.pipe_pending_type(a3)end;a1.pending_type=a.pipe_pending_type;function a.pipe_chmod(a3,R)end;a1.chmod=a.pipe_chmod;function a.pipe(a6,a7)end;local a8={}function a.new_tty(x,a9)end;function a.tty_set_mode(aa,c)end;a8.set_mode=a.tty_set_mode;function a.tty_reset_mode()end;function a.tty_get_winsize(aa)end;a8.get_winsize=a.tty_get_winsize;function a.tty_set_vterm_state(ab)end;function a.tty_get_vterm_state()end;local ac={}function a.new_udp(R)end;function a.new_udp()end;function a.udp_get_send_queue_size()end;ac.get_send_queue_size=a.udp_get_send_queue_size;function a.udp_get_send_queue_count()end;ac.get_send_queue_count=a.udp_get_send_queue_count;function a.udp_open(ad,x)end;ac.open=a.udp_open;function a.udp_bind(ad,W,X,R)end;ac.bind=a.udp_bind;function a.udp_getsockname(ad)end;ac.getsockname=a.udp_getsockname;function a.udp_getpeername(ad)end;ac.getpeername=a.udp_getpeername;function a.udp_set_membership(ad,ae,af,ag)end;ac.set_membership=a.udp_set_membership;function a.udp_set_source_membership(ad,ae,af,ah,ag)end;ac.set_source_membership=a.udp_set_source_membership;function a.udp_set_multicast_loop(ad,ai)end;ac.set_multicast_loop=a.udp_set_multicast_loop;function a.udp_set_multicast_ttl(ad,aj)end;ac.set_multicast_ttl=a.udp_set_multicast_ttl;function a.udp_set_multicast_interface(ad,af)end;ac.set_multicast_interface=a.udp_set_multicast_interface;function a.udp_set_broadcast(ad,ai)end;ac.set_broadcast=a.udp_set_broadcast;function a.udp_set_ttl(ad,aj)end;ac.set_ttl=a.udp_set_ttl;function a.udp_send(ad,N,W,X,e)end;ac.send=a.udp_send;function a.udp_try_send(ad,N,W,X)end;ac.try_send=a.udp_try_send;function a.udp_recv_start(ad,e)end;ac.recv_start=a.udp_recv_start;function a.udp_recv_stop(ad)end;ac.recv_stop=a.udp_recv_stop;function a.udp_connect(ad,W,X)end;ac.connect=a.udp_connect;local ak={}function a.new_fs_event()end;function a.fs_event_start(al,E,R,e)end;ak.start=a.fs_event_start;function a.fs_event_stop()end;ak.stop=a.fs_event_stop;function a.fs_event_getpath()end;ak.getpath=a.fs_event_getpath;local am={}function a.new_fs_poll()end;function a.fs_poll_start(an,E,ao,e)end;am.start=a.fs_poll_start;function a.fs_poll_stop()end;am.stop=a.fs_poll_stop;function a.fs_poll_getpath()end;am.getpath=a.fs_poll_getpath;local ap={}function a.fs_close(x,e)end;function a.fs_close(x)end;function a.fs_open(E,R,c,e)end;function a.fs_open(E,R,c)end;function a.fs_read(x,j,aq,e)end;function a.fs_read(x,j,e)end;function a.fs_read(x,j,aq)end;function a.fs_unlink(E,e)end;function a.fs_unlink(E)end;function a.fs_write(x,N,aq,e)end;function a.fs_write(x,N,e)end;function a.fs_write(x,N,aq)end;function a.fs_mkdir(E,c,e)end;function a.fs_mkdir(E,c)end;function a.fs_mkdtemp(ar,e)end;function a.fs_mkdtemp(ar)end;function a.fs_mkstemp(ar,e)end;function a.fs_mkstemp(ar)end;function a.fs_rmdir(E,e)end;function a.fs_rmdir(E)end;function a.fs_scandir(E,e)end;function a.fs_scandir(E)end;function a.fs_scandir_next(as)end;function a.fs_stat(E,e)end;function a.fs_stat(E)end;function a.fs_fstat(x,e)end;function a.fs_fstat(x)end;function a.fs_lstat(E,e)end;function a.fs_lstat(E)end;function a.fs_rename(E,at,e)end;function a.fs_rename(E,at)end;function a.fs_fsync(x,e)end;function a.fs_fsync(x)end;function a.fs_fdatasync(x,e)end;function a.fs_fdatasync(x)end;function a.fs_ftruncate(x,aq,e)end;function a.fs_ftruncate(x,aq)end;function a.fs_sendfile(au,av,aw,j,e)end;function a.fs_sendfile(au,av,aw,j)end;function a.fs_access(E,c,e)end;function a.fs_access(E,c)end;function a.fs_chmod(E,c,e)end;function a.fs_chmod(E,c)end;function a.fs_fchmod(x,c,e)end;function a.fs_fchmod(x,c)end;function a.fs_utime(E,ax,ay,e)end;function a.fs_utime(E,ax,ay)end;function a.fs_futime(x,ax,ay,e)end;function a.fs_futime(x,ax,ay)end;function a.fs_lutime(E,ax,ay,e)end;function a.fs_lutime(E,ax,ay)end;function a.fs_link(E,at,e)end;function a.fs_link(E,at)end;function a.fs_symlink(E,at,R,e)end;function a.fs_symlink(E,at,e)end;function a.fs_symlink(E,at,R)end;function a.fs_readlink(E,e)end;function a.fs_readlink(E)end;function a.fs_realpath(E,e)end;function a.fs_realpath(E)end;function a.fs_chown(E,az,aA,e)end;function a.fs_chown(E,az,aA)end;function a.fs_fchown(x,az,aA,e)end;function a.fs_fchown(x,az,aA)end;function a.fs_lchown(x,az,aA,e)end;function a.fs_lchown(x,az,aA)end;function a.fs_copyfile(E,at,R,e)end;function a.fs_copyfile(E,at,e)end;function a.fs_copyfile(E,at,R)end;function a.fs_opendir(E,aB,e)end;function a.fs_opendir(E,aB)end;function a.fs_readdir(aC,e)end;function a.fs_readdir(aC)end;ap.readdir=a.fs_readdir;function a.fs_closedir(aC,e)end;function a.fs_closedir(aC)end;ap.closedir=a.fs_closedir;function a.fs_statfs(E,e)end;function a.fs_statfs(E)end;local aD={}function a.new_work(aE,aF)end;function a.queue_work(aG,...)end;aD.queue=a.queue_work;function a.getaddrinfo(W,aH,aI,e)end;function a.getaddrinfo(W,aH,aI)end;function a.getnameinfo(aJ,e)end;function a.getnameinfo(aJ)end;local aK={}function a.new_thread(F,aL,...)end;function a.new_thread(aL,...)end;function a.thread_equal(aM,aN)end;aK.equal=a.thread_equal;function a.thread_self()end;function a.thread_join(aM)end;aK.join=a.thread_join;function a.sleep(aO)end;function a.exepath()end;function a.cwd()end;function a.chdir(aP)end;function a.get_process_title()end;function a.set_process_title(aQ)end;function a.get_total_memory()end;function a.get_free_memory()end;function a.get_constrained_memory()end;function a.resident_set_memory()end;function a.getrusage()end;function a.available_parallelism()end;function a.cpu_info()end;function a.getpid()end;function a.getuid()end;function a.getgid()end;function a.setuid(aR)end;function a.setgid(aR)end;function a.hrtime()end;function a.uptime()end;function a.print_all_handles()end;function a.print_active_handles()end;function a.guess_handle(x)end;function a.gettimeofday()end;function a.interface_addresses()end;function a.if_indextoname(aS)end;function a.if_indextoiid(aS)end;function a.loadavg()end;function a.os_uname()end;function a.os_gethostname()end;function a.os_getenv(a4,j)end;function a.os_setenv(a4,aT)end;function a.os_unsetenv(a4)end;function a.os_environ()end;function a.os_homedir()end;function a.os_tmpdir()end;function a.os_get_passwd()end;function a.os_getpid()end;function a.os_getppid()end;function a.os_getpriority(I)end;function a.os_setpriority(I,aU)end;function a.random(aV,R,e)end;function a.random(aV,R)end;function a.translate_sys_error(aW)end;function a.metrics_idle_time()end;a.constants={}return a