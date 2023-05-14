import os
import re
import requests
from bs4 import BeautifulSoup
import sys

if len(sys.argv) != 5:
    print('usage: python td.py url domain rplaceip')
    sys.exit(1)


url = sys.argv[1]
domain = sys.argv[2]
ip = sys.argv[3]

xml_file = 'temp.xml'


# 发起 GET 请求，获取文件内容
r = requests.get(url,verify=False)
# 将文件内容写入本地文件
with open(xml_file, 'wb') as f:
    f.write(r.content)



# 解析 xml 文件
with open(xml_file, encoding='UTF-8') as f:
    soup = BeautifulSoup(f, 'html.parser')

# 获取所有的 enclosure 标签和 torrent 文件链接
torrent_urls = []
for enclosure in soup.find_all('enclosure'):
    torrent_url = enclosure.get('url')
    torrent_urls.append(torrent_url)

# 修改链接中的 domain 为 ip 并下载
for url in torrent_urls:
    modified_url = re.sub(f'https://{domain}/', f'https://{ip}/', url)
    filename = modified_url.split('/')[-1]

    if not os.path.exists(filename):
        r = requests.get(modified_url, verify=False)

        with open(filename, 'wb') as f:
            f.write(r.content)

        print(f'{filename} has been downloaded.')
    else:
        print(f'{filename} already exists.')