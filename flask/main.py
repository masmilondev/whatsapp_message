from flask import *
from logging import FileHandler, WARNING
from whatsapp import message
from whatsapp import main_app_whatsapp

# Selenium
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchElementException, ElementClickInterceptedException
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys

# App function
app = Flask(__name__)

fp = webdriver.FirefoxProfile('C:/Users/masmi_lhcoir7/AppData/Roaming/Mozilla/Firefox/Profiles/muwfujfx.default-release')
webdriver.FirefoxProfile('C:/Users/masmi_lhcoir7/AppData/Roaming/Mozilla/Firefox/Profiles/muwfujfx.default-release')
# fp = webdriver.FirefoxProfile('C:/Users/masmi/AppData/Roaming/Mozilla/Firefox/Profiles/hpoihc25.default-release')
# webdriver.FirefoxProfile('C:/Users/masmi/AppData/Roaming/Mozilla/Firefox/Profiles/hpoihc25.default-release')
browser = webdriver.Firefox(fp, executable_path='C:\geckodriver.exe')

browser = [False]


@app.route('/')
def home():
    return "Bismillah"


# @app.route('/open-whatsapp-test', methods=['POST'])
# def open_whatsapp_test():
#     result = main_app_whatsapp.send_message_test(request.get_json())
#     return jsonify(result)


@app.route('/send-message', methods=['POST'])
def send_message():
    data = request.get_json()
    print(data)
    result = main_app_whatsapp.send_message(browser[0], data)
    return jsonify({"status": "success!", "result": result})


@app.route('/open-browser', methods=['POST'])
def openBrowser():
    # webdriver.Edge()

    # fp = webdriver.FirefoxProfile('C:/Users/masmi/AppData/Roaming/Mozilla/Firefox/Profiles/hpoihc25.default-release')
    # webdriver.FirefoxProfile('C:/Users/masmi/AppData/Roaming/Mozilla/Firefox/Profiles/hpoihc25.default-release')
    browser[0] = webdriver.Firefox(fp, executable_path='C:\geckodriver.exe')
    # browser[0] = webdriver.Edge(executable_path='C:\msedgedriver.exe') # webdriver.Firefox(fp, executable_path='C:\geckodriver.exe')

    print(browser[0])

    return jsonify({"status": "Success!", "result": "Browser active"})


@app.route('/open-whatsapp', methods=['POST'])
def open_whatsapp():
    result = main_app_whatsapp.browser_action(browser[0])
    return jsonify({"status": result})


# Close browser function
@app.route('/close-browser', methods=['POST'])
def closeBrowser():
    print("Quit browser")
    browser[0].quit()
    return jsonify({"status": "Success!", "result": "Browser closed"})


# Close whatspp function
@app.route('/close-whatsapp', methods=['POST'])
def close_whatsapp():
    result = main_app_whatsapp.close_whatsapp(browser[0])
    return jsonify({"status": result})


app.run(port=4000)
