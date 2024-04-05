#!/usr/bin/env python3

import pexpect
from pathlib import Path
import yaml
import json

pathRepositories='../repositories/sites'
extraSshParameter = ' -i /home/r.pineda/ssh_ixiam/id_rsa '

## Read JSON file

with open('db/serverstats.json') as f:
  data = json.load(f)
  #print(data)
  # Convert data to array
  servers = data['data']
  # print(servers)
  # Define Server CLI
  serverCli = {}
  while servers:
    server = servers.pop()
    # Generate a array with this data
    serverCli[server['server']] = server

print(serverCli)

## Find all yml files recursively in directory with hidden files
ymlFiles = list(Path(pathRepositories).rglob('*.yml'))
print(ymlFiles)

## Loop through all yml files

## Get all names of the sites

namesSites = []
sitesServers = {}

for ymlFile in ymlFiles:
  #print(ymlFile)
  with open(ymlFile, 'r') as file:
    files = file.read()
    data = yaml.load(files, Loader=yaml.FullLoader)
    ## Get second part of the path
    nameSite = "@" + ymlFile.parts[3]
    namesSites.append(nameSite)
    sitesServers[nameSite] = {
      'server': data['variables']['CIVIGO_SERVER'],
      'user': data['variables']['CIVIGO_USER']
    }
    # Loop through all servers

## Allow user to select a site
print("Please select a site:")
for i in range(len(namesSites)):
  print(str(i) + " - " + namesSites[i])

siteSelected = input("Enter the number of the site you want to select: ")
print("You selected: " + namesSites[int(siteSelected)])

print(sitesServers[namesSites[int(siteSelected)]])

## Ask acction to execute
print("Please select an action:")
print("1 - Show all information of the site")
print("2 - login")
print("3 - cr")
print("4 - sql-connect")

actionSelected = input("Enter the number of the action you want to select: ")
print("You selected: " + actionSelected)

prefix = ""
sufix = ""

if actionSelected == "1":
  prefix = "sa"
elif actionSelected == "2":
  sufix = "uli"
elif actionSelected == "3":
  sufix = "cr"
elif actionSelected == "4":
  sufix = "sql-connect"

sshCommand = 'ssh ' + extraSshParameter + sitesServers[namesSites[int(siteSelected)]]['user'] + '@' + sitesServers[namesSites[int(siteSelected)]]['server'] + " drush " + prefix + namesSites[int(siteSelected)] + " " + sufix
print(sshCommand)
child = pexpect.spawn(sshCommand)
result = child.read().decode('utf-8')
print(result)
