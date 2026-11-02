@echo off
setlocal
 title AI Queue Length Estimation - GitHub Upload

REM Always run Git from the folder containing this .bat file.
cd /d "%~dp0"

 echo.
 echo ================================================
 echo   AI QUEUE LENGTH ESTIMATION - GITHUB UPLOAD
 echo ================================================
 echo.

where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git was not found in PATH.
    echo Install Git for Windows, then reopen this window.
    pause
    exit /b 1
)

 echo [INFO] Project folder:
 echo %CD%
 echo.

if not exist ".git" (
    echo [INFO] Initializing Git repository...
    git init
    if errorlevel 1 goto :fail
)

 echo.
 set /p "REPO_URL=Paste your GitHub repository URL: "
if not defined REPO_URL (
    echo [ERROR] No repository URL entered.
    goto :fail
)

 echo %REPO_URL% | findstr /i /b /c:"https://github.com/" /c:"git@github.com:" >nul
if errorlevel 1 (
    echo [ERROR] Enter a GitHub URL, for example:
    echo https://github.com/USERNAME/ai-queue-length-estimation.git
    goto :fail
)

 echo.
 echo [INFO] Files that Git will track:
 git status --short
 echo.
 echo Check the list above. Make sure it contains no passwords,
 echo API keys, private files, or unwanted large files.
 set /p "CONFIRM=Continue and stage all non-ignored files? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo [CANCELLED] No files were staged or uploaded.
    pause
    exit /b 0
)

 git add -A
if errorlevel 1 goto :fail

 git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Initial project upload - AI Queue Length Estimation"
    if errorlevel 1 goto :fail
) else (
    echo [INFO] No new changes to commit.
)

 git branch -M main
if errorlevel 1 goto :fail

 git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
) else (
    git remote set-url origin "%REPO_URL%"
)
if errorlevel 1 goto :fail

 echo.
 echo [INFO] Uploading to GitHub...
 git push -u origin main
if errorlevel 1 (
    echo.
    echo [ERROR] Upload failed. Check the repository URL, GitHub sign-in,
    echo and whether the remote repository already contains unrelated commits.
    pause
    exit /b 1
)

 echo.
 echo ================================================
 echo [SUCCESS] Project uploaded to GitHub.
 echo Repository: %REPO_URL%
 echo ================================================
 pause
 exit /b 0

:fail
 echo.
 echo [ERROR] The operation stopped. Read the message above.
 pause
 exit /b 1
