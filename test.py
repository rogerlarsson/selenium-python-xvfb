from pyvirtualdisplay import Display
from selenium import webdriver

display = Display(visible=0, size=(1280, 2560))
display.start()

# now Firefox will run in a virtual display. 
# you will not see the browser.
browser = webdriver.Firefox()
browser.get('http://www.google.com')
print(browser.title)
browser.get_screenshot_as_file("./screenshot.png")
browser.quit()

display.stop()
