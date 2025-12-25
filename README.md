# Asura SPG (Secure Password Generator)



Asura SPG is a stable PowerShell password generator with a simple UI.



## Features

- G / N / C / E menu

- Rule editing via prompts

- No spaces in passwords

- Optional symbols

- No animations

- Clean and lightweight

###Name Input Note

 The name you enter is case-insensitive.
Uppercase and lowercase rules do not affect the name —
they apply only to the generated password.



## Requirements

- Windows

- PowerShell 5.1+

## License

This project is licensed under the MIT License.

## How to Run (after downloading)

If you downloaded Asura-SPG.ps1 manually,ran the command:

	powershell -ExecutionPolicy Bypass -File Asura-SPG.ps1


## One-Line Run (Windows)

Run instantly without keeping any files (downloads to temp, runs, then deletes):

```powershell

Set-ExecutionPolicy -Scope Process Bypass -Force; irm https://raw.githubusercontent.com/asura0i0/Asura-SPG/main/Asura-SPG.ps1 | iex






