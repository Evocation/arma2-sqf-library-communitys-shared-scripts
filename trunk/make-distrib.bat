setlocal

set Z7=%ProgramFiles%\7-Zip\7z.exe
set Z7param= -m0=PPMd

set DistribDir=%ThisPath%..\..\distrib\SQF-Library Community`s Shared Scripts (revision %RevisionNumber%)
set DistribDir_modDir=%DistribDir%\ArmA2\@\css

:MakeDistrib

    echo ------------------------------------
    echo -- START CREATE DISTRIBUTION PACK --
    echo ------------------------------------

    rmdir /S /Q "%DistribDir%"
    del /Q "%DistribDir%"

    if exist "%DistribDir%" (
        echo Error!
        exit
    )

    mkdir "%DistribDir%\ArmA2"
    mkdir "%DistribDir_modDir%\addons"

    echo xcopy /E /Y "%TargetAddonDir%" "%DistribDir_modDir%\addons"
    xcopy /E /Y "%TargetAddonDir%" "%DistribDir_modDir%\addons"

    echo Copy mission-version folder to distrib
    mkdir "%DistribDir%\mission-version\css"
    xcopy /E /Y "%ThisPath%\mission-version\css" "%DistribDir%\mission-version\css"
    
    echo Copy doc folder to distrib
    mkdir "%DistribDir%\doc"
    xcopy /E /Y "%ThisPath%doc" "%DistribDir%\doc"

    del /Q "%DistribDir_modDir%\addons\*.log"
    rmdir /S /Q "%DistribDir_modDir%\addons\log"

    copy "mod.cpp" "%DistribDir_modDir%\mod.cpp"

    del /Q "%DistribDir%.7z"
    if exist "%DistribDir%.7z" (
        echo Error!
        exit
    )

    "%Z7%" a -r0 -t7z -mx9 %Z7param% -scsDOS -- "%DistribDir%.7z" "%DistribDir%\*"

goto :eof
