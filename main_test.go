package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestParseTaskFile(t *testing.T) {
	// Create a temp .ex file
	dir := t.TempDir()
	taskDir := filepath.Join(dir, "test-track", "level01")
	os.MkdirAll(taskDir, 0755)

	content := `META
# Title: Test Task
# Number: 001
# Level: 1
# Type: practice
# Difficulty: easy
# TimeLimitMin: 10

SETUP
#!/bin/bash
echo "setup"

TASK
This is a test task.

VALIDATION
#!/bin/bash
echo "✓ ok"
exit 0

HINTS
First hint
Second hint
`

	path := filepath.Join(taskDir, "001_test.ex")
	os.WriteFile(path, []byte(content), 0644)

	task, err := parseTaskFile(path)
	if err != nil {
		t.Fatalf("parseTaskFile failed: %v", err)
	}

	if task.Title != "Test Task" {
		t.Errorf("Title = %q, want %q", task.Title, "Test Task")
	}
	if task.Number != "001" {
		t.Errorf("Number = %q, want %q", task.Number, "001")
	}
	if task.Level != 1 {
		t.Errorf("Level = %d, want %d", task.Level, 1)
	}
	if task.Type != "practice" {
		t.Errorf("Type = %q, want %q", task.Type, "practice")
	}
	if task.Difficulty != "easy" {
		t.Errorf("Difficulty = %q, want %q", task.Difficulty, "easy")
	}
	if task.TimeLimitMin != 10 {
		t.Errorf("TimeLimitMin = %d, want %d", task.TimeLimitMin, 10)
	}
	if task.TrackDir != "test-track" {
		t.Errorf("TrackDir = %q, want %q", task.TrackDir, "test-track")
	}
	if task.LevelDir != "level01" {
		t.Errorf("LevelDir = %q, want %q", task.LevelDir, "level01")
	}
	if len(task.Hints) != 2 {
		t.Errorf("Hints count = %d, want %d", len(task.Hints), 2)
	}
	if task.Setup == "" {
		t.Error("Setup should not be empty")
	}
	if task.TaskText == "" {
		t.Error("TaskText should not be empty")
	}
	if task.Validation == "" {
		t.Error("Validation should not be empty")
	}
}

func TestParseTaskFileMissingValidation(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "002_missing.ex")

	content := `META
# Title: Missing Validation

TASK
Some task text.
`
	os.WriteFile(path, []byte(content), 0644)

	_, err := parseTaskFile(path)
	if err == nil {
		t.Fatal("expected error for missing VALIDATION section")
	}
}

func TestXpForDifficulty(t *testing.T) {
	tests := []struct {
		diff string
		want int
	}{
		{"easy", 10},
		{"medium", 25},
		{"hard", 50},
		{"expert", 100},
		{"unknown", 15},
	}
	for _, tt := range tests {
		got := xpForDifficulty(tt.diff)
		if got != tt.want {
			t.Errorf("xpForDifficulty(%q) = %d, want %d", tt.diff, got, tt.want)
		}
	}
}

func TestRankForXP(t *testing.T) {
	tests := []struct {
		xp   int
		want string
	}{
		{0, "Студент-маг"},
		{29, "Студент-маг"},
		{30, "Студент 2-го курса"},
		{99, "Студент 2-го курса"},
		{100, "Маг-практикант"},
		{199, "Маг-практикант"},
		{200, "Старший Маг"},
		{299, "Старший Маг"},
		{300, "Верховный Маг"},
		{499, "Верховный Маг"},
		{500, "Архиканцлер"},
		{1000, "Архиканцлер"},
	}
	for _, tt := range tests {
		got := rankForXP(tt.xp)
		if got != tt.want {
			t.Errorf("rankForXP(%d) = %q, want %q", tt.xp, got, tt.want)
		}
	}
}

func TestTrackName(t *testing.T) {
	if got := trackName("cli-basics"); got == "cli-basics" {
		t.Error("trackName should return display name for known tracks")
	}
	if got := trackName("unknown-track"); got != "unknown-track" {
		t.Errorf("trackName for unknown = %q, want %q", got, "unknown-track")
	}
}

func TestTrackDescription(t *testing.T) {
	desc := trackDescription("docker")
	if desc == "" || desc == "Магические искусства терминала" {
		t.Error("trackDescription should return specific description for docker")
	}
	unknown := trackDescription("nonexistent")
	if unknown != "Магические искусства терминала" {
		t.Errorf("trackDescription for unknown = %q, want default", unknown)
	}
}

func TestProgressBar(t *testing.T) {
	bar := progressBar(5, 10, 10)
	if bar == "" {
		t.Error("progressBar should not be empty")
	}
	bar2 := progressBar(0, 10, 10)
	if bar2 == "" {
		t.Error("progressBar with 0 completed should not be empty")
	}
}

func TestGroupByTrack(t *testing.T) {
	tasks := []*Task{
		{TrackDir: "alpha", LevelDir: "level01", Title: "A1"},
		{TrackDir: "beta", LevelDir: "level01", Title: "B1"},
		{TrackDir: "alpha", LevelDir: "level02", Title: "A2"},
	}
	groups := groupByTrack(tasks)
	if len(groups) != 2 {
		t.Fatalf("groupByTrack returned %d groups, want 2", len(groups))
	}
	if groups[0].TrackDir != "alpha" || len(groups[0].Tasks) != 2 {
		t.Errorf("first group: track=%q tasks=%d, want alpha/2", groups[0].TrackDir, len(groups[0].Tasks))
	}
	if groups[1].TrackDir != "beta" || len(groups[1].Tasks) != 1 {
		t.Errorf("second group: track=%q tasks=%d, want beta/1", groups[1].TrackDir, len(groups[1].Tasks))
	}
}

func TestTypeSortKey(t *testing.T) {
	if typeSortKey("theory") >= typeSortKey("practice") {
		t.Error("theory should sort before practice")
	}
	if typeSortKey("boss") <= typeSortKey("practice") {
		t.Error("boss should sort after practice")
	}
}

func TestStripAnsi(t *testing.T) {
	input := "\033[31mRed Text\033[0m"
	stripped := stripAnsi(input)
	if stripped != "Red Text" {
		t.Errorf("stripAnsi = %q, want %q", stripped, "Red Text")
	}
}
