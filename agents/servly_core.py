import urllib2, urllib, socket, os, statvfs, commands, sys
# Linux / Darwin / SunOS
op_sys = os.popen('uname').readline().strip()

def iostat():
  iostat_list = os.popen("iostat -d 1 2 -x | awk '{print $4}'")
  blk_reads = 0.0
  blk_writes = 0.0
  for i in iostat_list:
    if i[0].strip() != '(' and i.strip() != 'r/s':
      try: 
        blk_reads += float(i)
      except ValueError:
        continue
  iostat_list = os.popen("iostat -d 1 2 -x | awk '{print $5}'")
  for i in iostat_list:
    if i[0].strip() != '(' and i.strip() != 'w/s':
      try: 
        blk_writes += float(i)
      except ValueError:
        continue
  

  return [blk_reads, blk_writes]

def uptime():
  return os.popen("uptime").readline()

def disk():
  global op_sys
  disk_volume_index = 1
  if op_sys == "Darwin":
    disk_list = os.popen("df -h | grep -v sshfs | awk {'print $1 \" | \" $NF'}")
    disk_volume_index = 0
  else:
    disk_list = os.popen("df -h -x nfs | grep -v sshfs | awk {'print $1 \" | \" $NF'}")

  disk_free = 0
  disk_size = 0
  disk_used = 0

  for d in disk_list:
    dd = d.split('\n')[0]
    if dd.split('|')[1] != " on":
      try:
        disk = os.statvfs(dd.split('|')[disk_volume_index].strip())
        #print dd.split('|')[1].strip()
        # bytes
        disk_free += (disk.f_bavail * disk.f_frsize)
        disk_size += (disk.f_blocks * disk.f_frsize)
        disk_used += (disk.f_blocks * disk.f_frsize) - (disk.f_bavail * disk.f_frsize)
      except OSError:
        print "\tSkipping disk: " + dd.split('|')[disk_volume_index].strip()
  return [disk_free, disk_size, disk_used]

def release_info():
  release_info = ""
  release_info = os.popen("cat /etc/*release 2> /dev/null").readline()
  if len(release_info) == 0:
    release_info += os.popen("cat /etc/debian_version 2> /dev/null").readline()
  return release_info

def kernel():
  return os.popen("uname -a").readline()

def running_procs():
  return  os.popen("ps ax | wc -l").readline()

def operating_system():
  return os.popen("uname").readline()

def connection_count():
  return int(commands.getoutput("netstat -an | grep -c ':'"))

def memory_usage():
  global op_sys
  # memory usage - EXPECTS BYTES TO BE SENT SO MAKE SURE YOU MULTIPLY BY PROP VALUE
  free_memory = 0
  used_memory = 0
  if op_sys == "Darwin":
    free = commands.getoutput("top -l 1 | head -n 7 | tail -n 1 | awk '{print $2 \" \" $4 \" \" $6 \" \" $10}'  | sed 's/M//g'").split(' ')
    used_memory = float(free[0]+free[1]+free[2]) * 1024 * 1024
    free_memory = float(free[3]) * 1024 * 1024
  else:
    free = commands.getoutput("free | grep /+ | awk '{print $3 \" \" $4}' ").split(' ')
    used_memory = float(free[0]) * 1024
    free_memory = float(free[1]) * 1024

  return [used_memory,free_memory]

def number_of_cpus():
  global op_sys
  if op_sys == "Darwin":
    return int(os.popen("system_profiler | grep 'Number Of Processors: ' | grep -o '[0-9]'").readline())
  else:
    return int(os.popen("cat /proc/cpuinfo | grep -c 'processor'").readline())

def cpu_usage():
  return 100.0 - float(os.popen("sar -u 1 1 | awk '{ print $NF }' | tail -n 1").readline())

def network_usage():
  # lets get network usage now via sar, we need to figure out which columns are what and sum them
  net = commands.getoutput("sar -n DEV 15 1").split('\n')
  # look through first line
  find_iface = net[2]
  #print find_iface
  in_bytes = 0
  out_bytes = 0
  i = 0
  in_bytes_col = 0
  out_bytes_col = 0
  for h in find_iface.split(' '): #find the position column of the if headers
      if len(h) > 0:
          if h == "Ibytes/s" or h == "rxbyt/s" or h == "rxkB/s":
             in_bytes_col = i
          if h == "Obytes/s" or h == "txbyt/s" or h == "txkB/s":
              out_bytes_col = i
          i+=1
  for c in net[3:-1]:
      this_c = c.split(' ')
      x = 0
      for col in this_c:
          if len(col) > 0 and this_c[0] != "Average:":
                          try:
                                  if x == in_bytes_col:
                                          in_bytes+=float(col)
                                  if x == out_bytes_col:
                                          out_bytes+=float(col)
                          except ValueError:
                                  pass
                          x+=1

  return [in_bytes,out_bytes]

def process_list():
  global op_sys
  if op_sys == "Darwin":
    ps_output = os.popen('ps -eo user,pid,ppid,rss,vsize,pcpu,pmem,command -O vsize')
  else:
    ps_output = os.popen('ps -eo user,pid,ppid,rss,vsize,pcpu,pmem,command --sort vsize')

  ps = ""
  for x in ps_output:
	ps += x
  return ps

def update_count():
  global op_sys
  if op_sys == "Darwin":
    try:
      x = int(os.popen("softwareupdate -l | grep -v Missing | grep -c '*'"))
    except TypeError:
      x = 0
    return x
  else:
    if os.popen("which aptitude").readline().strip() == "/usr/bin/aptitude":
      x = os.popen("aptitude safe-upgrade -s | grep upgraded | grep -v following").readline().split(',')[0]
      try:
        x = int(x.strip('packages upgraded').strip())
      except ValueError:
        x = 0

      return x
    else:
      return int(os.popen("yum check-update | grep -v 'Loading mirror' | grep -v 'Loaded plug' | grep -v ' \* ' | wc -l").readline())
