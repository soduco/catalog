import requests


url = 'https://catalog.geohistoricaldata.org/geonetwork/srv/api/records'

r = requests.get(url)
print(r)
