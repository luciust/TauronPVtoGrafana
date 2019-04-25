#!/usr/bin/python3
# by luciust, Łukasz Jokiel, lukasz jokiel at gmail com (c) 2019
# GPL 3.0
# The purpose of this short script is to download data from Tauron Elicznik Web Page, using firefox and pre-defined X enviroment with fixed screen of 1024x768

import pyautogui
import time

#First run
time.sleep(4)
#Target the "Logowanie" button and click, wait
pyautogui.moveTo(900, 660, duration=0.25)
pyautogui.click()
time.sleep(12)
#Very precise targeting of the "Energia oddana do sieci" checkbox, click and wait
pyautogui.moveTo(35, 725, duration=0.25)
pyautogui.click()
time.sleep(6)
#Target and click "Pobierz" button
pyautogui.moveTo(935, 530, duration=0.25)
pyautogui.click()
time.sleep(3)
#Target and confirm the "Zakres"
pyautogui.moveTo(620, 490, duration=0.25)
pyautogui.click()
time.sleep(7)
#Target and click Firefox Save button
pyautogui.moveTo(650, 510, duration=0.25)
pyautogui.click()
time.sleep(4)
#Exit firefox
pyautogui.hotkey('ctrl', 'q')

