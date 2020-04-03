#!/usr/bin/python3
# by luciust, Łukasz Jokiel, lukasz jokiel at gmail com (c) 2019
# GPL 3.0
# The purpose of this short script is to download data from Tauron Elicznik Web Page, using firefox and pre-defined X enviroment with fixed screen of 1024x768

import pyautogui
import time

#First run - wait for FF
time.sleep(4)
time.sleep(2)
pyautogui.hotkey('enter')
time.sleep(1)
pyautogui.hotkey('enter')
#Target the login fileld and click
pyautogui.moveTo(150, 678, duration=0.25)
time.sleep(1)
pyautogui.click()
#Optional - press login to activate 
time.sleep(2)
pyautogui.hotkey('enter')
time.sleep(1)
pyautogui.hotkey('enter')
time.sleep(15)
#Very precise targeting of the "Energia oddana do sieci" checkbox, click and wait
pyautogui.moveTo(35, 725, duration=0.25)
pyautogui.click()
time.sleep(30)
#Target and click "Pobierz" button
pyautogui.moveTo(935, 530, duration=0.25)
pyautogui.click()
time.sleep(5)
#Target and confirm the "Zakres"
pyautogui.moveTo(620, 490, duration=0.25)
pyautogui.click()
time.sleep(8)
#Target and click Firefox Save button
pyautogui.moveTo(680, 490, duration=0.25)
pyautogui.click()
time.sleep(6)
#Exit firefox
pyautogui.hotkey('ctrl', 'q')

