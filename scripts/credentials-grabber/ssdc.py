from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium import webdriver
import os

username = os.environ['USERNAME']
password = os.environ['PASSWORD']

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
# path to chrome driver
driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)

driver.get("https://www.ssdcl.com.sg/User/Login")
user_elem = driver.find_element("id", "UserName")
pass_elem = driver.find_element("id", "Password")
user_elem.send_keys(username)
pass_elem.send_keys(password)
driver.find_element("xpath", "//button[@type='submit']").click()

cookies = driver.get_cookies()

cookies_file = open("/tmp/cookies.txt", "w") 
cookies_file.write(str(cookies))
cookies_file.close()
