import pyautogui
import time
time.sleep(5)
for i in range(996,1000):
    pyautogui.write(f"set_property top project_tb_{i} [get_filesets sim_1]")
    time.sleep(2)
    pyautogui.press("enter")
    pyautogui.write("launch_simulation -mode post-synthesis -type functional ")
    time.sleep(1)
    pyautogui.press("enter") 
    time.sleep(15)
    #pyautogui.screenshot().save(f"C:\\Users\\glagu\\Desktop\\università\\PROGETTO RETI LOGICHE\\peponzo\\test_result\\test_result_{i}.jpeg")
