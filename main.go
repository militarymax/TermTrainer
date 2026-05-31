package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"time"
)

// ==================== DATA STRUCTURES ====================

type Task struct {
	Meta         map[string]string
	Setup        string
	TaskText     string
	Validation   string
	Hints        []string
	Level        int
	Number       string
	Title        string
	Type         string
	Difficulty   string
	TimeLimitMin int
	FilePath     string
	LevelDir     string
	TrackDir     string
}

type TaskProgress struct {
	Completed   bool   `json:"completed"`
	HintsUsed   int    `json:"hints_used"`
	CompletedAt string `json:"completed_at"`
	Attempts    int    `json:"attempts"`
	XP          int    `json:"xp"`
}

type Progress struct {
	Tasks      map[string]*TaskProgress `json:"tasks"`
	TotalXP    int                      `json:"total_xp"`
	WizardName string                   `json:"wizard_name"`
	Rank       string                   `json:"rank"`
}

// ==================== COLORS ====================

const (
	Reset        = "\033[0m"
	Bold         = "\033[1m"
	Dim          = "\033[2m"
	Red          = "\033[31m"
	Green        = "\033[32m"
	Yellow       = "\033[33m"
	Blue         = "\033[34m"
	Magenta      = "\033[35m"
	Cyan         = "\033[36m"
	White        = "\033[37m"
	BrightRed    = "\033[91m"
	BrightGreen  = "\033[92m"
	BrightYellow = "\033[93m"
	BrightCyan   = "\033[96m"
)

func color(s, c string) string {
	return c + s + Reset
}

// ==================== TASK PARSER ====================

func parseTaskFile(path string) (*Task, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("cannot open task file: %w", err)
	}
	defer file.Close()

	task := &Task{
		Meta:     make(map[string]string),
		FilePath: path,
		LevelDir: filepath.Base(filepath.Dir(path)),
	}
	dir := filepath.Dir(path)
	task.TrackDir = filepath.Base(filepath.Dir(dir))

	var section string
	var lines []string

	readSection := func() {
		text := strings.Join(lines, "\n")
		switch section {
		case "META":
			for _, line := range lines {
				line = strings.TrimSpace(line)
				if strings.HasPrefix(line, "#") {
					line = strings.TrimPrefix(line, "#")
					line = strings.TrimSpace(line)
					if idx := strings.Index(line, ":"); idx > 0 {
						k := strings.TrimSpace(line[:idx])
						v := strings.TrimSpace(line[idx+1:])
						task.Meta[k] = v
					}
				}
			}
		case "SETUP":
			task.Setup = text
		case "TASK":
			task.TaskText = text
		case "VALIDATION":
			task.Validation = text
		case "HINTS":
			for _, line := range lines {
				line = strings.TrimSpace(line)
				if line != "" {
					task.Hints = append(task.Hints, line)
				}
			}
		}
		lines = nil
	}

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		trimmed := strings.TrimSpace(line)
		upper := strings.ToUpper(trimmed)
		if upper == "META" || upper == "SETUP" || upper == "TASK" ||
			upper == "VALIDATION" || upper == "HINTS" {
			if section != "" && lines != nil {
				readSection()
			}
			section = upper
			lines = make([]string, 0)
			continue
		}
		if section != "" {
			lines = append(lines, line)
		}
	}

	if section != "" && lines != nil {
		readSection()
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}

	task.Title = task.Meta["Title"]
	if task.Title == "" {
		task.Title = filepath.Base(path)
	}
	task.Number = task.Meta["Number"]
	if task.Number == "" {
		base := filepath.Base(path)
		ext := filepath.Ext(base)
		name := strings.TrimSuffix(base, ext)
		if idx := strings.Index(name, "_"); idx > 0 {
			task.Number = name[:idx]
		} else {
			task.Number = name
		}
	}
	if lvl, err := strconv.Atoi(task.Meta["Level"]); err == nil {
		task.Level = lvl
	}
	if t, err := strconv.Atoi(task.Meta["TimeLimitMin"]); err == nil {
		task.TimeLimitMin = t
	}
	task.Difficulty = strings.ToLower(task.Meta["Difficulty"])
	if task.Difficulty == "" {
		task.Difficulty = "medium"
	}
	task.Type = strings.ToLower(task.Meta["Type"])
	if task.Type == "" {
		task.Type = "practice"
	}
	if task.TaskText == "" {
		return nil, fmt.Errorf("task file %s: missing TASK section", path)
	}
	if task.Validation == "" {
		return nil, fmt.Errorf("task file %s: missing VALIDATION section", path)
	}
	return task, nil
}

func loadAllTasks(tasksDir string) ([]*Task, error) {
	var allTasks []*Task
	err := filepath.Walk(tasksDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}
		if !info.IsDir() && strings.HasSuffix(strings.ToLower(path), ".ex") {
			task, err := parseTaskFile(path)
			if err != nil {
				fmt.Fprintf(os.Stderr, "%sWarning: skipping %s: %v%s\n",
					Yellow, filepath.Base(path), err, Reset)
				return nil
			}
			allTasks = append(allTasks, task)
		}
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("error scanning tasks directory: %w", err)
	}
	sort.Slice(allTasks, func(i, j int) bool {
		if allTasks[i].TrackDir != allTasks[j].TrackDir {
			return allTasks[i].TrackDir < allTasks[j].TrackDir
		}
		if allTasks[i].Level != allTasks[j].Level {
			return allTasks[i].Level < allTasks[j].Level
		}
		iKey := typeSortKey(allTasks[i].Type)*1000 + mustAtoi(allTasks[i].Number)
		jKey := typeSortKey(allTasks[j].Type)*1000 + mustAtoi(allTasks[j].Number)
		return iKey < jKey
	})
	return allTasks, nil
}

func mustAtoi(s string) int {
	n, _ := strconv.Atoi(s)
	return n
}

// ==================== PROGRESS ====================

func progressKey(task *Task) string {
	return task.TrackDir + "/" + task.LevelDir + "/" + task.Number
}

func loadProgress() *Progress {
	p := &Progress{Tasks: make(map[string]*TaskProgress)}
	data, err := os.ReadFile("progress.json")
	if err != nil {
		return p
	}
	if err := json.Unmarshal(data, p); err != nil {
		return p
	}
	if p.Tasks == nil {
		p.Tasks = make(map[string]*TaskProgress)
	}
	if p.WizardName == "" {
		p.WizardName = "Ринсвинд"
	}
	if p.Rank == "" {
		p.Rank = "Студент-маг"
	}
	return p
}

func saveProgress(p *Progress) {
	data, err := json.MarshalIndent(p, "", "  ")
	if err != nil {
		return
	}
	os.WriteFile("progress.json", data, 0644)
}

func taskProgress(progress *Progress, task *Task) *TaskProgress {
	key := progressKey(task)
	if p, ok := progress.Tasks[key]; ok {
		return p
	}
	progress.Tasks[key] = &TaskProgress{}
	return progress.Tasks[key]
}

func xpForDifficulty(diff string) int {
	switch diff {
	case "easy":
		return 10
	case "medium":
		return 25
	case "hard":
		return 50
	case "expert":
		return 100
	default:
		return 15
	}
}

func rankForXP(xp int) string {
	switch {
	case xp >= 500:
		return "Архиканцлер"
	case xp >= 300:
		return "Верховный Маг"
	case xp >= 200:
		return "Старший Маг"
	case xp >= 100:
		return "Маг-практикант"
	case xp >= 30:
		return "Студент 2-го курса"
	default:
		return "Студент-маг"
	}
}

// ==================== BASH EXECUTION ====================

func runBash(script string) (string, int, error) {
	if strings.TrimSpace(script) == "" {
		return "", 0, nil
	}
	s := strings.TrimSpace(script)
	if !strings.Contains(s, "set -e") && !strings.Contains(s, "#!/bin/bash") {
		s = "set -e\n" + s
	}
	cmd := exec.Command("bash", "-c", s)
	out, err := cmd.CombinedOutput()
	output := string(out)
	exitCode := 0
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			exitCode = exitErr.ExitCode()
		} else {
			return output, 1, err
		}
	}
	return output, exitCode, nil
}

// ==================== UI HELPERS ====================

func clearScreen() {
	fmt.Print("\033[H\033[2J\033[3J")
}

func readInput() string {
	reader := bufio.NewReader(os.Stdin)
	line, _ := reader.ReadString('\n')
	return strings.TrimSpace(line)
}

func difficultyBadge(diff string) string {
	switch strings.ToLower(diff) {
	case "easy":
		return color("🟢 Просто", Green)
	case "medium":
		return color("🟡 Средне", Yellow)
	case "hard":
		return color("🔴 Сложно", Red)
	case "expert":
		return color("⚫ Безумие", White)
	default:
		return color(diff, Cyan)
	}
}

func statusIcon(p *TaskProgress) string {
	if p.Completed {
		return color("✅", Green)
	}
	return color("⬜", Dim)
}

func typeIcon(taskType string) string {
	switch taskType {
	case "theory":
		return "📜"
	case "practice":
		return "⚗️"
	case "boss":
		return "🐉"
	case "uberboss":
		return "👑"
	default:
		return "⚗️"
	}
}

func typeName(taskType string) string {
	switch taskType {
	case "theory":
		return "СВИТОК ЗНАНИЙ"
	case "practice":
		return "ЛАБОРАТОРНАЯ"
	case "boss":
		return "ЭКЗАМЕН"
	case "uberboss":
		return "ВЫЗОВ АРХИКАНЦЛЕРА"
	default:
		return strings.ToUpper(taskType)
	}
}

func typeSortKey(taskType string) int {
	switch taskType {
	case "theory":
		return 0
	case "practice":
		return 1
	case "boss":
		return 2
	case "uberboss":
		return 3
	default:
		return 1
	}
}

func padLine(text string, width int) string {
	stripped := stripAnsi(text)
	pad := width - len(stripped)
	if pad < 0 {
		pad = 0
	}
	return text + strings.Repeat(" ", pad)
}

func stripAnsi(s string) string {
	result := []rune{}
	ignore := false
	for _, r := range s {
		if r == '\033' {
			ignore = true
			continue
		}
		if ignore {
			if r == 'm' {
				ignore = false
			}
			continue
		}
		result = append(result, r)
	}
	return string(result)
}

func centerText(text string, width int) string {
	stripped := stripAnsi(text)
	padding := (width - len(stripped)) / 2
	if padding < 0 {
		padding = 0
	}
	return strings.Repeat(" ", padding) + text
}

func wrapText(text string, maxLen int) []string {
	var lines []string
	words := strings.Fields(text)
	var current string
	for _, word := range words {
		if len(current)+len(word)+1 > maxLen && current != "" {
			lines = append(lines, current)
			current = word
		} else if current == "" {
			current = word
		} else {
			current += " " + word
		}
	}
	if current != "" {
		lines = append(lines, current)
	}
	if len(lines) == 0 {
		lines = append(lines, text)
	}
	return lines
}

// ==================== DISCWORLD LORE ====================

var pratchettQuotes = []string{
	"«Магия — это не вопрос заклинаний. Это вопрос знания того, какого заклинания не надо произносить.»",
	"«Единственное, что Ринсвинд делал хорошо — это убегать. Но зато как!»",
	"«В Незримом Университете обедают в семь. Всё остальное — вторично.»",
	"«Библиотекарь говорит: Уук.»",
	"«Смерть не терпит неточности. И опозданий.»",
	"«Гравитация — это привычка, от которой трудно избавиться.»",
	"«На Плоском Мире драконы настоящие. Особенно если их покормить.»",
	"«Октаво открылось на первой странице. Там было написано: 'Не паникуй.'»",
	"«Казначей принял лягушачью таблетку и почувствовал себя лучше. Или хуже. Он уже не помнил.»",
	"«Хекс думал. Это был долгий процесс, сопровождаемый жужжанием.»",
	"«Любой достаточно развитая магия неотличима от технологии. Или наоборот.»",
	"«Важно не то, куда ты идёшь. Важно то, что ты не там, откуда ушёл.»",
	"«Университет стоял. Это было его главное достоинство.»",
	"«Маг без посоха — это просто человек в смешной шляпе.»",
	"«Первое правило Незримого Университета: не трогай вещи Библиотекаря.»",
}

func randomQuote() string {
	n := len(pratchettQuotes)
	if n == 0 {
		return ""
	}
	seed := time.Now().Unix() % int64(n)
	return pratchettQuotes[seed]
}

// ==================== MAIN MENU ====================

func beltName(level int) string {
	names := map[int]string{
		1: "📖 Первокурсник",
		2: "🎓 Практикант",
		3: "🏅 Старший курс",
	}
	if n, ok := names[level]; ok {
		return n
	}
	return fmt.Sprintf("Курс %d", level)
}

func trackName(track string) string {
	names := map[string]string{
		"cli-basics": "🏰 Основы Магии Терминала",
		"scripting":  "📜 Ритуальные Заклинания",
		"docker":     "🧪 Магические Сосуды",
		"kubectl":    "🔮 Управление Орбами",
		"terraform":  "🌍 Создание Миров",
		"git":        "⏳ Темпоральная Магия",
		"jq-yq":      "🔎 Дешифровка Свитков",
		"text-fu":    "⚗️ Алхимия Текста",
		"cicd":       "⚙️ Автоматические Чудеса",
		"netdebug":   "🌐 Магическая Связь",
	}
	if n, ok := names[track]; ok {
		return n
	}
	return track
}

func mainMenu(tasks []*Task, progress *Progress) {
	clearScreen()
	w := 72

	fmt.Println(centerText(color(Bold+"🏰 НЕЗРИМЫЙ УНИВЕРСИТЕТ ТЕРМИНАЛА 🏰", Cyan), w))
	fmt.Println(centerText(color("\"In terminale veritas\"", Dim), w))
	fmt.Println()

	rank := rankForXP(progress.TotalXP)
	fmt.Println(centerText(color(fmt.Sprintf("⚡ %s | %s | XP: %d", progress.WizardName, rank, progress.TotalXP), BrightCyan), w))
	fmt.Println()

	type levelGroup struct {
		Level int
		Tasks []*Task
	}
	type trackGroup struct {
		Track  string
		Levels []*levelGroup
	}

	trackMap := make(map[string]*trackGroup)
	var trackOrder []string

	for _, t := range tasks {
		tg, ok := trackMap[t.TrackDir]
		if !ok {
			tg = &trackGroup{Track: t.TrackDir}
			trackMap[t.TrackDir] = tg
			trackOrder = append(trackOrder, t.TrackDir)
		}
		found := false
		for _, lg := range tg.Levels {
			if lg.Level == t.Level {
				lg.Tasks = append(lg.Tasks, t)
				found = true
				break
			}
		}
		if !found {
			tg.Levels = append(tg.Levels, &levelGroup{
				Level: t.Level,
				Tasks: []*Task{t},
			})
		}
	}

	idx := 1
	for _, trackKey := range trackOrder {
		tg := trackMap[trackKey]
		header := fmt.Sprintf("  %s %s %s",
			color("━━┫", Blue), trackName(tg.Track), color("┣━━", Blue))
		fmt.Println(padLine(header, w))

		for _, lg := range tg.Levels {
			beltHeader := fmt.Sprintf("    %s %s", color("▸", Dim), beltName(lg.Level))
			fmt.Println(beltHeader)

			for _, t := range lg.Tasks {
				p := taskProgress(progress, t)
				icon := statusIcon(p)
				diff := difficultyBadge(t.Difficulty)
				hints := ""
				if p.HintsUsed > 0 {
					hints = color(fmt.Sprintf(" (подсказок: %d)", p.HintsUsed), Dim)
				}
				xpStr := ""
				if !p.Completed {
					xpStr = color(fmt.Sprintf(" +%dXP", xpForDifficulty(t.Difficulty)), Dim)
				}
				line := fmt.Sprintf("      [%d] %s %s %-28s %s%s%s",
					idx, icon, typeIcon(t.Type), t.Title, diff, hints, xpStr)
				fmt.Println(padLine(line, w))
				idx++
			}
			fmt.Println()
		}
	}

	fmt.Println(color("└"+strings.Repeat("─", w-2)+"┘", Dim))
	fmt.Println()

	quote := randomQuote()
	for _, ql := range wrapText(quote, w-8) {
		fmt.Println(centerText(color(ql, Dim), w+8))
	}
	fmt.Println()

	fmt.Println(centerText(
		color("[1-N] Квест  [P] Прогресс  [G] Инструкция  [A] Забыть всё  [Q] Выход", Yellow), w))
	fmt.Println()
}

// ==================== TASK VIEW ====================

func spawnShell(task *Task) {
	if task.Setup != "" {
		_, _, _ = runBash("rm -rf /tmp/ninja_training 2>/dev/null; true")
		out, code, err := runBash(task.Setup)
		if err != nil {
			fmt.Printf("  %s✗ Заклинание подготовки дало осечку: %s%s\n", Red, err.Error(), Reset)
		} else if code != 0 {
			fmt.Printf("  %s✗ Магический круг нестабилен (код %s)%s\n", Red, strconv.Itoa(code), Reset)
		} else {
			fmt.Printf("  %s✅ Магический круг начертан! Окружение готово.%s\n", Green, Reset)
		}
		if out != "" {
			fmt.Printf("  %s%s%s\n", Dim, out, Reset)
		}
	}
	fmt.Printf("\n  %sПризываю магический терминал...%s\n", Yellow, Reset)
	fmt.Printf("  %sРаботай в bash. Произнеси 'exit' чтобы закрыть круг.%s\n", Cyan, Reset)
	fmt.Printf("  %s> %s", Yellow, Reset)
	readInput()

	cmd := exec.Command("bash", "-i")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()

	fmt.Printf("\n  %sМагический терминал закрыт.%s\n", Green, Reset)
	fmt.Printf("  %sНажми [V] чтобы Совет Магов проверил твоё решение.%s\n", Yellow, Reset)
	readInput()
}

func taskView(task *Task, progress *Progress, allTasks []*Task, taskIdx int) {
	taskProg := taskProgress(progress, task)
	running := false
	var startTime time.Time
	taskPage := 0
	const linesPerPage = 24

	for {
		clearScreen()
		w := 72

		// Header with type badge
		typeColor := Cyan
		typeLabel := typeName(task.Type)
		switch task.Type {
		case "theory":
			typeColor = BrightCyan
		case "practice":
			typeColor = Yellow
		case "boss":
			typeColor = Magenta
		case "uberboss":
			typeColor = Red
		}

		fmt.Println(color("┌"+strings.Repeat("─", w-2)+"┐", Blue))
		header := fmt.Sprintf("  %s %s / %s — %s %s: %s",
			typeIcon(task.Type), trackName(task.TrackDir), beltName(task.Level),
			color(typeLabel, typeColor), task.Number, task.Title)
		fmt.Printf("  %s\n", centerText(header, w-4))

		metaLine := fmt.Sprintf("  %s | %s | %s попыток | +%d XP",
			difficultyBadge(task.Difficulty),
			color("⏱ "+strconv.Itoa(task.TimeLimitMin)+" мин", Dim),
			color(strconv.Itoa(taskProg.Attempts), Dim),
			xpForDifficulty(task.Difficulty))
		if taskProg.Completed {
			metaLine += " " + color("✅ СДАНО", Green)
		}
		if taskProg.HintsUsed > 0 {
			metaLine += " " + color(fmt.Sprintf("(подсказок: %d)", taskProg.HintsUsed), Yellow)
		}
		fmt.Printf("  %s\n", centerText(metaLine, w-4))

		// Uber-boss special border
		if task.Type == "uberboss" {
			fmt.Println(color("╠"+strings.Repeat("═", w-2)+"╣", Red))
		} else if task.Type == "boss" {
			fmt.Println(color("╠"+strings.Repeat("─", w-2)+"╣", Magenta))
		} else {
			fmt.Println(color("└"+strings.Repeat("─", w-2)+"┘", Blue))
		}
		fmt.Println()

		if running {
			elapsed := time.Since(startTime)
			mins := int(elapsed.Minutes())
			secs := int(elapsed.Seconds()) % 60
			timerColor := Green
			if task.TimeLimitMin > 0 && mins >= task.TimeLimitMin {
				timerColor = Red
			} else if task.TimeLimitMin > 0 && mins >= task.TimeLimitMin-2 {
				timerColor = Yellow
			}
			fmt.Println(centerText(
				color(fmt.Sprintf("⏱ Песочные часы: %02d:%02d", mins, secs), timerColor), w))
			fmt.Println()
		}

		taskLines := strings.Split(task.TaskText, "\n")

		// Section label depends on type
		sectionLabel := "ЗАДАНИЕ"
		sectionColor := Magenta
		if task.Type == "theory" {
			sectionLabel = "📜 СВИТОК ЗНАНИЙ"
			sectionColor = Cyan
		} else if task.Type == "boss" {
			sectionLabel = "🐉 ЭКЗАМЕН"
			sectionColor = Red
		} else if task.Type == "uberboss" {
			sectionLabel = "👑 ВЫЗОВ АРХИКАНЦЛЕРА"
			sectionColor = BrightRed
		}

		fmt.Println(padLine(color("  ═══════ "+sectionLabel+" ═══════", sectionColor), w))
		fmt.Println()

		totalPages := (len(taskLines) + linesPerPage - 1) / linesPerPage
		if totalPages < 1 {
			totalPages = 1
		}

		start := taskPage * linesPerPage
		end := start + linesPerPage
		if end > len(taskLines) {
			end = len(taskLines)
		}

		for _, line := range taskLines[start:end] {
			fmt.Println(padLine("    "+line, w-2))
		}
		fmt.Println()

		if totalPages > 1 {
			pageIndicator := fmt.Sprintf("📜 %s %d/%d %s",
				color("◁", Dim), taskPage+1, totalPages, color("▷", Dim))
			fmt.Println(padLine(pageIndicator, w-2))
		}
		fmt.Println(padLine(color("  ═════════════════════", sectionColor), w))
		fmt.Println()

		fmt.Println(color("  ═══════ ДЕЙСТВИЯ ═══════", Green))
		if task.Type == "theory" {
			fmt.Println("    [R] 📜 Прочитать свиток и попробовать заклинания")
		} else {
			fmt.Println("    [R] ⚗️  Открыть магический терминал (выполнить задание)")
		}
		fmt.Println("    [V] 🔮 Проверка Совета Магов (VALIDATE)")
		if taskProg.HintsUsed < len(task.Hints) {
			fmt.Println(fmt.Sprintf("    [H] 🔮 Магический шар (%d/%d)", taskProg.HintsUsed+1, len(task.Hints)))
		}
		if totalPages > 1 {
			if taskPage > 0 {
				fmt.Println("    [P] ◀ Предыдущая страница свитка")
			}
			if taskPage < totalPages-1 {
				fmt.Println("    [N] ▶ Следующая страница свитка")
			}
		}
		fmt.Println("    [M] 📋 Вернуться в Университет")
		fmt.Println("    [Q] ❌ Выход")
		fmt.Println(color("  ══════════════════════", Green))
		fmt.Println()
		fmt.Print(color("  > ", Yellow))

		input := readInput()
		switch strings.ToUpper(input) {
		case "R":
			spawnShell(task)
			running = true
			startTime = time.Now()

		case "N":
			if totalPages > 1 && taskPage < totalPages-1 {
				taskPage++
			}

		case "P":
			if totalPages > 1 && taskPage > 0 {
				taskPage--
			}

		case "V":
			taskProg.Attempts++
			saveProgress(progress)
			fmt.Println("\n  " + color("🔮 Совет Магов сверяет результаты...", Cyan))
			out, code, err := runBash(task.Validation)
			outputLines := strings.Split(strings.TrimSpace(out), "\n")
			fmt.Println()
			if err != nil {
				fmt.Println(color("  ✗ Магический сбой: "+err.Error(), Red))
			} else {
				for _, line := range outputLines {
					line = strings.TrimSpace(line)
					if line == "" {
						continue
					}
					if strings.HasPrefix(line, "✓") || strings.HasPrefix(line, "✅") ||
						strings.HasPrefix(line, "✔") || strings.HasPrefix(line, "PASS") {
						fmt.Println("    " + color(line, Green))
					} else if strings.HasPrefix(line, "✗") || strings.HasPrefix(line, "❌") ||
						strings.HasPrefix(line, "✖") || strings.HasPrefix(line, "FAIL") {
						fmt.Println("    " + color(line, Red))
					} else {
						fmt.Println("    " + line)
					}
				}
				fmt.Println()
				if code == 0 {
					xp := xpForDifficulty(task.Difficulty)
					successBox := color("╔══════════════════════════════╗", Green) +
						"\n" + color(fmt.Sprintf("║  🎉 ЗАДАНИЕ ВЫПОЛНЕНО! +%d XP 🎉║", xp), Green) +
						"\n" + color("╚══════════════════════════════╝", Green)
					if task.Type == "boss" {
						successBox = color("╔════════════════════════════════╗", Magenta) +
							"\n" + color(fmt.Sprintf("║  🐉 ЭКЗАМЕН СДАН! +%d XP 🐉      ║", xp), Magenta) +
							"\n" + color("║  Декан кивает одобрительно.     ║", Magenta) +
							"\n" + color("╚════════════════════════════════╝", Magenta)
					} else if task.Type == "uberboss" {
						successBox = color("╔══════════════════════════════════════╗", Red) +
							"\n" + color(fmt.Sprintf("║  👑 АРХИКАНЦЛЕР УДОВЛЕТВОРЁН! +%d XP 👑║", xp), Red) +
							"\n" + color("║  Ты достоин титула Верховного Мага! ║", Red) +
							"\n" + color("║  Библиотекарь говорит: «Уук!»        ║", Red) +
							"\n" + color("╚══════════════════════════════════════╝", Red)
					}
					fmt.Println(centerText(successBox, w))
					if !taskProg.Completed {
						taskProg.Completed = true
						taskProg.CompletedAt = time.Now().Format(time.RFC3339)
						taskProg.XP = xp
						progress.TotalXP += xp
						progress.Rank = rankForXP(progress.TotalXP)
						saveProgress(progress)
					}
				} else {
					failMsg := "  ❌ Есть ошибки — попробуй ещё раз!"
					if taskProg.Attempts > 3 {
						failMsg = "  ❌ Опять мимо? Ринсвинд бы уже трижды убежал."
					} else if taskProg.Attempts > 1 {
						failMsg = "  ❌ Не совсем то... Помедитируй над свитком."
					}
					fmt.Println(centerText(color(failMsg, BrightRed), w))
				}
			}
			fmt.Println()
			fmt.Println(color("  [N] Следующий квест  [M] В Университет  [Enter] Повторить", Yellow))
			postInput := readInput()
			if strings.ToUpper(postInput) == "N" && taskIdx+1 < len(allTasks) {
				nextTask := allTasks[taskIdx+1]
				taskView(nextTask, progress, allTasks, taskIdx+1)
				return
			}
			if strings.ToUpper(postInput) == "N" && taskIdx+1 >= len(allTasks) {
				fmt.Println(color("  🎉 Это был последний квест! Возвращаюсь в Университет.", Green))
				readInput()
				return
			}

		case "H":
			if taskProg.HintsUsed < len(task.Hints) {
				hint := task.Hints[taskProg.HintsUsed]
				taskProg.HintsUsed++
				saveProgress(progress)
				fmt.Println()
				fmt.Println(color("  ═══════ 🔮 МАГИЧЕСКИЙ ШАР ГОВОРИТ ═══════", Yellow))
				fmt.Println()
				for _, hl := range wrapText(hint, w-8) {
					fmt.Println("    " + color(hl, Yellow))
				}
				fmt.Println()
				fmt.Println(color("  ═════════════════════════════════════", Yellow))
				fmt.Println()
				fmt.Println(color("  Нажми Enter для продолжения...", Dim))
				readInput()
			}

		case "M":
			return
		case "Q":
			os.Exit(0)
		}
	}
}

// ==================== PROGRESS VIEW ====================

func progressView(tasks []*Task, progress *Progress) {
	clearScreen()
	w := 68

	rank := rankForXP(progress.TotalXP)
	fmt.Println(centerText(color(Bold+"📊 Журнал Мага: "+progress.WizardName, Green), w))
	fmt.Println(centerText(color("Звание: "+rank+" | XP: "+strconv.Itoa(progress.TotalXP), BrightCyan), w))
	fmt.Println()

	total := len(tasks)
	completed := 0
	totalHints := 0
	for _, t := range tasks {
		p := taskProgress(progress, t)
		if p.Completed {
			completed++
		}
		totalHints += p.HintsUsed
	}

	fmt.Println(padLine(fmt.Sprintf("  %s Всего квестов:       %d", color("📋", Cyan), total), w))
	fmt.Println(padLine(fmt.Sprintf("  %s Выполнено:           %d", color("✅", Green), completed), w))
	fmt.Println(padLine(fmt.Sprintf("  %s Осталось:            %d", color("⬜", Dim), total-completed), w))
	fmt.Println(padLine(fmt.Sprintf("  %s Подсказок шара:      %d", color("🔮", Yellow), totalHints), w))
	fmt.Println(padLine(fmt.Sprintf("  %s Магическая сила:     %d XP", color("⚡", BrightCyan), progress.TotalXP), w))
	fmt.Println()

	barWidth := 40
	filled := 0
	if total > 0 {
		filled = completed * barWidth / total
	}
	bar := "[" + strings.Repeat("█", filled) + strings.Repeat("░", barWidth-filled) + "]"
	pct := 0
	if total > 0 {
		pct = completed * 100 / total
	}
	fmt.Println(padLine(fmt.Sprintf("  %s %s", color(bar, Green), color(strconv.Itoa(pct)+"%", Cyan)), w))
	fmt.Println()

	for _, t := range tasks {
		p := taskProgress(progress, t)
		icon := statusIcon(p)
		line := fmt.Sprintf("  %s %s [%s] %-25s %s",
			icon, typeIcon(t.Type), color(t.Number, BrightCyan), t.Title, difficultyBadge(t.Difficulty))
		if p.Completed {
			done := "✅"
			if p.CompletedAt != "" {
				done = "✅ " + p.CompletedAt[:10]
			}
			line += "  " + color(done, Green)
			if p.XP > 0 {
				line += " " + color(fmt.Sprintf("+%dXP", p.XP), BrightCyan)
			}
			if p.HintsUsed > 0 {
				line += " " + color(fmt.Sprintf("(шар: %d)", p.HintsUsed), Yellow)
			}
		}
		fmt.Println(padLine(line, w))
	}

	fmt.Println()
	fmt.Println(centerText(color("[Enter] Назад в Университет", Yellow), w))
	readInput()
}

func resetProgress(tasks []*Task, progress *Progress) {
	w := 68
	fmt.Println()
	fmt.Println(centerText(color("⚠️  Стереть память о всех заклинаниях?", BrightRed), w))
	fmt.Println(centerText(color("(Декан будет недоволен.)", Dim), w))
	fmt.Print(centerText(color("  Введи OBLIVIATE для подтверждения: ", Yellow), w))
	input := readInput()
	if input == "OBLIVIATE" {
		progress.Tasks = make(map[string]*TaskProgress)
		progress.TotalXP = 0
		progress.Rank = "Студент-маг"
		saveProgress(progress)
		fmt.Println(color("  ✨ Obliviate! Вся магическая память стёрта.", Green))
		fmt.Println(color("  Библиотекарь грустно говорит: «Уук...»", Dim))
		fmt.Println()
		fmt.Println(centerText(color("[Enter] OK", Yellow), w))
		readInput()
	} else {
		fmt.Println(color("  Отмена. Память цела.", Dim))
		fmt.Println()
		fmt.Println(centerText(color("[Enter] OK", Yellow), w))
		readInput()
	}
}

// ==================== TASK FORMAT GUIDE ====================

func showGuide() {
	clearScreen()
	w := 72
	fmt.Println(color("╔══════════════════════════════════════════════════════════════╗", Cyan))
	fmt.Println(color("║          📖 КАТАЛОГ СВИТКОВ НЕЗРИМОГО УНИВЕРСИТЕТА           ║", Cyan))
	fmt.Println(color("╚══════════════════════════════════════════════════════════════╝", Cyan))
	fmt.Println()

	guide := []string{
		"Свитки хранятся в tasks/<факультет>/<курс>/:",
		"  tasks/cli-basics/level01/001_theory_nav.ex",
		"  tasks/docker/level02/003_practice_run.ex",
		"",
		"Факультеты: cli-basics, scripting, docker, kubectl, terraform,",
		"            git, jq-yq, text-fu, cicd, netdebug",
		"",
		"Курсы: level01 (Первокурсник), level02 (Практикант), level03 (Старший курс)",
		"",
		"Типы свитков (# Type):",
		"  theory    📜 Свиток Знаний — теория + показательная практика",
		"  practice  ⚗️  Лабораторная — задание для закрепления",
		"  boss      🐉 Экзамен — комбо-задание уровня",
		"  uberboss  👑 Вызов Архиканцлера — финальный вызов факультета",
		"",
		"Каждый свиток имеет секции:",
		"",
		"  META            — метаданные (# Title, # Level, # Type, # Difficulty, # TimeLimitMin)",
		"  SETUP           — подготовка магического круга (bash, по [R])",
		"  TASK            — текст свитка для студента",
		"  VALIDATION      — проверка Совета Магов (exit 0 = успех, ✓/✗ подсветка)",
		"  HINTS           — подсказки Магического Шара (по одной при нажатии [H])",
		"",
		"ПРАВИЛА:",
		"  META:           все поля опциональны, кроме Title",
		"  Difficulty:     easy, medium, hard, expert",
		"  VALIDATION:     echo '✓ ok' / echo '✗ fail' / exit 0 или exit 1",
		"  XP:             easy=10, medium=25, hard=50, expert=100",
	}

	for _, line := range guide {
		fmt.Println(padLine("  "+line, w-2))
	}

	fmt.Println()
	fmt.Println(centerText(color("[Enter] Назад", Yellow), w))
	readInput()
}

// ==================== MAIN ====================

func main() {
	tasksDir := "tasks"
	if _, err := os.Stat(tasksDir); os.IsNotExist(err) {
		fmt.Fprintf(os.Stderr,
			"%sОшибка: папка 'tasks/' не найдена.%s\n"+
				"%sДобавь .ex файлы в папку tasks/ или запусти из директории тренажёра.%s\n",
			Red, Reset, Dim, Reset)
		os.Exit(1)
	}

	tasks, err := loadAllTasks(tasksDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sОшибка загрузки свитков: %v%s\n", Red, err, Reset)
		os.Exit(1)
	}
	if len(tasks) == 0 {
		fmt.Fprintf(os.Stderr,
			"%sНе найдено ни одного свитка.%s\n"+
				"%sДобавь .ex файлы в папку tasks/%s\n",
			Red, Reset, Dim, Reset)
		os.Exit(1)
	}

	progress := loadProgress()
	taskIndex := make(map[int]*Task)
	for i, t := range tasks {
		taskIndex[i+1] = t
	}

	for {
		mainMenu(tasks, progress)
		input := readInput()

		switch strings.ToUpper(input) {
		case "Q":
			fmt.Println()
			fmt.Println(color("  Библиотекарь машет тебе рукой: «Уук!»", Dim))
			fmt.Println(color("  До встречи в Незримом Университете!", Dim))
			return
		case "P":
			progressView(tasks, progress)
		case "A":
			resetProgress(tasks, progress)
		case "G":
			showGuide()
		case "M":
			// stay
		default:
			if num, err := strconv.Atoi(input); err == nil {
				if task, ok := taskIndex[num]; ok {
					taskView(task, progress, tasks, num-1)
				} else {
					fmt.Printf(color("\n  ❌ Свиток #%d не найден в каталоге\n", Red))
					fmt.Println(color("  Нажми Enter...", Dim))
					readInput()
				}
			}
		}
	}
}
