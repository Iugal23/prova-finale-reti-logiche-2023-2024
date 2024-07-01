import pyautogui
import time
time.sleep(5)
# apri la console di windows nella cartella del progetto e lancia il programma
# il codice usa vivado in modalità tcl per poter effettuare le simulazioni
pyautogui.write("vivado -mode tcl ")
pyautogui.press("enter")
pyautogui.write("open_project project_reti_logiche.xpr")
pyautogui.press("enter")
time.sleep(3)

for i in range(0,100):
    pyautogui.write(f"set_property top project_tb_{i} [get_filesets sim_1]")
    time.sleep(2)
    pyautogui.press("enter")
    pyautogui.write("launch_simulation -mode post-synthesis -type functional")
    time.sleep(1)
    pyautogui.press("enter") 
    time.sleep(15)
# nel file vivado.log trovi i risultati delle simulazioni