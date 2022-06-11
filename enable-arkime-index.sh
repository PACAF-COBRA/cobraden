#!/bin/bash

if [ ! -f elmarker.txt ]
then
  echo "Enter elastic username: "
  read elasticuser

  echo "Enter elastic password: "
  read elasticpass

  if [[ $(curl -k -u $elasticuser:$elasticpass --write-out '%{http_code}' --silent --output /dev/nul -XGET https://172.17.60.40:5601/status -I) != 200 ]];
  then
    echo "Invalid Elasticsearch username or password. Please check and retry."
    exit
  fi

  sed -i "s/elastic_user_in_vta/$elasticuser/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
  sed -i "s/elastic_password_in_vta/$elasticpass/g" ansible/roles/windows/winlogbeat/files/winlogbeat.yml
  echo "Complete." > elmarker.txt
fi

curl -u $elasticuser:$elasticpass -k -X POST "https://172.17.60.40:5601/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
     "title": "arkime*"
  }
}
'
echo ""
echo ""
echo "Action complete."
echo ""