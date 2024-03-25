
#!/usr/bin/env python3

import pexpect
from pathlib import Path
import yaml
import json

command = 'cvapi Setting.get sequential=1 return="wkhtmltopdfPath" --out=json'
commandUpdate = "cvapi Setting.create wkhtmltopdfPath=\'/usr/bin/xvfb-run -a -- /usr/local/bin/wkhtmltopdf --dpi 300\'"
valueCompare='/usr/bin/xvfb-run -a -- /usr/local/bin/wkhtmltopdf --dpi 300'
pathRepositories='../repositories/sites'
provider='symbiotic'

## Read JSON file

with open('db/servers_ixiam.json') as f:
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

for ymlFile in ymlFiles:
  #print(ymlFile)
  with open(ymlFile, 'r') as file:
    files = file.read()
    data = yaml.load(files, Loader=yaml.FullLoader)
    ## Get second part of the path
    nameSite = "@" + ymlFile.parts[3]

    # Loop through all servers
    for server in serverCli:
      if server in data['variables']['CIVIGO_SERVER'] and serverCli[server]['provider'] == provider:
        # Connect to server
        print('ssh ' + serverCli[server]['username'] + '@' + serverCli[server]['ip'] + " drush sa " + nameSite)
        child = pexpect.spawn('ssh ' + serverCli[server]['username'] + '@' + serverCli[server]['ip'] + " drush " + nameSite + " " + command)
        jsonResult = child.read().decode('utf-8')
        ## Convert to JSON
        result = json.loads(jsonResult)
        if 'error' in result:
          print('Error')
        else:
          if 'values' in result:
            print('------------')
            # The result is the type of [{'wkhtmltopdfPath': ''}]
            wkhtmltopdfPath = result['values'][0].get('wkhtmltopdfPath', '')
            print(result)
            print(wkhtmltopdfPath);
            if wkhtmltopdfPath != valueCompare:
              print('OK require update')
              print(nameSite)
              commandToExecute='ssh ' + serverCli[server]['username'] + '@' + serverCli[server]['ip'] + " drush " + nameSite + " " + '"' + commandUpdate + '"'
              print(commandToExecute)

              resultExecute = pexpect.spawn(commandToExecute)
              print(resultExecute)
            print('------------')
        # Finish temporally
