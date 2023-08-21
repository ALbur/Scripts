import os
import requests
from urllib.parse import urljoin
from lxml import html
import time
import random

class Crawler:
    def __init__(self):
        self.session = requests.Session()
        self.visited_pages = set()

    def download_page(self, url, base_url):
        page_name = url[len(base_url):].rstrip("/").replace("/", "_") + ".html"
        page_path = os.path.join(os.getcwd(), page_name)
        
        if os.path.exists(page_path):
            print("已存在页面，跳过下载：", url)
            return page_path
        try:
            response = self.session.get(url)
            response.raise_for_status()

            with open(page_path, 'wb') as f:
                f.write(response.content)

            self.visited_pages.add(url)
            print("已下载页面:", url)
            wait_time = random.randint(1, 10)
            time.sleep(wait_time)
            return page_path
        except requests.exceptions.RequestException as e:
            print("发生请求异常:", e)
        except Exception as e:
            print("发生其他异常:", e)

        return None
    
    def crawl_page(self, url, base_url):
        page_path = self.download_page(url, base_url)
        if not page_path:
            return

        local_base_url = os.path.dirname(page_path)
        
        try:
            with open(page_path, 'rb') as f:
                tree = html.fromstring(f.read())

            for link in tree.xpath('//a/@href'):
                link = urljoin(url, link)
                if '#' in link or link in self.visited_pages or not link.startswith(base_url):
                    continue
                self.visited_pages.add(link)
                self.crawl_page(link, base_url)
        except Exception as e:
            print("处理页面时发生异常:", e)
    
    def close(self):
        self.session.close()

crawler = Crawler()
try:
    start_url = ""
    base_url = ""
    crawler.crawl_page(start_url, base_url)
finally:
    crawler.close()