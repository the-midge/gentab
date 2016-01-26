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
    void selectPath();
    void onGenerateFileClicked();
private:
    Ui::MainWindow *ui;
    Parameters _param;
};

#endif // MAINWINDOW_H
