//go:build windows

package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/dialog"
	"fyne.io/fyne/v2/widget"
)

type ADBGUI struct {
	app        fyne.App
	window     fyne.Window
	outputText *widget.Entry
	statusText *widget.Label
}

func NewADBGUI() *ADBGUI {
	a := app.NewWithID("adb.gui.tool")
	w := a.NewWindow("ADB Fastboot 安装工具 GUI")
	w.Resize(fyne.NewSize(800, 600))

	return &ADBGUI{
		app:    a,
		window: w,
	}
}

func (g *ADBGUI) buildUI() {
	// 标题
	title := widget.NewLabel("ADB Fastboot 安装工具 GUI")
	title.TextStyle = fyne.TextStyle{Bold: true}
	title.Alignment = fyne.TextAlignCenter

	// 状态显示
	g.statusText = widget.NewLabel("正在检查状态...")
	g.statusText.Alignment = fyne.TextAlignCenter

	// 输出区域
	g.outputText = widget.NewMultiLineEntry()
	g.outputText.SetPlaceHolder("命令输出将显示在这里...")
	g.outputText.Disable()

	// 按钮
	installBtn := widget.NewButton("1. 安装 ADB 和 Fastboot", func() {
		g.executeCommand("-1")
	})
	uninstallBtn := widget.NewButton("2. 卸载 ADB 和 Fastboot", func() {
		g.executeCommand("-2")
	})
	checkBtn := widget.NewButton("3. 检查安装状态", func() {
		g.executeCommand("-3")
	})
	pathBtn := widget.NewButton("4. 添加到系统 PATH", func() {
		g.executeCommand("-4")
	})
	exitBtn := widget.NewButton("5. 退出", func() {
		g.app.Quit()
	})
	refreshBtn := widget.NewButton("刷新状态", func() {
		g.checkADBStatus()
	})

	// 按钮容器
	buttons := container.NewGridWithColumns(2,
		installBtn,
		uninstallBtn,
		checkBtn,
		pathBtn,
		exitBtn,
		refreshBtn,
	)

	// 布局
	content := container.NewBorder(
		container.NewVBox(title, g.statusText, widget.NewSeparator()), // 顶部
		nil, // 底部
		nil, // 左侧
		nil, // 右侧
		container.NewVBox(
			buttons,
			widget.NewSeparator(),
			widget.NewLabel("命令输出:"),
			container.NewScroll(g.outputText),
		),
	)

	g.window.SetContent(content)
}

func (g *ADBGUI) executeCommand(choice string) {
	g.appendOutput(fmt.Sprintf("执行命令: %s\n", choice))
	g.appendOutput("正在处理，请稍候...\n\n")

	// 获取当前目录
	exePath, err := os.Executable()
	if err != nil {
		g.appendOutput(fmt.Sprintf("错误: 无法获取可执行文件路径: %v\n", err))
		return
	}

	exeDir := filepath.Dir(exePath)
	batFile := filepath.Join(exeDir, "adb.bat")

	// 检查 bat 文件是否存在
	if _, err := os.Stat(batFile); os.IsNotExist(err) {
		g.appendOutput("错误: 未找到 adb.bat 文件\n")
		g.appendOutput(fmt.Sprintf("请确保 adb.bat 文件位于: %s\n", exeDir))
		dialog.ShowError(fmt.Errorf("未找到 adb.bat 文件"), g.window)
		return
	}

	// 执行命令
	var cmd *exec.Cmd
	if runtime.GOOS == "windows" {
		cmd = exec.Command("cmd", "/c", batFile, choice)
	} else {
		g.appendOutput("错误: 此工具仅支持 Windows 系统\n")
		return
	}

	cmd.Dir = exeDir

	output, err := cmd.CombinedOutput()
	outputStr := string(output)

	if err != nil {
		g.appendOutput(fmt.Sprintf("命令执行失败: %v\n", err))
	} else {
		g.appendOutput("命令执行完成!\n")
	}

	g.appendOutput("输出内容:\n")
	g.appendOutput("========================================\n")
	g.appendOutput(outputStr)
	g.appendOutput("========================================\n\n")

	// 执行完成后检查状态
	go func() {
		g.checkADBStatus()
	}()
}

func (g *ADBGUI) checkADBStatus() {
	g.statusText.SetText("检查 ADB 状态中...")

	// 检查 ADB
	adbCmd := exec.Command("adb", "version")
	adbOutput, adbErr := adbCmd.CombinedOutput()

	// 检查 Fastboot
	fastbootCmd := exec.Command("fastboot", "--version")
	fastbootOutput, fastbootErr := fastbootCmd.CombinedOutput()

	status := []string{}

	if adbErr == nil {
		lines := strings.Split(string(adbOutput), "\n")
		if len(lines) > 0 {
			status = append(status, fmt.Sprintf("ADB: %s", strings.TrimSpace(lines[0])))
		} else {
			status = append(status, "ADB: 已安装")
		}
	} else {
		status = append(status, "ADB: 未安装")
	}

	if fastbootErr == nil {
		lines := strings.Split(string(fastbootOutput), "\n")
		if len(lines) > 0 {
			status = append(status, fmt.Sprintf("Fastboot: %s", strings.TrimSpace(lines[0])))
		} else {
			status = append(status, "Fastboot: 已安装")
		}
	} else {
		status = append(status, "Fastboot: 未安装")
	}

	// 获取当前目录
	exePath, _ := os.Executable()
	exeDir := filepath.Dir(exePath)
	batFile := filepath.Join(exeDir, "adb.bat")

	if _, err := os.Stat(batFile); err == nil {
		status = append(status, "adb.bat: 已找到")
	} else {
		status = append(status, "adb.bat: 未找到")
	}

	g.statusText.SetText(strings.Join(status, " | "))
}

func (g *ADBGUI) appendOutput(text string) {
	current := g.outputText.Text
	g.outputText.SetText(current + text)
	g.outputText.CursorRow = len(strings.Split(g.outputText.Text, "\n")) - 1
}

func (g *ADBGUI) ShowAndRun() {
	g.buildUI()
	g.checkADBStatus()
	g.window.ShowAndRun()
}

func main() {
	gui := NewADBGUI()
	gui.ShowAndRun()
}
