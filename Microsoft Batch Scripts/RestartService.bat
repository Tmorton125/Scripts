@echo off
set service_name="workfolderssvc"


GOTO :check_state


:check_state
for /F "tokens=3 delims=: " %%H in ('sc query "%service_name%" ^| findstr "        STATE"') do (
   ECHO "Checking service status"

   if "%%H" == "STOPPED" (
       GOTO :service_stopped
   )

   if "%%H" == "STARTED" (
       GOTO :service_started
   )
)
:END

:service_started
ECHO Service ["%servicename%"] is Started attempting to stop 
net stop "%service_name%"
GOTO :check_state
:END


:service_stopped
ECHO Service ["%servicename%"] is Stopped attempting to restart
net start "%service_name%"


for /F "tokens=3 delims=: " %%H in ('sc query "%service_name%" ^| findstr "        STATE"') do (
 if "%%H" == "STARTED" (
   GOTO :eof
 )

 if "%%H" == "STOPPED"(
   goto :service_stopped
 )
)
:END

:eof
ECHO Service ["%servicename%"] is now Restarted
:END