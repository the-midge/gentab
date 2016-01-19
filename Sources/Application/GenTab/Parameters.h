#ifndef PARAMETERS_H
#define PARAMETERS_H

#include <QString>
#include <QDir>
#include <QTextStream>
#include <QIODevice>

class Parameters
{
public:
    Parameters();
    void readConfigFile();
    void installUserFolders();
    void writeConfigFile();
    QString getAudacityPath();
    QString getGuitarProPath();

    QString _qsAudacityProjectsPath;
    QString _qsRecordedAudioFilesPath;
    QString _qsGeneratedTabsPath;
    QString _qsAudacityPath;
    QString _qsGuitarProPath;

    QString _qsUserPath;
    QString _qsGentabPath;
};

#endif // PARAMETERS_H
