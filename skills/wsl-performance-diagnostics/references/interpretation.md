# Interpretation Reference

## Memory and pressure

Linux `free` and `/proc/meminfo` describe guest memory. Prefer these signals together:

- `MemAvailable`: estimate of memory usable without swapping. Low `MemFree` alone is not pressure.
- `AnonPages`: process-backed anonymous memory, often the clearest guest process-memory signal.
- `Cached`, `Buffers`, and `SReclaimable`: mostly reclaimable kernel and filesystem cache.
- `Shmem`: shared memory and tmpfs, which may be less readily reclaimable than file cache.
- `SwapFree` and `vmstat` `si`/`so`: swap occupancy and current swap traffic are different. Old swap can remain occupied after pressure ends.
- `/proc/pressure/memory`: time tasks stalled on memory.
- `/proc/pressure/io`: time tasks stalled on I/O. High I/O pressure can make a low-CPU machine feel frozen.

Windows `VmmemWSL` is the WSL2 utility VM, not the sum of Linux process RSS. It can include processes, page cache, slabs, page tables, shared memory, kernel memory, and virtualization overhead. A guest with high `MemAvailable` and high cache is usually not under live process-memory pressure even if Task Manager shows a large WSL footprint.

`.wslconfig` is global Windows-side configuration at `%UserProfile%\.wslconfig`. Current WSL supports memory and swap limits plus experimental `autoMemoryReclaim` modes. Treat configuration as a later optimization after identifying the workload. `autoMemoryReclaim` can return cache to Windows but does not fix process leaks. `sparseVhd` affects storage allocation, not RAM. Changes require a complete WSL restart, commonly `wsl.exe --shutdown`, which terminates all distributions and active work.

Authoritative references:

- Microsoft WSL configuration: https://learn.microsoft.com/windows/wsl/wsl-config
- Microsoft WSL version comparison: https://learn.microsoft.com/windows/wsl/compare-versions
- Microsoft WSL commands: https://learn.microsoft.com/windows/wsl/basic-commands
- `free(1)`: https://man7.org/linux/man-pages/man1/free.1.html
- `/proc/meminfo`: https://man7.org/linux/man-pages/man5/proc_meminfo.5.html

## Process states

- `R`: running or runnable.
- `S`: interruptible sleep, common for healthy idle processes.
- `D`: uninterruptible kernel sleep, commonly waiting on I/O. A signal remains pending until the kernel wait returns.
- `Z`: zombie. It consumes a PID table entry but has already exited. The parent must call `wait`, exit, or be restarted so another reaper can collect it.
- `T`: stopped or traced.

RSS is resident physical memory attributed to the process. VSZ is address space and can be huge without corresponding physical use. Shared pages make sums of RSS imperfect. Use proportional set size from `/proc/<pid>/smaps_rollup` when attribution needs more precision and the file is readable.

A process adopted by PID 1 is not automatically stale. Daemons, double-forked jobs, detached agents, and orphaned children can all have PPID 1. Correlate its command, cwd, cgroup, process group, open files, supervisor state, and lifecycle artifact.

Authoritative references:

- `ps(1)`: https://man7.org/linux/man-pages/man1/ps.1.html
- `proc_pid_stat(5)`: https://man7.org/linux/man-pages/man5/proc_pid_stat.5.html
- `signal(7)`: https://man7.org/linux/man-pages/man7/signal.7.html
- `wait(2)`: https://man7.org/linux/man-pages/man2/wait.2.html

## Cleanup ownership

Stop managed work through its manager so cleanup hooks, children, and state transitions run:

- systemd service: `systemctl stop <unit>`
- user service: `systemctl --user stop <unit>`
- container or compose project: use its stop command
- benchmark or task harness: use its cancellation interface
- interactive tmux work: identify the pane and command before interrupting it
- Pi async run: use its run control and reconcile the lifecycle artifact

Systemd normally applies service kill policy to the unit cgroup. Directly killing only `MainPID` can leave child processes behind. Conversely, signalling a shell's process group can kill unrelated jobs if the group is shared.

## Bounded investigation

Start with metadata and the top consumers. Avoid first-pass commands such as recursive `grep` over result archives, unrestricted `find`, parsing every event log, or mmap of multi-gigabyte JSONL. Narrow by timestamp, manifest, known run ID, status file, filename, or exact byte pattern first. Add a timeout and output limit to any scan whose size is not already known.

A large recursive read creates page cache and I/O pressure. The diagnostic can therefore inflate `VmmemWSL`, evict useful cache, and obscure the original symptom. Record the scan itself as a workload when this happens.
