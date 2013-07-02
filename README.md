RepositoryProbe
===============

#Requirements
* ChromeDriver
  1. Download ChromeDriver on https://code.google.com/p/chromedriver/downloads/list
  1. Deploy an executable file and set PATH environment variable for the file
* Eclipse Juno Java Developer (or Maven 3)
* Xtend 2.4.0
  1. Open Eclipse > Menu > Help > Install New Software
  1. Copy URL from the download site (http://www.eclipse.org/xtend/download.html)
  1. Paste on "Work with:" and push enter key
* account_info file
  1. Create a file with the name of "account_info" at the root directory ("RepositoryProbe")
  1. Write your GitHub account name and password at first and second lines, respectively

#Set up project with Eclipse
  1. Open Eclipse > Menu > Import > Existing Maven Projects

#Clone repositories
  1. java src.main.java.net.exkazuu.SearchRepositoryAddressAndClone

#Get the data of test methods
  1. java src.main.java.net.exkazuu.SearchTestedRepos

#Get the data of number of testers
  1. java.net.exkazuu.getNumberOfTesters
