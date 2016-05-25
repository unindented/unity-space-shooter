ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILDS_DIR := $(ROOT_DIR)/Builds
TEMP_DIR := $(ROOT_DIR)/Temp
LOG_FILE := $(ROOT_DIR)/unity.log

UNITY_WIN32_URL := http://netstorage.unity3d.com/unity/fdbb5133b820/Windows32EditorInstaller/UnitySetup32-5.3.4f1.exe
UNITY_WIN32_INSTALLER := $(TEMP_DIR)/UnitySetup32.exe
UNITY_WIN32_APP := $(PROGRAMFILES)/Unity/Editor/Unity.exe

UNITY_WIN64_URL := http://netstorage.unity3d.com/unity/fdbb5133b820/Windows64EditorInstaller/UnitySetup64-5.3.4f1.exe
UNITY_WIN64_INSTALLER := $(TEMP_DIR)/UnitySetup64.exe
UNITY_WIN64_APP := $(PROGRAMFILES)/Unity/Editor/Unity.exe

UNITY_OSX_URL := http://netstorage.unity3d.com/unity/fdbb5133b820/MacEditorInstaller/Unity-5.3.4f1.pkg
UNITY_OSX_INSTALLER := $(TEMP_DIR)/Unity.pkg
UNITY_OSX_APP := /Applications/Unity/Unity.app/Contents/MacOS/Unity

ifeq ($(OS),Windows_NT)
ifeq ($(PROCESSOR_ARCHITECTURE),x86)
OS_NAME := win32
UNITY_URL := $(UNITY_WIN32_URL)
UNITY_INSTALLER := $(UNITY_WIN32_INSTALLER)
UNITY_APP := $(UNITY_WIN32_APP)
else ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
OS_NAME := win64
UNITY_URL := $(UNITY_WIN64_URL)
UNITY_INSTALLER := $(UNITY_WIN64_INSTALLER)
UNITY_APP := $(UNITY_WIN64_APP)
endif
else
ifeq ($(shell uname -s),Darwin)
OS_NAME := osx
UNITY_URL := $(UNITY_OSX_URL)
UNITY_INSTALLER := $(UNITY_OSX_INSTALLER)
UNITY_APP := $(UNITY_OSX_APP)
endif
endif

.PHONY: help clean favicon install_win32 install_win64 install_osx build_win32 build_win64 build_uwp build_osx build_linux build_webgl build_web cat_log

all: clean build_win32 build_win64 build_uwp build_osx build_linux build_ios build_android build_webgl

help:
	@"$(MAKE)" -pq | \
		awk -F: '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /); for (i in A) print A[i]}' | \
		sort

clean:
	rm -rf $(BUILDS_DIR) $(TEMP_DIR) $(LOG_FILE)

favicon:
	convert "Assets/Textures/Icon.png" -resize "256x256" \
		-define icon:auto-resize="256,128,96,64,48,32,16" \
		"Assets/WebGLTemplates/Custom/TemplateData/favicon.ico"

$(UNITY_INSTALLER):
	mkdir -p "$(dir $@)"
	curl -o "$@" $(UNITY_URL)

ifeq ($(OS_NAME),win32)
$(UNITY_WIN32_APP): $(UNITY_WIN32_INSTALLER)
	"$<" /S /D=/
	touch "$@"

install_win32: $(UNITY_WIN32_APP)
endif

ifeq ($(OS_NAME),win64)
$(UNITY_WIN64_APP): $(UNITY_WIN64_INSTALLER)
	"$<" /S /D=/
	touch "$@"

install_win64: $(UNITY_WIN64_APP)
endif

ifeq ($(OS_NAME),osx)
$(UNITY_OSX_APP): $(UNITY_OSX_INSTALLER)
	sudo installer -dumplog -package "$<" -target /
	touch "$@"

install_osx: $(UNITY_OSX_APP)
endif

build_win32:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformWin32Build \
		-quit

build_win64:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformWin64Build \
		-quit

build_uwp:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformUWPBuild \
		-quit

build_osx:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformOSXBuild \
		-quit

build_linux:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformLinuxBuild \
		-quit

build_ios:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformIOSBuild \
		-quit

build_android:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformAndroidBuild \
		-quit

build_webgl:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformWebGLBuild \
		-quit

build_web:
	"$(UNITY_APP)" \
		-batchmode \
		-nographics \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(ROOT_DIR)" \
		-executeMethod AutoBuilder.PerformWebBuild \
		-quit

cat_log:
	cat "$(LOG_FILE)"
