import urllib2, urllib, socket, os, statvfs, commands, sys
##### FUNCTIONS
def http():
  web = 0
  web_lsws = int(os.popen('ps ax | grep lshttpd | grep -v -c grep').readline()) # litespeed
  web_lhttpd = int(os.popen('ps ax | grep lighttpd | grep -v -c grep').readline()) # lighttpd
  web_nginx = int(os.popen('ps ax | grep nginx | grep -v -c grep').readline()) #nginx 
  web_httpd = int(os.popen('ps ax | grep "httpd" | grep -v "interworx" | grep -v "lighttpd" | grep -v -c grep').readline())
  web_apache2 = int(os.popen('ps ax | grep apache2 | grep -v -c grep').readline()) # apache2 (debian/ubuntu)
  if web_lsws > 0 or web_lhttpd > 0 or web_nginx > 0 or web_httpd > 0 or web_apache2 > 0:
	web = 1
  return web

def database():
  db = 0
  db_mysql = int(os.popen('ps ax | grep mysql | grep -v -c grep').readline()) # mysql
  if db_mysql > 0:
	db = 1
  return db

def ftp():
  ftp = 0
  ftp_proftpd = int(os.popen('ps ax | grep proftpd | grep -v -c grep').readline())
  ftp_pured = int(os.popen('ps ax | grep pure-ftpd | grep -v -c grep').readline())
  ftp_pro_ftpd = int(os.popen('ps ax | grep pro-ftpd | grep -v -c grep').readline())
  if ftp_proftpd > 0 or ftp_pured > 0 or ftp_pro_ftpd > 0:
  	ftp = 1

  return ftp

def ssh():
  ssh = 0
  sshd = int(os.popen('ps ax | grep sshd | grep -v -c grep').readline())
  if sshd > 0:
	ssh = 1
  return ssh

def nfs():
  nfs = 0
  nfsd = int(os.popen('ps ax | grep nfsd | grep -v -c grep').readline())
  if nfsd > 0:
	nfs = 1
  return nfs

def dns():
  dns = 0
  dns_tinydns = int(os.popen('ps ax | grep tinydns | grep -v -c grep').readline())
  dns_named = int(os.popen('ps ax | grep named | grep -v -c grep').readline())
  dns_named = int(os.popen('ps ax | grep named | grep -v -c grep').readline())
  dns_powerdns = int(os.popen('ps ax | grep pdns_server | grep -v -c grep').readline())
  if dns_tinydns > 0 or dns_named > 0 or dns_powerdns > 0:
	dns = 1
  return dns

def mail():
  mail = 0
  mail_qmail = int(os.popen('ps ax | grep qmail | grep -v -c grep').readline())
  mail_exim = int(os.popen('ps ax | grep exim | grep -v -c grep').readline())
  if mail_qmail > 0 or mail_exim > 0:
	mail = 1

  return mail

def snorby():
  return 1


