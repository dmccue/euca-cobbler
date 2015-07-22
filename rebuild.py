#!/usr/bin/python
import xmlrpclib, sys, time

apiendpoint = 'http://cobbler-0.eucalyptus-systems.com/cobbler_api'
username = ''
password = ''
systemname = ''

if sys.argv[1:]:
  username = sys.argv[1]
if sys.argv[2:]:
  password = sys.argv[2]
if sys.argv[3:]:
  systemname = sys.argv[3]

if not username or not password:
  print "Usage: rebuild.py <username> <password> <systemname>"
  sys.exit(1)

server = xmlrpclib.Server(apiendpoint)
token = server.login(username,password)

serverresult = server.find_system({"name": systemname})
if not serverresult:
  print "Error: hostid " + systemname + " not found!"
  sys.exit(1)

handle = server.get_system_handle(systemname, token)
server.modify_system(handle, "netboot_enabled", "true", token)
server.modify_system(handle, "comment", "{'Date': '170102'}\nRebuild last initiated at: " + time.strftime("%c"), token)
server.save_system(handle, token)
