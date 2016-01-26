#ifndef PARAMETERS_H
#define PARAMETERS_H

#include <QString>
#include <QDir>
#include <QTextStream>
#include <QIODevice>


enum OS{Windows, MacOSx};
enum Format{MIDI, GP4};

class Parameters
{
public:
    Parameters();
    void readConfigFile();
    void installUserFolders();
    void writeConfigFile();
    void runGentabScript(Format format);

    bool setExportFileName(QString newExportFileName);
    bool setAudioFileName(QString newAudioFileName);

    // return if the file is not valid
    QString getAudacityPath();
    QString getGuitarProPath();
    QString getMatlabPath();

    //temporary fileNames (change at each generation)
    QString _qsExportFileName;
    QString _qsAudioFileName;

    QString _qsAudacityProjectsPath;
    QString _qsRecordedAudioFilesPath;
    QString _qsGeneratedTabsPath;

    QString _qsAudacityPath;
    QString _qsGuitarProPath;
    QString _qsMatlabPath;

    QString _qsUserPath;
    QString _qsGentabPath;

    OS _os;
};

#endif // PARAMETERS_H
