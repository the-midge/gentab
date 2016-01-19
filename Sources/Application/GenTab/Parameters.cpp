#include "Parameters.h"

#include <QFileDialog>
#include <QMessageBox>

Parameters::Parameters()
{
    readConfigFile();
    if(_qsAudacityPath.isEmpty())
        _qsAudacityPath=getAudacityPath();
    if(_qsGuitarProPath.isEmpty())
        _qsGuitarProPath=getGuitarProPath();
}


void Parameters::installUserFolders()
{
    _qsUserPath = QDir::homePath();
    QString userGentabPath = _qsUserPath + QDir::separator() + "GenTab";
    _qsAudacityProjectsPath = userGentabPath + QDir::separator() + "Audacity Projects";
    _qsRecordedAudioFilesPath = userGentabPath + QDir::separator() + "Recorded Audio Files";
    _qsGeneratedTabsPath = userGentabPath + QDir::separator() + "Generated Tabs";

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
           << _qsGuitarProPath.append('\n');

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
            }
            i++;
        }
    }
}

QString Parameters::getAudacityPath()
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
}

QString Parameters::getGuitarProPath()
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
}
