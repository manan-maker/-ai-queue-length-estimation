
@echo off
title Upload AI Queue Length Estimation to GitHub
setlocal

echo ==========================================
echo   AI QUEUE LENGTH ESTIMATION - GITHUB
echo ==========================================
echo.

cd /d "%~dp0"

git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed or not in PATH.
    echo Install Git from https://git-scm.com/downloads
    pause
    exit /b 1
)

if not exist ".git" git init

echo.
set /p REPO_URL="Enter your GitHub repository URL: "

if "%REPO_URL%"=="" (
    echo ERROR: Repository URL is missing.
    pause
    exit /b 1
)

echo.
echo Adding project files...
git add .

echo.
echo Creating commit...
git diff --cached --quiet
if not errorlevel 1 (
    echo No new changes to commit.
) else (
    git commit -m "Initial project upload"
    if errorlevel 1 (
        echo ERROR: Commit failed.
        pause
        exit /b 1
    )
)

git branch -M main

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
) else (
    git remote set-url origin "%REPO_URL%"
)

echo.
echo Uploading project to GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo Upload failed. Check your GitHub login and repository URL.
) else (
    echo.
    echo SUCCESS! Project uploaded.
    echo Repository: %REPO_URL%
)

pause
