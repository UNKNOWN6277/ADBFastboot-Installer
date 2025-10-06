# ADBFastboot-Installer
An installer based on online retrieval of ADB and Fastboot 
一种基于在线拉取的ADB&amp;Fastboot的安装器
<img width="802" height="632" alt="image" src="https://github.com/user-attachments/assets/f22785f2-4efc-4ec6-a146-92d1e7332782" />

为了方便使用，Release中的版本为Winrar自解压版本，以做到下载后直接就可以使用

使用Batch作为基本，Go语言写了GUI（感谢@sesmof）

在使用中必须要联网，从而实现即时从Android Developers上下载最新版本的Platform-Tools包以安装

由于本质上就是一个经过包装的、有着GUI的Bat脚本，所以在使用中会弹出cmd窗口，麻烦多多谅解，谢谢了（主播技术力很拉）

An Online-Fetch-Based ADB & Fastboot Installer

Description: An installer for ADB and Fastboot that operates by fetching the latest files online.

Release Format: For user convenience, the versions in the Releases section are packaged as WinRAR self-extracting archives. This allows the tool to be used immediately after download without a separate extraction step.

Implementation: The core logic is implemented in Batch script, while the GUI is written in Go (Credits: @sesmof).

Network Requirement: The tool requires an active internet connection during use. This is essential to fetch and install the latest version of the platform-tools package directly from the Android Developers website.

Since this tool is, at its core, just a Batch script with a GUI wrapper, the command prompt (cmd) window will pop up during use. We sincerely apologize for this minor annoyance and thank you for your understanding! (My technical skills are a bit limited, I know :C

オンライン取得方式の ADB & Fastboot インストーラー

説明: 最新ファイルをオンラインで取得することで動作する、ADBおよびFastboot用のインストーラー。

リリース形式: ユーザーの利便性のため、Releasesにあるバージョンは WinRAR 自己解凍書庫 としてパッケージされています。これにより、別途解凍ソフトを使わず、ダウンロード後すぐにツールをご利用いただけます。

実装: 基本ロジックは Batch スクリプト で実装されており、GUI は Go 言語 で書かれています (クレジット: @sesmof)。

ネットワーク要件: 本ツールは使用中にインターネット接続が必須です。これは Android Developers 公式サイト から最新版の platform-tools パッケージを取得し、インストールするために必要です。

このツールは、実質的にはGUIで包んだバッチスクリプトであるため、使用中にコマンドプロンプト（cmd）画面が表示されます。ご不便をおかけしますが、何卒ご了承いただけますと幸いです。（作者の技術力がちょっと低いです、すみません
