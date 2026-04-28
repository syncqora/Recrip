#!/bin/bash

# Cursor Hook: After File Edit
# Automatically formats and analyzes Dart files, and runs pub get for pubspec.yaml
# Works with all AI models in Cursor (Claude, GPT-4, etc.)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log function
log() {
  echo -e "${BLUE}[Cursor Hook]${NC} $1" >&2
}

error() {
  echo -e "${RED}[Error]${NC} $1" >&2
}

success() {
  echo -e "${GREEN}[Success]${NC} $1" >&2
}

# Check if required tools are available
check_dependencies() {
  local missing_tools=()
  
  if ! command -v jq &> /dev/null; then
    missing_tools+=("jq")
  fi
  
  if ! command -v dart &> /dev/null; then
    missing_tools+=("dart")
  fi
  
  if ! command -v flutter &> /dev/null; then
    missing_tools+=("flutter")
  fi
  
  if [ ${#missing_tools[@]} -gt 0 ]; then
    error "Missing required tools: ${missing_tools[*]}"
    error "Please install the missing tools and try again."
    exit 1
  fi
}

# Read the JSON payload from stdin
INPUT=$(cat)

# Check if input is valid JSON
if ! echo "$INPUT" | jq empty 2>/dev/null; then
  log "Invalid JSON input, skipping hook"
  exit 0
fi

# Extract file path using jq
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // empty')

if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" == "null" ]; then
  log "No file path provided, skipping hook"
  exit 0
fi

# Resolve absolute path if relative
if [[ "$FILE_PATH" != /* ]]; then
  # Get project root (assume .cursor is in project root)
  PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
  FILE_PATH="$PROJECT_ROOT/$FILE_PATH"
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  log "File does not exist: $FILE_PATH (may have been deleted)"
  exit 0
fi

# Check dependencies before processing
check_dependencies

# Handle Dart files
if [[ "$FILE_PATH" == *.dart ]]; then
  log "Processing Dart file: $FILE_PATH"
  
  # Format the file
  echo -e "${YELLOW}📝 Formatting:${NC} $FILE_PATH"
  if dart format "$FILE_PATH" 2>&1; then
    success "Formatting completed"
  else
    error "Formatting failed (non-fatal, continuing...)"
  fi
  
  # Analyze the file
  if [ -f "$FILE_PATH" ]; then
    echo -e "${YELLOW}🔍 Analyzing:${NC} $FILE_PATH"
    ANALYSIS_OUTPUT=$(flutter analyze "$FILE_PATH" 2>&1 || true)
    
    if echo "$ANALYSIS_OUTPUT" | grep -qE '(error|warning|info)'; then
      echo "$ANALYSIS_OUTPUT" | grep -E '(error|warning|info)' | head -10
    else
      success "No issues found"
    fi
  fi
fi

# Handle pubspec.yaml changes
if [[ "$FILE_PATH" == "pubspec.yaml" ]] || [[ "$FILE_PATH" == "pubspec.yml" ]]; then
  log "Detected pubspec.yaml change"
  
  # Get project root directory
  PROJECT_DIR="$(dirname "$FILE_PATH")"
  
  echo -e "${YELLOW}📦 Running flutter pub get...${NC}"
  cd "$PROJECT_DIR" || exit 1
  
  if flutter pub get 2>&1 | tail -10; then
    success "Dependencies updated"
  else
    error "flutter pub get failed"
    exit 1
  fi
fi

# Handle analysis_options.yaml changes (might affect analysis)
if [[ "$FILE_PATH" == "analysis_options.yaml" ]]; then
  log "Detected analysis_options.yaml change"
  echo -e "${YELLOW}💡 Analysis options updated. Consider running 'flutter analyze' on the project.${NC}"
fi

exit 0