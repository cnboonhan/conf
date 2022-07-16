from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium import webdriver
import os
import ast
import json
import code

url = input('Enter URL to visit: ')
cookies_path = input('Enter path to cookies as string [default /tmp/cookies.txt]: ') or '/tmp/cookies.txt'

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_experimental_option("detach", True)
# path to chrome driver
driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)

driver.get(url)
try:
    cookies_file = json.load(open(cookies_path, "r"))
    cookies = ast.literal_eval(cookies_file)
    for cookie in cookies:
        driver.add_cookie(cookie)
except json.decoder.JSONDecodeError:
    pass
except FileNotFoundError:
    pass

driver.refresh();

code.interact(local=locals())
