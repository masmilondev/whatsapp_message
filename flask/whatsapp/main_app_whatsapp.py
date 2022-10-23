from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchElementException, ElementClickInterceptedException
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys

import time


def browser_action(browser):
    browser.get("https://web.whatsapp.com/")
    link = '/html/body/div[1]/div/div/div[3]/div/div[1]/div/div/div[2]/div/div[2]'
    WebDriverWait(browser, 10).until(EC.element_to_be_clickable(
            (By.XPATH, link)))
    return "Open success"


def send_message_test(data):
    name = data['name']
    number = data['number']
    message = data['message']

    return_values = {
        "name": data['name'],
        "number": data['number']
    }
    print("Success")
    return_values['status'] = "Suceess"
    return return_values


# Parameter a object of customer
def send_message(browser, data):
    name = data['name']
    number = data['number']
    message = data['message']

    return_values = {
        "name": data['name'],
        "number": data['number']
    }

    print(number)
    print(name)
    print(message)

    group_name = "Whatsapp numbers"
    link = '/html/body/div[1]/div/div/div[3]/div/div[1]/div/div/div[2]/div/div[2]'
    search_box = browser.find_element(By.XPATH, link)
    time.sleep(1)
    search_box.clear()
    # time.sleep(2)
    search_box.send_keys(group_name)
    time.sleep(1)

    print("start")

    group_message = "wa.me/" + number
    try:
        # Find Group name
        group_link = browser.find_element(By.XPATH, '//span[@title="{}"]'.format(group_name))
        time.sleep(.5)
        group_link.click()

        # Send number on group
        time.sleep(1)
        print("0")
        message_box = browser.find_element(By.XPATH, '/html/body/div[1]/div/div/div[4]/div/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div[1]')
        # message_box = browser.find_element(By.XPATH, '/html/body/div[1]/div/div/div[4]/div/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div/p')
        # message_box.click()
        # message_box.send_keys(Keys.HOME)
        print("1")
        print(message_box)
        print(group_message)
        # '<p class="selectable-text copyable-text" dir="ltr"><span class="selectable-text copyable-text" data-lexical-text="true">This is text</span></p>'
        # '<p class="selectable-text copyable-text" dir="ltr"><span class="selectable-text copyable-text" data-lexical-text="true">And I want to write down</span></p>'
        # '<p class="selectable-text copyable-text" dir="ltr"><span class="selectable-text copyable-text" data-lexical-text="true">This text</span></p>'
        # document.evaluate("/html/body/div[1]/div/div/div[4]/div/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
        # browser.execute_script("arguments[0].value = arguments[1]", message_box, group_message)

        for x in group_message:
            message_box.send_keys(x)
        
        # print("2")
        time.sleep(.5)
        WebDriverWait(browser, 10).until(EC.element_to_be_clickable((By.XPATH, '/html/body/div[1]/div[1]/div[1]/div[4]/div[1]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button'))).click()
        time.sleep(1)

    except NoSuchElementException as se:
        return_values['status'] = "error"
        return return_values

    except ElementClickInterceptedException as se:
        return_values['status'] = "error"
        return return_values

    except Exception as se:
        return_values['status'] = "error"
        return return_values

    try:
        print("Next try")
        user_name = browser.find_element(By.XPATH, '//a[@title="{}"]'.format("http://" + group_message))
        user_name.click()
        time.sleep(1)

        message_box = browser.find_element(By.XPATH, '/html/body/div[1]/div/div/div[4]/div/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div[1]')
        # message_box = browser.find_element(By.XPATH,
        #                                    '/html/body/div[1]/div[1]/div[1]/div[4]/div[1]/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div[2]')

        for y in message.splitlines():
            print(y)
            z = str(y.replace("[customer_name]", name))
            print(z)
            # message_box.send_keys(z)
            for a in z:
                message_box.send_keys(a)
            # for msg in z:
            #     print(msg)
            #     message_box.send_keys(msg)
            message_box.send_keys(Keys.SHIFT + Keys.ENTER)

        time.sleep(5)
        WebDriverWait(browser, 10).until(EC.element_to_be_clickable((By.XPATH,
                                                                     '/html/body/div[1]/div[1]/div[1]/div[4]/div[1]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button'))).click()

        print("Success")
        return_values['status'] = "success"
        return return_values

    except Exception as e:
        time.sleep(1)
        message_box.clear()
        WebDriverWait(browser, 10).until(EC.element_to_be_clickable(
            (By.XPATH, '/html/body/div[1]/div[1]/span[2]/div[1]/span/div[1]/div/div/div/div/div[2]/div'))).click()
        return_values['status'] = "error"
        return return_values

    return_values['status'] = "error"
    return return_values
