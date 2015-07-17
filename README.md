RepositoryProbe [![Build Status](https://secure.travis-ci.org/exKAZUu/RepositoryProbe.png?branch=master)](http://travis-ci.org/exKAZUu/RepositoryProbe)
===============

## Overview

RepositoryProbe is a dataset creation support tool for repository mining.
It targets Maven projects on GitHub.

## Requirements
* Eclipse Xtend plugin
  1. Open Eclipse > Menu > Help > Install New Software
  1. Copy URL from the download site (http://www.eclipse.org/xtend/download.html)
* ChromeDriver
  1. Download ChromeDriver on https://code.google.com/p/chromedriver/downloads/list
  1. Deploy an executable file and set PATH environment variable for the file
  1. Paste on "Work with:" and push enter key
* SonarQube (version 4.x.x)
  1. Download SonarQube on http://www.sonarqube.org/downloads/
  1. Run StartSonar.bat
* secret.properties file
  1. Create a file with the name of "secret.properties" at the root directory ("RepositoryProbe")
  1. Write your GitHub account name and password at first and second lines, respectively

## Usage
  1. White a script in Xtend.
  1. [sample script](src/main/java/net/exkazuu/probe/MetricsCollectorUsingSonarManager.xtend)
