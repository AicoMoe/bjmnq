@echo off
chcp 937 >nul
setlocal enabledelayedexpansion

echo 正在创建文件夹...
if not exist "病娇模拟器" mkdir "病娇模拟器"
if not exist "缓存" mkdir "缓存"

set "download_folder=缓存"
set "target_folder=病娇模拟器"
set "base_url=https://img.sobot.com/3a75006a27704cd0b933e0245a88e45e/chatres/3a75006a27704cd0b933e0245a88e45e/msg/20251117/5b22cfcba3aee789d63d5c1f575e046f"

set "urls[1]=c33b8eeb315e434ea9ebbdaaae6872ee.rar"
set "urls[2]=1745d0d59047406d831d76c12e1022c1.rar"
set "urls[3]=4d4728444c7644cbb55f0ed90205f85a.rar"
set "urls[4]=68b3d7ae7712408c9e1a58f5d9e3090b.rar"
set "urls[5]=4d5b7d22d1a14c2fa2fdcc18c0eb47ae.rar"
set "urls[6]=12c8c86595304823920523fc3ea96195.rar"
set "urls[7]=00b62343e3c34a0c8daa2abb636fa851.rar"
set "urls[8]=40fad0cc45d64122ab4bfaa22a100b12.rar"
set "urls[9]=c35ae3355a4a42dca4e241df4725b4cc.rar"
set "urls[10]=7c7dc13f11d94d8b902a1f2bcfa6f896.rar"
set "urls[11]=fe9786157b264d7283c9d89192dc70e3.rar"
set "urls[12]=f17f8135892f41b99b1533842042042e.rar"
set "urls[13]=73429880cb03452c9f070a45151340ed.rar"
set "urls[14]=2055bd6eaff543178a0b0166800e2bdb.rar"
set "urls[15]=b5b3f3ddc2c74db8978809e546a713cf.rar"
set "urls[16]=83fafb886fda48d5b615fcc84aea9462.rar"
set "urls[17]=a8c964bf52814558bb7c531286420b58.rar"
set "urls[18]=243580a0ae34461b9afb751b09c3fe52.rar"
set "urls[19]=0a0fcc4327954765ab53e750014dd7f3.rar"
set "urls[20]=900c20dee08e429393dc45c2514be981.rar"
set "urls[21]=f1033f92e9f14898bbb1589457b24307.rar"
set "urls[22]=99fd3fec099f4e1f8166d3cb1b8b2a0a.rar"
set "urls[23]=6cda360e07384eda92956b4737d067b4.rar"
set "urls[24]=a608d5906e65474f8ec57efb22d835b6.rar"
set "urls[25]=6f912a401dcd4e568a399b215d91a200.rar"
set "urls[26]=c6d985778ad549b2b5ecde41c2c5fd8e.rar"
set "urls[27]=db8e6051586c49cbb0f1b92b431e8bf5.rar"
set "urls[28]=c17234ee55ca46a0939c020205da333e.rar"
set "urls[29]=d96fd671054242d79f0e7fb79692417c.rar"
set "urls[30]=19b2cd0e9c20420dab4e2a4f0e0024bb.rar"

echo 开始同时下载30个文件...
set /a success_count=0

:: 创建临时批处理文件来管理并行下载
set "temp_batch=parallel_download.bat"
echo @echo off > "%temp_batch%"

:: 为每个文件创建下载命令
for /l %%i in (1,1,30) do (
    set "filename=!urls[%%i]!"
    set "new_name=病娇模拟器."
    if %%i lss 10 (
        set "new_name=!new_name!00%%i.rar"
    ) else if %%i lss 100 (
        set "new_name=!new_name!0%%i.rar"
    ) else (
        set "new_name=!new_name!%%i.rar"
    )
    
    echo echo 启动下载进程 %%i: !new_name! >> "%temp_batch%"
    echo start /b "" powershell -Command "Invoke-WebRequest -Uri '%base_url%/!filename!' -OutFile '%download_folder%\!new_name!' -UseBasicParsing" ^>nul 2^>^&1 >> "%temp_batch%"
)

:: 执行并行下载
call "%temp_batch%"

:: 等待所有下载完成
echo 等待所有下载完成...
:wait_loop
set /a running=0
for /l %%i in (1,1,30) do (
    set "new_name=病娇模拟器."
    if %%i lss 10 (
        set "new_name=!new_name!00%%i.rar"
    ) else if %%i lss 100 (
        set "new_name=!new_name!0%%i.rar"
    ) else (
        set "new_name=!new_name!%%i.rar"
    )
    
    if not exist "%download_folder%\!new_name!" (
        set /a running+=1
    )
)

:: 显示进度
set /a completed=30-running
echo 游戏正在下载中，下载器会在当前文件夹自动完成一切操作，请挂在后台耐心等待。

:: 检查是否还有进程在运行
tasklist /fi "imagename eq powershell.exe" /fo csv | find /i "powershell.exe" >nul
if !errorlevel! equ 0 (
    timeout /t 3 >nul
    goto wait_loop
)

:: 清理临时文件
del "%temp_batch%" >nul 2>&1

:: 统计成功下载的文件数
for /l %%i in (1,1,30) do (
    set "new_name=病娇模拟器."
    if %%i lss 10 (
        set "new_name=!new_name!00%%i.rar"
    ) else if %%i lss 100 (
        set "new_name=!new_name!0%%i.rar"
    ) else (
        set "new_name=!new_name!%%i.rar"
    )
    
    if exist "%download_folder%\!new_name!" (
        set /a success_count+=1
        echo ? 下载成功: !new_name!
    ) else (
        echo ? 下载失败: !new_name!
    )
)

echo.
echo 下载完成，成功下载 !success_count!/30 个文件
echo.

if !success_count! gtr 0 (
    echo 开始解压文件到病娇模拟器文件夹...
    
    :: 修复：只解压第一个分卷，WinRAR会自动识别后续分卷
    set "first_rar=病娇模拟器.001.rar"
    if exist "%download_folder%\!first_rar!" (
        echo 正在解压分卷压缩包（只需解压第一个分卷）...
        echo 解压: !first_rar!
        "C:\Program Files\WinRAR\WinRAR.exe" x -y "%download_folder%\!first_rar!" "%target_folder%\" >nul 2>&1
        if errorlevel 1 (
            echo 使用WinRAR解压失败，尝试使用系统自带解压...
            powershell -Command "Expand-Archive -Path '%download_folder%\!first_rar!' -DestinationPath '%target_folder%' -Force" >nul 2>&1
            if errorlevel 1 (
                echo 解压失败，请检查文件是否完整或使用WinRAR手动解压。
            ) else (
                echo 解压成功！
            )
        ) else (
            echo 解压成功！
        )
    ) else (
        echo 错误：第一个分卷文件不存在，无法解压
    )
) else (
    echo 没有成功下载任何文件，跳过解压步骤
)

echo.
echo 游戏下载完毕！
echo 按任意键退出...
pause >nul