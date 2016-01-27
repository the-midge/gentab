#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "Parameters.h"

#include <QMainWindow>
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


private:
    Format getFormat();
    void setFormat(QString extension);
    Ui::MainWindow *ui;
    Parameters _param;
};

#endif // MAINWINDOW_H
