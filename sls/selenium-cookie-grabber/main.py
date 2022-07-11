from selenium import webdriver
from tempfile import mkdtemp
from selenium.webdriver.common.by import By
import os

class SeleniumCookieGrabberCommands:
    def __init__(self, driver):
        self.driver = driver
        self.valid = ['ssdc']

    def run(self, exec_script: str):
        if exec_script not in self.valid:
            return f"Valid values for exec_script: {self.valid}"

        if exec_script == 'ssdc':
            username = os.environ["SSDC_USERNAME"]
            password = os.environ["SSDC_PASSWORD"]
            self.driver.get("https://www.ssdcl.com.sg/User/Login")
            user_elem = self.driver.find_element("id", "UserName")
            pass_elem = self.driver.find_element("id", "Password")
            user_elem.send_keys(username)
            pass_elem.send_keys(password)
            self.driver.find_element("xpath", "//button[@type='submit']").click()
            return self.driver.get_cookies()

        raise ValueError("This shouldn't happen: Check that valid input list is correct.")

def handler(event=None, context=None):
    try:
        exec_script = event['exec_script']
    except KeyError:
        return 'sls invoke --function main -r ap-southeast-1 --data "{"exec_script": "[script-name]"}"'

    options = webdriver.ChromeOptions()
    options.binary_location = '/opt/chrome/chrome'
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1280x1696")
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-dev-tools")
    options.add_argument("--no-zygote")
    options.add_argument(f"--user-data-dir={mkdtemp()}")
    options.add_argument(f"--data-path={mkdtemp()}")
    options.add_argument(f"--disk-cache-dir={mkdtemp()}")
    options.add_argument("--remote-debugging-port=9222")
    chrome = webdriver.Chrome("/opt/chromedriver",
                              options=options)

    grabber = SeleniumCookieGrabberCommands(chrome)
    return str(grabber.run(exec_script))