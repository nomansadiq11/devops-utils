import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from datetime import datetime

pnew ,pidx = [], 1
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
print("chrome.......")
driver2 = webdriver.Chrome(options=chrome_options)
driver2.get('https://google.com/promotions')
driver2.execute_script("window.scrollTo(0, document.body.scrollHeight);")
time.sleep(5)
while True:
    #change the divs here
    promotions = driver2.find_element(By.XPATH, f'//*[@id="htmlbody"]/div[1]/div/section/section/section[2]/aside/ul/li[{pidx}]/figure/a').get_attribute('onclick').split('/')[-1]
    total = [promotions[:-1], str(datetime.now())]
    pnew.append(total)
    try:
        print("final href...")
        pidx+=1
        elem = driver2.find_element(By.XPATH, f'//*[@id="htmlbody"]/div[1]/div/section/section/section[2]/aside/ul/li[{pidx}]/figure/a')
    except:
        break
print(f"promotions_lenght: {len(pnew)}")
print(pnew)