#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "Parameters.h"

#include <QFileSystemWatcher>
#include <QMainWindow>
#include <QProgressBar>
#include <QPushButton>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    
private slots:
    void openAudacity();
    void newAudacityProject();
    void onGenerateFileClicked();
    void onAudacityProjectTextChanged(QString newText);
    void onWaveFileTextChanged(QString newText);
    void onFileNameChanged(QString qsNewFileName);
    void exploreAudacity();
    void playWave();
    void loadWave();
    void onExploreFileName();
    void onLogFileChanged(QString logFile);

private:
    Format getFormat();
    void setFormat(QString extension);
    Ui::MainWindow *ui;
    Parameters _param;
    QFileSystemWatcher _fileWatcher;
    QProgressBar _progressBar;

};

#endif // MAINWINDOW_H
