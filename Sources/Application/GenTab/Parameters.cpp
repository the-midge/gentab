#include "Parameters.h"

#include <QFileDialog>
#include <QMessageBox>
#include <QStringList>

Parameters::Parameters()
{
    if(QSysInfo::windowsVersion()==QSysInfo::WV_None)
        this->_os = MacOSx;
    else
        this->_os = Windows;

    readConfigFile();
    if(_qsAudacityPath.isEmpty())
        _qsAudacityPath=getAudacityPath();
    if(_qsGuitarProPath.isEmpty())
        _qsGuitarProPath=getGuitarProPath();
    if(_qsMatlabPath.isEmpty())
        _qsMatlabPath=getMatlabPath();
}


void Parameters::installUserFolders()
{
    _qsUserPath = QDir::homePath();
    QString userGentabPath = _qsUserPath + QDir::separator() + "GenTab";
    _qsAudacityProjectsPath = userGentabPath + QDir::separator() + "Audacity Projects";
    _qsRecordedAudioFilesPath = userGentabPath + QDir::separator() + "Recorded Audio Files";
    _qsGeneratedTabsPath = userGentabPath + QDir::separator() + "Generated Tabs";

    _qsAudacityProjectsPath=QDir::toNativeSeparators(_qsAudacityProjectsPath);
    _qsRecordedAudioFilesPath=QDir::toNativeSeparators(_qsRecordedAudioFilesPath);
    _qsGeneratedTabsPath=QDir::toNativeSeparators(_qsGeneratedTabsPath);

    QDir userDir(_qsUserPath);
    if(userDir.mkdir(userGentabPath))
    {
        QDir gentabDir = QDir(userGentabPath);

        gentabDir.mkdir(_qsAudacityProjectsPath);
        gentabDir.mkdir(_qsRecordedAudioFilesPath);
        gentabDir.mkdir(_qsGeneratedTabsPath);
    }
}

void Parameters::writeConfigFile()
{
    QString configFilePath = _qsGentabPath + QDir::separator() + "config.txt";
    QFile configFile(QDir::toNativeSeparators(configFilePath));

    // Create default config File
    if (!configFile.open(QIODevice::WriteOnly | QIODevice::Text))
        return; // error on opening file

    QTextStream stream(&configFile);
    stream << _qsAudacityProjectsPath.append('\n')
           << _qsRecordedAudioFilesPath.append('\n')
           << _qsGeneratedTabsPath.append('\n')
           << _qsAudacityPath.append('\n')
           << _qsGuitarProPath.append('\n')
           << _qsMatlabPath.append('\n');

    stream.flush();
}

// returns an ampty QStringList if an error occured
void Parameters::readConfigFile()
{
    _qsUserPath = QDir::homePath();
    QString rootPath = QDir::rootPath();
    _qsGentabPath = rootPath + "Program Files" + QDir::separator()
                                + "GenTab";
    QString configFilePath = QDir::toNativeSeparators(_qsGentabPath + QDir::separator() + "config.txt");
    QFileInfo checkFile(configFilePath);
    if(!(checkFile.exists() && checkFile.isFile()))
    {
        installUserFolders();
        if(_qsAudacityPath.isEmpty())
            _qsAudacityPath=getAudacityPath();
        if(_qsGuitarProPath.isEmpty())
            _qsGuitarProPath=getGuitarProPath();
        if(_qsMatlabPath.isEmpty())
            _qsMatlabPath=getMatlabPath();
        writeConfigFile();
    }else{
        QFile configFile(configFilePath);
        if (!configFile.open(QIODevice::ReadOnly | QIODevice::Text))
            return; // error on opening file
        QTextStream in(&configFile);
        int i=0;
        while (!in.atEnd()) {
            switch(i){
            case 0:
                _qsAudacityProjectsPath = in.readLine();
                break;
            case 1:
                _qsRecordedAudioFilesPath = in.readLine();
                break;
            case 2:
                _qsGeneratedTabsPath = in.readLine();
                break;
            case 4:
                _qsAudacityPath = in.readLine();
                break;
            case 5:
                _qsGuitarProPath = in.readLine();
                break;
            case 6:
                _qsMatlabPath = in.readLine();
                break;
            }
            i++;
        }
    }
}

bool Parameters::setExportFileName(QString newExportFileName)
{
    QFile exportFile(newExportFileName);
    if(exportFile.exists())// Check if an file with the same name already exists
    {
    }else
        _qsExportFileName=newExportFileName;
        return true;
}

bool Parameters::setAudioFileName(QString newAudioFileName)
{
    QFile exportFile(newAudioFileName);
    if(exportFile.exists())
    {
        _qsAudioFileName=newAudioFileName;
        return true;
    }else
        return false;
}

QString Parameters::getAudacityPath()
{
    if(this->_os==Windows)
    {
        QString windowsDefaultPath = QDir::toNativeSeparators("C:/Program Files (x86)/Audacity/audacity.exe");
        if(!QFile::exists(windowsDefaultPath))
        {
            // Displays a QDialog so that the user can specify its audacity location
            QMessageBox msgBox;
            msgBox.setText("This application requires the software Audacity to be installed on your computer.");
            msgBox.setInformativeText("Please specify where it is located or download it from: ");
            msgBox.setStandardButtons(QMessageBox::Open);
            msgBox.setDefaultButton(QMessageBox::Open);
            msgBox.exec();
            return QFileDialog::getOpenFileName(&msgBox, QString("Locate Audacity"),
                                                QDir::rootPath(),
                                                QString("Application (*.exe)"));
        }else{
            return windowsDefaultPath;
        }
    }else
    {
        // Same thing but with Mac default path
    }
    return QString("Error");
}

QString Parameters::getGuitarProPath()
{
    if(this->_os==Windows)
    {
        QString windowsDefaultPath = QDir::toNativeSeparators("C:/Program Files (x86)/Guitar Pro 5/GP5.exe");
        if(!QFile::exists(windowsDefaultPath))
        {
            // Displays a QDialog so that the user can specify its audacity location
            QMessageBox msgBox;
            msgBox.setText("This application requires the software Audacity to be installed on your computer.");
            msgBox.setInformativeText("Please specify where it is located or download it from: ");
            msgBox.setStandardButtons(QMessageBox::Open);
            msgBox.setDefaultButton(QMessageBox::Open);
            msgBox.exec();
            return QFileDialog::getOpenFileName(&msgBox, QString("Locate GuitarPro"),
                                                           QDir::rootPath(),
                                                            QString("Application (*.exe)"));
        }else{
            return windowsDefaultPath;
        }
    }else{
        // Same thing but with Mac default path
    }
    return QString("Error");
}

QString Parameters::getMatlabPath()
{
    if(this->_os==Windows)
    {
//        QRegExp rx("R(\\d+)(.)");
//        rx.indexIn();
//        QStringList list = rx.capturedTexts();

        QString windowsDefaultPath = QDir::toNativeSeparators("C:/Program Files/MATLAB");
        QDir mainDir(windowsDefaultPath);
        mainDir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
        mainDir.setNameFilters(QStringList("R*"));  // The foler is under the form R201X(a|b)
        QStringList subfolders = mainDir.entryList();
        QStringList fullPath;
        fullPath << windowsDefaultPath
                 << subfolders.at(0)
                 << "bin"
                 << "matlab.exe";
        windowsDefaultPath = fullPath.join(QDir::separator());
        if(!QFile::exists(windowsDefaultPath))
        {
            // Displays a QDialog so that the user can specify its audacity location
            QMessageBox msgBox;
            msgBox.setText("This application requires the software Audacity to be installed on your computer.");
            msgBox.setInformativeText("Please specify where it is located or download it from: ");
            msgBox.setStandardButtons(QMessageBox::Open);
            msgBox.setDefaultButton(QMessageBox::Open);
            msgBox.exec();
            return QFileDialog::getOpenFileName(&msgBox, QString("Locate Matlab"),
                                                QDir::rootPath(),
                                                QString("Application (*.exe)"));
        }else{
            return windowsDefaultPath;
        }
    }else{
        // Same thing but with Mac default path
    }
    return QString("Error");
}

void Parameters::runGentabScript(Format format)
{
    QStringList qslMatlabInstructions;
    qslMatlabInstructions << "fileName=" + _qsExportFileName
                          << "exportDir=" + _qsGeneratedTabsPath
                          << "audioFileName=" + _qsAudioFileName
                          << "run('" + _qsGentabPath + QDir::separator() + "gentab_stand_alone.m')"
                          << "exit;";
    QString qsMatlabInstruction = qslMatlabInstructions.join(';');

    if(this->_os==Windows)
    {
        QStringList qslWindowsInstructions;
        qslWindowsInstructions << _qsMatlabPath + QDir::toNativeSeparators("/bin/matlab.exe")
//                               << "-nodisplay"
//                               << "-nosplash"
//                               << "-nodesktop"
//                               << "-minimize"
                               << "-r"
                               << qsMatlabInstruction;
        QString qsWindowsInstruction = qslWindowsInstructions.join(' ');
    }else{
        // Same thing but with Mac cmd line
    }
}
