void installUserFolders()
{
	QString userDir = QDir::homePath();
	QString gentabPath = userDir.path() + QDir::nativeSeparator() + "GenTab";
	QString audacityProjectsPath = gentabPath + QDir::nativeSeparator() + "Audacity Projects";
	QString recordedAudioFiles = gentabPath + QDir::nativeSeparator() + "Recorded Audio Files";
	QString generatedTabs = gentabPath + QDir::nativeSeparator() + "Generated Tabs";
	
	if(userPath.mkdir(gentabPath))
	{
		QDir gentabDir = QDir(gentabPath);

		gentabDir.mkdir(audacityProjectsPath);
		gentabDir.mkdir(recordedAudioFiles);
		gentabDir.mkdir(generatedTabs);
	}
}

// returns an ampty QStringList if an error occured
QStringList& readConfigFile()
{
	QString userDir = QDir::homePath();
	QStringList qslParameters();
	QString rootPath = QDir::rootPath();
	QString gentabFullPath = rootPath + QDir::nativeSeparator() 
								+ "Program Files" + QDir::nativeSeparator() 
								+ "GenTab";
	QFile configFile(gentabFullPath);
	if(!configFile.exists())
	{
		// Create default config File
		if (!configFile.open(QIODevice::ReadWrite | QIODevice::Text))
			return qslParameters; // error on opening file
	
		// Default values to write
		QString gentabPath = userDir.path() + QDir::nativeSeparator() + "GenTab";
		QString audacityProjectsPath = gentabPath + QDir::nativeSeparator() + "Audacity Projects";
		QString recordedAudioFiles = gentabPath + QDir::nativeSeparator() + "Recorded Audio Files";
		QString generatedTabs = gentabPath + QDir::nativeSeparator() + "Generated Tabs";

		QTextStream in(&configFile);
		in << audacityProjectsPath.append("\n");
		in << recordedAudioFiles.append("\n");
		in << generatedTabs.append("\n");
		
		qslParameters << audacityProjectsPath
					  << recordedAudioFiles
					  << generatedTabs;

	}else{
		if (!configFile.open(QIODevice::ReadOnly | QIODevice::Text))
			return qslParameters; // error on opening file
	}
	
	QTextStream in(&configFile);
    while (!in.atEnd()) {
        qslParameters << in.readLine(); // Read all the lines in the files (no \n)
    }
	
	return qslParameters;
}

QString getAudacityPath()
{
	QString windowsDefaultPath = "C:\Program Files (x86)\Audacity\audacity.exe";
	if(!QFile::exists(windowsDefaultPath))
	{
		// Displays a QDialog so that the user can specify its audacity location
		QMessageBox msgBox;
		msgBox.setText("This application requires the software Audacity to be installed on your computer.");
		msgBox.setInformativeText("Please specify where it is located or download it from: ");
		msgBox.setStandardButtons(QMessageBox::Open);
		msgBox.setDefaultButton(QMessageBox::Open);
		int ret = msgBox.exec();
	}else{
		return windowsDefaultPath;
	}
}

